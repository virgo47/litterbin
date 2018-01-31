package dbutils

import groovy.sql.GroovyRowResult
import groovy.sql.Sql

import java.sql.Timestamp

class DbInit {

	static Sql sql

	/**
	 * If false, then map "defaults" in findOrCreate is used only for inserts.
	 * If true, it is used to update as well.
	 */
	static def updateWithDefaults = false

	/** If true, prints debug output, SQL, params, etc. */
	static def verbose = false

	/** If true, does not execute insert/update/delete. */
	static def dryRun = false

	/** If true, dates are converted to timestamp - handy for old MSSQL 2005. */
	static def datetimeOnly = true

	private static int inserts
	private static int deletes
	private static int deletedRows
	private static int updates
	private static int updatedRows

	static void connect(url, user, password) {
		if (sql != null) {
			println "=== Closing existing connection $sql"
			sql.close()
		}
		println "=== Connecting to $url, user $user"
		sql = Sql.newInstance(url, user, password)
		inserts = deletes = deletedRows = updates = updatedRows = 0
	}

	/**
	 * Universal (nearly) find/update/create method.
	 * <ul>
	 * <li>Object is found in a table using selector map.
	 * <li>If insertParams are present, object is updated accordingly.
	 * <li>If insertParams is null object (or null if not found) is return - no insert/update
	 * is executed.
	 * <li>If object is not found and insertParams are not null (they can be if we only want to
	 * find object) we try to insert it.
	 * <li>If insert is required provide at least [:] as insertParams, preferably specify also
	 * defaults for user convenience.
	 * <li>If insert is executed effective insertParams are constructed as: selector <u>without
	 * any keys with # prefix (see lower how that works)</u> + defaults + insertParams. For this
	 * reason any selector entries with operators (for instance '#flags & 2 = ?':2) should appear
	 * with matching explicit value in insertParams (e.g. flags:3, that would be found by condition
	 * flags & 2 = 2). Otherwise subsequent runs may not find previously created entity - which may
	 * cause constraint violation or their repetition. Not sure what is worse.
	 * <li>If object is found but differences are detected against insertMap it will be updated.
	 * <li>Default map is used for inserts or for updates as well, based on
	 * {@link #updateWithDefaults} boolean flag. Can be null, then acts like [:].
	 * In any case, values in insertParams always override defaults.
	 * <li>If insert is executed, id is always returned (or list of them if there is not
	 * single autoincrement).
	 * <li>If entity is just found or updated, id is returned based on "resultProperty"
	 * parameter, that defaults to 'id'.
	 * <li>If resultProperty is set to null, the whole object is returned.
	 * <li>Selector implies = operation, but if it starts with # anything can be inserted into the
	 * SQL instead of column name (with initial # being trimmed), but ? placeholder must be placed
	 * explicitly if needed (as part of the key). If # is used and value is null, it is NOT added
	 * to the list of parameters. Examples:<br/>
	 * '#col>5':null (or '#col>?':5, or any other function in the key)<br/>
	 * '#EXISTS (select *...)':null<br/>
	 * '#col is null' (this is actually equivalent of 'col':null in selectors)<br/>
	 * '#col is not null' (cannot be done other way)<br/>
	 * '#(col is null OR col > ?)':currentTime<br/>
	 * TODO: do we want to support mulitiple ? in key and list of values? it should be possible :-)
	 * <li>Insert params work bit different - initial '#' in the key is stripped (just like for
	 * WHERE parts) but the value is put literally into the SQL. E.g. '#ID': 'NEXT VALUE FOR SQ_XXX'.
	 * </ul>
	 * Column list and values with question-marks is constructed automatically from merged
	 * selector and insertParams map.
	 */
	static Object findOrCreate(String tableName, Map selector,
		Map insertParams = null, Map defaults = [:], String resultProperty = 'id')
	{
		defaults = defaults ?: [:]

		// here we construct where part and list of actual parameters
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		def query = "select * from $tableName where $wherePart"
		debug(query, whereParams)
		def object = sql.firstRow(query, whereParams)
		def objectOrId = objectOrId(object, resultProperty)
		if (object != null) {
			// defaults must always go first in +, so they can be overridden
			if (insertParams != null
				&& updateNeeded(object, (updateWithDefaults ? defaults : [:]) + insertParams))
			{
				// UPDATE time :-)
				updateInternal(tableName, wherePart, whereParams, defaults + insertParams)
				println "$tableName UPDATED (id=$objectOrId)"
			}
			return objectOrId
		}
		if (insertParams == null) {
			println "$tableName NOT FOUND"
			return null
		}

		// here we construct column list, question marks and list of actual parameters
		def pureSelector = purifySelector(selector)
		return insert(tableName, pureSelector + defaults + insertParams)
	}

