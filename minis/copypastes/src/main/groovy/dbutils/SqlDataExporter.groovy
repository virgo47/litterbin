package dbutils

import java.nio.charset.StandardCharsets
import java.sql.Clob

import static dbutils.DbInit.list

class SqlDataExporter {

	String dir = ""

	/** Names we want to escape. */
	List specialNames = ['order', 'action', 'default', 'group', 'user', 'sign', 'from', 'to', 'key']

	def sqlOutput // stateful!

	def dumpTables(String outFileName, String... tableSpecs) {
		println "\nPreparing $outFileName"
		sqlOutput = new BufferedWriter(
			new OutputStreamWriter(
				new FileOutputStream(dir + outFileName), StandardCharsets.UTF_8))

		sqlOutput.println '-- noinspection SqlResolveForFile'
		sqlOutput.println '-- Generated with SqlDataExporter.groovy\n'
		tableSpecs.each {
			dumpTable(it)
		}
		sqlOutput.close()
	}

	def dumpTablesStdout(String... tableSpecs) {
		sqlOutput = System.out
		sqlOutput.println "-- EXPORTED DATA (stdout)"
		tableSpecs.each {
			dumpTable(it)
		}
	}

	def dumpTable(String tableSpec) {
		println "Dumping: $tableSpec"
        sqlOutput.println "\n-- Table: $tableSpec"
		def tableName = tableSpec.split(/\s+/)[0]

		def list = list(tableSpec)
		def count = 0
		def insertHeaderEach = 100
		def total = list.size()
		list.each {
			if (count % insertHeaderEach == 0) {
			sqlOutput.print "INSERT INTO $tableName ("
			sqlOutput.print it.keySet()
				.collect { columnName((String) it) }
				.join(", ")
				sqlOutput.print ')\nVALUES\n ('
			}
			sqlOutput.print it.values()
				.collect { processValue(it) }
				.join(", ")
			count++
			if (count % insertHeaderEach == 0 || count == total) {
			sqlOutput.println ');'
			} else {
				sqlOutput.print '),\n  ('
			}
		}
		sqlOutput.println()
		sqlOutput.flush()
	}

	def columnName(String column) {
		return specialNames.contains(column) ? "\"$column\"" : column
	}

	static def processValue(Object value) {
		if (value == null) {
			return "NULL"
		}
		if (value instanceof Number) {
			return value
		}
		if (value instanceof Clob) {
			value = value.getSubString(1L, (int) value.length())
		}
		String strValue = value.toString().replace("'", "''")
		if (value instanceof Date && strValue.endsWith(" 00:00:00.0")) {
			strValue -= " 00:00:00.0"
		}
		return "'$strValue'"
	}
}