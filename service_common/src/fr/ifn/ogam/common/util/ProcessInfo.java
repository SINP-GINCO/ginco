package fr.ifn.ogam.common.util;

/**
 * Information about a process.
 */
public class ProcessInfo {

	int exitValue;

	String output;

	String error;

	/**
	 * @return the exitValue
	 */
	public int getExitValue() {
		return exitValue;
	}

	/**
	 * @param exitValue
	 *            the exitValue to set
	 */
	public void setExitValue(int exitValue) {
		this.exitValue = exitValue;
	}

	/**
	 * @return the output
	 */
	public String getOutput() {
		return output;
	}

	/**
	 * @param output
	 *            the output to set
	 */
	public void setOutput(String output) {
		this.output = output;
	}

	/**
	 * @return the error
	 */
	public String getError() {
		return error;
	}

	/**
	 * @param error
	 *            the error to set
	 */
	public void setError(String error) {
		this.error = error;
	}

}
