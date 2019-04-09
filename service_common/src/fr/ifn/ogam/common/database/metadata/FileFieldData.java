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
 * A file field (a column in a CSv file).
 */
public class FileFieldData extends FieldData {

	/**
	 * Indicate if the field is mandatory.
	 */
	private Boolean isMandatory;

	/**
	 * The mask of the field.
	 */
	private String mask;

	/**
	 * The label of the imported CSV file columns.
	 */
	private String labelCSV;
	
	/**
     * The defaultValue of the imported CSV file columns.
    */
      private String defaultValue;
	
	/**
	 * @return the isMandatory
	 */
	public Boolean getIsMandatory() {
		return isMandatory;
	}

	/**
	 * @param isMandatory
	 *            the isMandatory to set
	 */
	public void setIsMandatory(Boolean isMandatory) {
		this.isMandatory = isMandatory;
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

	/**
	 * @return the labelCSV
	 */
	public String getLabelCSV() {
		return labelCSV;
	}

	/**
	 * @param labelCSV
	 *            the label of the CSV columns
	 */
	public void setLabelCSV(String labelCSV) {
		this.labelCSV = labelCSV;
	}
	
	/**
     * @return the defaultValue
     */
 	public String getDefaultValue() {
		return defaultValue;
	}

    /**
     * @param defaultValue
     *            the defaultValue of the CSV columns
     */
	public void setDefaultValue(String defaultValue) {
    	this.defaultValue = defaultValue;
    }
	
}
