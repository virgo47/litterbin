package tools

import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.DataFormatter
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.WorkbookFactory

/**
 * Groovy parser for Microsoft Excel spreadsheets.
 * Based on @author Goran Ehrsson's post: http://www.technipelago.se/content/technipelago/blog/44
 * Updated to handle XLSX document types and modified to support required cell types.
 */
class ExcelReader {

	def workbook
	def labels
	def row

	ExcelReader(String fileName) {
		DataFormatter dataFormatter = new DataFormatter()

		Row.metaClass.getAt = { int idx ->
			Cell cell = delegate.getCell(idx)

			if (!cell) {
				return null
			}

			return dataFormatter.formatCellValue(cell)
		}

		workbook = WorkbookFactory.create(new File(fileName))
	}

	def getSheet(idx) {
		def sheet
		if (!idx) {
			idx = 0
		}
		if (idx instanceof Number) {
			sheet = workbook.getSheetAt(idx)
		} else if (idx ==~ /^\d+$/) {
			sheet = workbook.getSheetAt(Integer.valueOf(idx))
		} else {
			sheet = workbook.getSheet(idx)
		}
		return sheet
	}

	def cell(idx) {
		if (labels && (idx instanceof String)) {
			idx = labels.indexOf(idx.toLowerCase())
		}
		return row[idx]
	}

	def propertyMissing(String name) {
		cell(name)
	}

	def eachLine(Map params = [:], Closure closure) {
		def offset = params.offset ?: 0
		def max = params.max ?: 9999999
		def sheet = getSheet(params.sheet)
		def rowIterator = sheet.rowIterator()
		def linesRead = 0

		if (params.labels) {
			labels = rowIterator.next().collect { it.toString().toLowerCase() }
		}
		offset.times { rowIterator.next() }

		closure.setDelegate(this)

		while (rowIterator.hasNext() && linesRead++ < max) {
			row = rowIterator.next()
			closure.call(row)
		}
	}
}
