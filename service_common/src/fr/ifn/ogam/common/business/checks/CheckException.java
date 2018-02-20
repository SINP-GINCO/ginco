/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 * 
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices. 
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents. 
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */
package fr.ifn.ogam.common.business.checks;

import java.util.HashMap;
import java.util.Map;

import fr.ifn.ogam.common.database.checks.ChecksDAO;

/**
 * Exception linked to a check.
 */
public class CheckException extends Exception {

	// Error Labels
	private static Map<Integer, String> errorLabels = new HashMap<Integer, String>();

	// Initialise the check error labels
	static {
		ChecksDAO checksDAO = new ChecksDAO();
		initialiseErrorLabels(checksDAO.getDescriptions());
	}

	/**
	 * Serial UID.
	 */
	private static final long serialVersionUID = -3450099086293043774L;

	// The check code
	private Integer checkCode = null;

	// The expected value
	private String expectedValue = null;

	// The found value
	private String foundValue = null;

	// The line number
	private Integer lineNumber = 0;

	// The source format
	private String sourceFormat = null;

	// The source data
	private String sourceData = null;

	// The submissionId
	private Integer submissionId = null;

	// The plot code
	private String plotCode = null;

	/**
	 * Constructor.
	 * 
	 * @param checkCode
	 *            the identifier of the check.
	 */
	public CheckException(Integer checkCode) {
		super(getErrorLabel(checkCode));
		this.checkCode = checkCode;
	}

	/**
	 * Constructor.
	 * 
	 * @param checkCode
	 *            the identifier of the check.
	 * @param message
	 *            the message of the check.
	 */
	public CheckException(Integer checkCode, String message) {
		super(message);
		this.checkCode = checkCode;
	}

	/**
	 * Initialise the error label table.
	 * 
	 * @param anErrorLabels
	 *            the map of error labels.
	 */
	public static void initialiseErrorLabels(Map<Integer, String> anErrorLabels) {
		errorLabels = anErrorLabels;
	}

	/**
	 * Return the label corresponding to a code.
	 * 
	 * @param checkCode
	 *            the identifier of the check.
	 * @return the corresponding label.
	 */
	public static String getErrorLabel(Integer checkCode) {
		String label = errorLabels.get(checkCode);
		if (label == null) {
			label = "Unknow error type";
		}
		return label;
	}

	/**
	 * Return the check identifier.
	 * 
	 * @return the check code
	 */
	public Integer getCheckCode() {
		return checkCode;
	}

	/**
	 * Set the check identifier.
	 * 
	 * @param checkCode
	 *            the checkCode to set
	 */
	public void setCheckCode(Integer checkCode) {
		this.checkCode = checkCode;
	}

	/**
	 * @return the expectedValue
	 */
	public String getExpectedValue() {
		return expectedValue;
	}

	/**
	 * @param expectedValue
	 *            the expectedValue to set
	 */
	public void setExpectedValue(String expectedValue) {
		this.expectedValue = expectedValue;
	}

	/**
	 * @return the foundValue
	 */
	public String getFoundValue() {
		return foundValue;
	}

	/**
	 * @param foundValue
	 *            the foundValue to set
	 */
	public void setFoundValue(String foundValue) {
		this.foundValue = foundValue;
	}

	/**
	 * @return the lineNumber
	 */
	public Integer getLineNumber() {
		return lineNumber;
	}

	/**
	 * @param lineNumber
	 *            the lineNumber to set
	 */
	public void setLineNumber(Integer lineNumber) {
		this.lineNumber = lineNumber;
	}

	/**
	 * @return the submissionId
	 */
	public Integer getSubmissionId() {
		return submissionId;
	}

	/**
	 * @param submissionId
	 *            the submissionId to set
	 */
	public void setSubmissionId(Integer submissionId) {
		this.submissionId = submissionId;
	}

	/**
	 * @return the sourceFormat
	 */
	public String getSourceFormat() {
		return sourceFormat;
	}

	/**
	 * @param sourceFormat
	 *            the sourceFormat to set
	 */
	public void setSourceFormat(String sourceFormat) {
		this.sourceFormat = sourceFormat;
	}

	/**
	 * @return the plotCode
	 */
	public String getPlotCode() {
		return plotCode;
	}

	/**
	 * @param plotCode
	 *            the plotCode to set
	 */
	public void setPlotCode(String plotCode) {
		this.plotCode = plotCode;
	}

	/**
	 * @return the sourceData
	 */
	public String getSourceData() {
		return sourceData;
	}

	/**
	 * @param sourceData
	 *            the sourceData to set
	 */
	public void setSourceData(String sourceData) {
		this.sourceData = sourceData;
	}

}