	private static int updateInternal(
		String tableName, String wherePart, List<Object> whereParams, Map params)
	{
		def (String setPart, List<Object> updateParams) = processUpdateMap(params)
		updates++
		def finalUpdateParams = updateParams + whereParams
		def query = (wherePart != null
			? "update $tableName set $setPart where $wherePart"
			: "update $tableName set $setPart")
		debug(query, finalUpdateParams)
		def cnt = dryRun ? 0 : sql.executeUpdate(query, finalUpdateParams)
		updatedRows += cnt
		return cnt
	}

	/**
	 * Update table, where goes first, update params second
	 * (unlike SQL, but in line with {@link #findOrCreate(java.lang.String, java.util.Map)}).
	 */
	static int update(String tableName, Map selector, Map params) {
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		def cnt = updateInternal(tableName, wherePart, whereParams, params)
		println "$tableName UPDATED: $cnt"
		return cnt
	}

	private static Object objectOrId(GroovyRowResult object, String resultProperty) {
		resultProperty != null && object != null ? object[resultProperty] : object
	}

	/** Removes any keys with operators and returns "purified" map. */
	private static Map purifySelector(Map map) {
		def result = [:]
		for (String key : map.keySet()) {
			if (key.startsWith('#')) {
				continue
			} // skip complicated selectors

			result.put(key, map.get(key))
		}
		return result
	}

	/** Selects first matching object from the table based on selector. */
	static Object findFirst(String tableName, Map selector) {
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		def query = "select * from $tableName where $wherePart"
		debug(query, whereParams)
		return sql.firstRow(query, whereParams)
	}

	/**
	 * Selects first matching object from the table based on selector,
	 * throws exception if not exactly 1 result.
	 */
	static Object findUniqueMandatory(String tableName, Map selector) {
		def results = findUnique(tableName, selector)
		if (!results) {
			throw new RuntimeException("No result for $tableName: $selector")
		}
		return results
	}

	/**
	 * Selects first matching object from the table based on selector.
	 * Throws exception if more than one result, returns null if nothing found.
	 */
	static Object findUnique(String tableName, Map selector) {
		def results = list(tableName, selector)
		if (results.size() > 1) {
			throw new RuntimeException("Too many results for $tableName: $selector")
		}
		return results.isEmpty() ? null : results[0]
	}

	/** Returns list from table based on selector. */
	static Object count(String tableName, Map selector = [:]) {
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		def query = "select count(*) from $tableName" + (wherePart ? " where $wherePart" : "")
		debug(query, whereParams)
		return sql.rows(query, whereParams)[0][0]
	}

	/** Returns list from table based on selector. */
	static List<GroovyRowResult> list(String tableName, Map selector = [:], String top = '') {
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		def query = "select $top * from $tableName" + (wherePart ? " where $wherePart" : "")
		debug(query, whereParams)
		return sql.rows(query, whereParams)
	}

	/** Deletes from table based on selector. */
	static int delete(String tableName, Map selector = null) {
		def (String wherePart, List<Object> whereParams) = processSelector(selector)
		// we need to take out the Gstring from executeUpdate, because it's interpreted
		// there more than we want (IN would not work)
		def query = (selector != null
			? "delete from $tableName where $wherePart"
			: "delete from $tableName")
		debug(query, whereParams)
		deletes++
		def cnt = dryRun ? 0 : sql.executeUpdate(query, whereParams)
		deletedRows += cnt
		println "$tableName DELETED: $cnt"
		return cnt
	}

	private static List processSelector(Map selector) {
		return processSelectorOrUpdate(selector, true)
	}

	static boolean updateNeeded(GroovyRowResult rowResult, Map requestedValues) {
		for (entry in requestedValues.entrySet()) {
			def currentValue = rowResult.get(entry.getKey())
			def requestedValue = entry.getValue()
			if (currentValue != requestedValue) {
				return true
			}
		}
		return false
	}

	private static List processUpdateMap(Map params) {
		return processSelectorOrUpdate(params, false)
	}

