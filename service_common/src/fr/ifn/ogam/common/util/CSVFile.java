package fr.ifn.ogam.common.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Utility class used to load a CSV file.
 * 
 * CSV file is parsed during instantiation. Data is stored in a array
 */
public class CSVFile {

	// Number of rows in the file (non empty lines)
	private int rowsCount = 0;

	// Number of lines in the file
	private int fileLineNumber = 0;

	// Number of columns in the file
	private int colsCount = -1;

	// The current line of the reader
	private int currentLine = 0;

	// The location of the CSV file
	private String path = "";

	// The file reader
	private BufferedReader reader;

	// The cell separator
	private final static char CELL_SEPARATOR = ';';

	// The text separator (used to avoid breaking cells when a separator is inside a String)
	private final static char TEXT_SEPARATOR = '"';

	/**
	 * Constructor.
	 * 
	 * @param path
	 *            le chemin du fichier à parser.
	 */
	public CSVFile(String aPath) throws Exception {

		this.path = aPath;

		// Parse the file
		parseFile(aPath);

		// Initialise the reader
		this.reader = new BufferedReader(new FileReader(this.path));

	}

	/**
	 * Parse the file a first time and get info about the number of lines and columns.
	 * 
	 * @param reader
	 *            A reader on the file
	 */
	private void parseFile(String path) throws Exception {

		FileReader fileReader = new FileReader(this.path);
		BufferedReader buffReader = new BufferedReader(fileReader);
		if (buffReader != null) {
			try {
				String tempLine = buffReader.readLine();
				while (tempLine != null) {
					if (tempLine != null && !tempLine.trim().startsWith("//") && !tempLine.trim().equals("")) {
						parseLine(tempLine);
					}
					fileLineNumber++;
					tempLine = buffReader.readLine();
				}
			} catch (IOException e) {
				System.err.println("Error reading CSV file: " + e.toString());
			} finally {
				try {
					buffReader.close();
				} catch (IOException e) {
					System.err.println("Erreur closing CSV file: " + e.toString());
				}
			}
		}
	}

	/**
	 * Reset the reader.
	 */
	public void reset() throws Exception {

		// Reset the line index
		this.currentLine = 0;

		// Close the old reader if needed
		try {
			this.reader.close();
		} catch (IOException e) {
			System.err.println("Erreur closing CSV file: " + e.toString());
		}

		// Reset the reader
		this.reader = new BufferedReader(new FileReader(this.path));
	}

	/**
	 * Close the reader.
	 */
	public void close() throws Exception {

		// Close the old reader if needed
		try {
			this.reader.close();
		} catch (IOException e) {
			System.err.println("Erreur closing CSV file: " + e.toString());
		}

	}

	/**
	 * Return the next line of data.
	 * 
	 * @return null if no data left
	 */
	public String[] readNextLine() throws Exception {

		// Read next line
		String tempLine = this.reader.readLine();
		while (tempLine != null) {

			// Skip comment and empty lines
			if (!tempLine.trim().startsWith("//") && !tempLine.trim().equals("")) {

				String[] data = new String[this.colsCount];

				// Split the content of the line
				int lineColCount = 0;
				int cursorBegin = 0;
				int cursorEnd = tempLine.indexOf(CELL_SEPARATOR);
				while (cursorBegin > -1) {
					while (cursorEnd != -1 && tempLine.charAt(cursorBegin) == TEXT_SEPARATOR && tempLine.charAt(cursorEnd - 1) != TEXT_SEPARATOR) {
						cursorEnd = tempLine.indexOf(CELL_SEPARATOR, cursorEnd + 1);
					}
					if (cursorEnd == -1) {
						data[lineColCount] = StringUtils.trimQuotes(tempLine.substring(cursorBegin));
						cursorBegin = cursorEnd;

					} else {
						data[lineColCount] = StringUtils.trimQuotes(tempLine.substring(cursorBegin, cursorEnd));
						cursorBegin = cursorEnd + 1;
					}
					cursorEnd = tempLine.indexOf(CELL_SEPARATOR, cursorBegin);
					lineColCount++;
				}

				this.currentLine++;

				return data;
			} else {
				this.currentLine++;
			}
			tempLine = this.reader.readLine();
		}

		return null; // no data left

	}

	/**
	 * Parse a line of data to get the number of columns.
	 * 
	 * @param tempLine
	 *            one line
	 */
	private void parseLine(String tempLine) throws Exception {
		if (tempLine == null) {
			return;
		}

		if (tempLine.trim().length() == 0) {
			return;
		}

		// Increase the number of rows containing actual data
		this.rowsCount++;

		// Split the line using CELL_SEPERATOR and not breaking inside TEXT_SEPARATOR
		int lineColCount = 0;
		int cursorBegin = 0;
		int cursorEnd = tempLine.indexOf(CELL_SEPARATOR);
		while (cursorBegin > -1) {
			while (cursorEnd != -1 && tempLine.charAt(cursorBegin) == TEXT_SEPARATOR && tempLine.charAt(cursorEnd - 1) != TEXT_SEPARATOR) {
				cursorEnd = tempLine.indexOf(CELL_SEPARATOR, cursorEnd + 1);
			}
			if (cursorEnd == -1) {
				cursorBegin = cursorEnd;
			} else {
				cursorBegin = cursorEnd + 1;
			}
			cursorEnd = tempLine.indexOf(CELL_SEPARATOR, cursorBegin);
			lineColCount++;
		}

		if (this.getColsCount() == -1) {
			// Initialise the col count
			this.colsCount = lineColCount;
		} else {
			// check if col count is consistent
			if (this.colsCount != lineColCount) {
				throw new InconsistentNumberOfColumns("Col count is not consistant (line " + this.fileLineNumber + " expected " + this.colsCount + " but got "
						+ lineColCount);
			}
		}

	}

	/**
	 * Returns the colsCount.
	 * 
	 * @return int
	 */
	public int getColsCount() {
		return colsCount;
	}

	/**
	 * Returns the rowsCount.
	 * 
	 * @return int
	 */
	public int getRowsCount() {
		return rowsCount;
	}

	/**
	 * Returns the fileLineNumber.
	 * 
	 * @return int
	 */
	public int getFileLineNumber() {
		return fileLineNumber;
	}

	/**
	 * @return the currentLine
	 */
	public int getCurrentLine() {
		return currentLine;
	}
	
	/**
	 * Returns the path.
	 * @return
	 */
	public String getPath() {
		return path ;
	}

}
