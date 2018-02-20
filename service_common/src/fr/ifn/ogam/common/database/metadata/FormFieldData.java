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
package fr.ifn.ogam.common.database.metadata;

/**
 * A form field.
 */
public class FormFieldData extends FieldData {

	/**
	 * The input type of the field (SELECT, TEXT, ...).
	 */
	private String inputType;

	/**
	 * True if the field is a criteria.
	 */
	private Boolean isCriteria;

	/**
	 * True if the field is a result.
	 */
	private Boolean isResult;

	/**
	 * True if the field is a default criteria.
	 */
	private Boolean isDefaultCriteria;

	/**
	 * True if the field is a default result.
	 */
	private Boolean isDefaultResult;

	/**
	 * Default value for the criteria.
	 */
	private String defaultValue;

	/**
	 * The number of decimals for a numeric value.
	 */
	private Integer decimals;

	/**
	 * the mask (for dates).
	 */
	private String mask;

	/**
	 * @return the inputType
	 */
	public String getInputType() {
		return inputType;
	}

	/**
	 * @param inputType
	 *            the inputType to set
	 */
	public void setInputType(String inputType) {
		this.inputType = inputType;
	}

	/**
	 * @return the isCriteria
	 */
	public Boolean getIsCriteria() {
		return isCriteria;
	}

	/**
	 * @param isCriteria
	 *            the isCriteria to set
	 */
	public void setIsCriteria(Boolean isCriteria) {
		this.isCriteria = isCriteria;
	}

	/**
	 * @return the isResult
	 */
	public Boolean getIsResult() {
		return isResult;
	}

	/**
	 * @param isResult
	 *            the isResult to set
	 */
	public void setIsResult(Boolean isResult) {
		this.isResult = isResult;
	}

	/**
	 * @return the isDefaultCriteria
	 */
	public Boolean getIsDefaultCriteria() {
		return isDefaultCriteria;
	}

	/**
	 * @param isDefaultCriteria
	 *            the isDefaultCriteria to set
	 */
	public void setIsDefaultCriteria(Boolean isDefaultCriteria) {
		this.isDefaultCriteria = isDefaultCriteria;
	}

	/**
	 * @return the isDefaultResult
	 */
	public Boolean getIsDefaultResult() {
		return isDefaultResult;
	}

	/**
	 * @param isDefaultResult
	 *            the isDefaultResult to set
	 */
	public void setIsDefaultResult(Boolean isDefaultResult) {
		this.isDefaultResult = isDefaultResult;
	}

	/**
	 * @return the defaultValue
	 */
	public String getDefaultValue() {
		return defaultValue;
	}

	/**
	 * @param defaultValue
	 *            the defaultValue to set
	 */
	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	/**
	 * @return the decimals
	 */
	public Integer getDecimals() {
		return decimals;
	}

	/**
	 * @param decimals
	 *            the decimals to set
	 */
	public void setDecimals(Integer decimals) {
		this.decimals = decimals;
	}

	/**
	 * @return the mask
	 */
	public String getMask() {
		return mask;
	}

	/**
	 * @param mask
	 *            the mask to set
	 */
	public void setMask(String mask) {
		this.mask = mask;
	}

}
