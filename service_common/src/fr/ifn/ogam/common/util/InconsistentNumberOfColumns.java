package fr.ifn.ogam.common.util;

/**
 * Exception thrown when the number of columns in the CSV file changes from line to line.
 */
public class InconsistentNumberOfColumns extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public InconsistentNumberOfColumns() {
		// TODO Auto-generated constructor stub
	}

	public InconsistentNumberOfColumns(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public InconsistentNumberOfColumns(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	public InconsistentNumberOfColumns(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
