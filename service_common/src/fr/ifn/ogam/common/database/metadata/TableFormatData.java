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

import java.util.ArrayList;
import java.util.List;

/**
 * A table format.
 * 
 * Describes the table.
 */
public class TableFormatData extends FormatData {

	/**
	 * The physical name of the table.
	 */
	private String tableName;

	/**
	 * The name of the schema.
	 */
	private String schemaCode;

	/**
	 * The list of primary keys of the table.
	 */
	private List<String> primaryKeys = new ArrayList<String>();
	
	/**
	 * The label of the table format.
	 */
	private String label ;

	/**
	 * @return the tableName
	 */
	public String getTableName() {
		return tableName;
	}

	/**
	 * @param tableName
	 *            the tableName to set
	 */
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	/**
	 * @return the schemaCode
	 */
	public String getSchemaCode() {
		return schemaCode;
	}

	/**
	 * @param schemaCode
	 *            the schemaCode to set
	 */
	public void setSchemaCode(String schemaCode) {
		this.schemaCode = schemaCode;
	}

	/**
	 * @return the primaryKeys
	 */
	public List<String> getPrimaryKeys() {
		return primaryKeys;
	}

	/**
	 * @param primaryKeys
	 *            the primaryKeys to set
	 */
	public void setPrimaryKeys(List<String> primaryKeys) {
		this.primaryKeys = primaryKeys;
	}

	/**
	 * @param key
	 *            the key to add
	 */
	public void addPrimaryKey(String key) {
		this.primaryKeys.add(key);
	}
	
	/**
	 * Get label
	 * @return
	 */
	public String getLabel() {
		return label ;
	}
	
	
	/**
	 * Set label
	 * @param label
	 * @return
	 */
	public void setLabel(String label) {
		this.label = label ;
	}

	/**
	 * Return a String description of the Object.
	 * 
	 * @return the string
	 */
	@Override
	public String toString() {
		return getTableName();
	}

}