	private static List processSelectorOrUpdate(Map selector, boolean where) {
		String separator = where ? ' and ' : ','
		if (selector == null) {
			return [null, []]
		}
		def keySet = selector.keySet()
		def sb = new StringBuilder()
		def params = []
		for (String key in keySet) {
			if (sb.length() > 0) {
				sb.append(separator)
			}
			def colWithOp = key
			def value = selector.get(key)
			if (colWithOp.startsWith('#')) {
				sb.append(colWithOp.substring(1).trim())
					if (value) {
					if (value instanceof Collection) {
						params.addAll(value)
					} else {
						params.add(value)
					}
				}
			} else if (value != null || !where) {
				sb.append(colWithOp).append(' =')
			sb.append(' ?')
			params.add(value)
			} else {
				// value is null, instead of = we will generate IS NULL which is expected behavior
				// this works only for WHERE, not for SET clause of update
				sb.append(colWithOp).append(' IS NULL')
			}
		}
		return [sb.toString(), params]
	}

	/** Simple insert into table, no default values. */
	static Object insert(String tableName, Map params) {
		def (String insertColumns, String questionMarks, List<Object> insertParams) = processInsertMap(params)
		def query = 'insert into ' + tableName +
			' (' + insertColumns + ') values (' + questionMarks + ')'
		debug(query, insertParams)
		if (dryRun) {
			return null
		}

		inserts++
		def insert = sql.executeInsert(query, insertParams)
		if (!insert) {
			return null
		}

		// lastly we extract single key of possible, otherwise we return the whole row
		// of returned autoincrement values (unlikely)
		def id = insert[0]
		if (id.size() == 1) {
			id = id[0]
			println "$tableName INSERTED (id=$id)"
		} else {
			println "$tableName INSERTED (no automatic ID)"
		}
		return id
	}

	private static List processInsertMap(Map insertParams) {
		def insertColumns = new StringBuilder()
		def valuesPart = new StringBuilder()
		def params = []
		for (key in insertParams.keySet()) {
			if (valuesPart.length() > 0) {
				insertColumns.append(', ')
				valuesPart.append(', ')
			}

			def value = insertParams.get(key)
			if (key.startsWith('#')) {
				key = key.substring(1)
				valuesPart.append(value) // literally
			} else {
				valuesPart.append('?')
				params.add(value)
		}

			insertColumns.append(key)
		}
		return [insertColumns, valuesPart.toString(), params]
	}

	/** Executes provided query - this is NOT guarded by dryRun feature! */
	static void query(String query) {
		sql.execute(query)
	}

	static void joinWithMany(String relationTable, String oneIdColumn,
		String manyIdColumn, Integer oneId, List<Integer> manyIds)
	{
		if (manyIds != null) {
			def currentManyIds = list(relationTable, [(oneIdColumn): oneId]).collect {
				it[manyIdColumn]
			}
			def missingIds = manyIds - currentManyIds
			if (!missingIds.isEmpty()) {
				println "Adding missing IDs: " + missingIds
				missingIds.forEach {
					insert(relationTable, [(oneIdColumn): oneId, (manyIdColumn): it])
				}
			}
			def excessiveIds = currentManyIds - manyIds
			if (!excessiveIds.isEmpty()) {
				println "Removing excessive IDs: " + excessiveIds
				excessiveIds.forEach {
					delete(relationTable, [(oneIdColumn): oneId, (manyIdColumn): it])
				}
			}
		}
	}

	static def parseIsoDate(String date) {
		return sqlDateType(Date.parse('yyyy-MM-dd', date))
	}

	static def sqlDateType(Object temporal) {
		long value = 0
		if (temporal instanceof Date) {
			value = temporal.time
		}
		return (DbInit.datetimeOnly
			? new Timestamp(value)
			: new java.sql.Date(value))
	}

	private static void debug(Object... objectsOrMessages) {
		if (verbose) {
			print "DEBUG:"
			objectsOrMessages.each { println " " + it }
		}
	}

	static void printStatistics() {
		println "\ninserts = $inserts"
		println "updates = $updates (rows $updatedRows)"
		println "deletes = $deletes (rows $deletedRows)"
		if (dryRun) {
			println "DRY RUN, no updates to DB made"
		}
	}

	/** Reading password with System.console, falling back to System.in, if console is null. */
	static String readPassword(String prompt = "Password: ") throws IOException {
		Console console = System.console()
		if (console) {
			return new String(console.readPassword(prompt))
		}

		// fallback without console
		System.out.print(prompt)
		int max = 50
		byte[] b = new byte[max]

		int l = System.in.read(b)
		l-- //last character is \n
		if (l > 0) {
			byte[] e = new byte[l]
			System.arraycopy(b, 0, e, 0, l)
			return new String(e)
		} else {
			return null
		}
	}
}