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
 * A table (a node) in the hierarchy of tables.
 */
public class TableTreeData implements Comparable<Object> {

	private TableFormatData table;

	private TableFormatData parentTable;

	private List<String> keys = new ArrayList<String>();

	/**
	 * @return the table
	 */
	public TableFormatData getTable() {
		return table;
	}

	/**
	 * @param table
	 *            the table to set
	 */
	public void setTable(TableFormatData table) {
		this.table = table;
	}

	/**
	 * @return the parentTable
	 */
	public TableFormatData getParentTable() {
		return parentTable;
	}

	/**
	 * @param parentTable
	 *            the parentTable to set
	 */
	public void setParentTable(TableFormatData parentTable) {
		this.parentTable = parentTable;
	}

	/**
	 * @return the keys
	 */
	public List<String> getKeys() {
		return keys;
	}

	/**
	 * @param keys
	 *            the keys to set
	 */
	public void setKeys(List<String> keys) {
		this.keys = keys;
	}

	/**
	 * @param key
	 *            the key to add
	 */
	public void addKey(String key) {
		this.keys.add(key);
	}

	/**
	 * Return a String description of the Object.
	 * 
	 * @return the string
	 */
	@Override
	public String toString() {
		return getTable() + " / " + getParentTable() + " - " + getKeys();
	}

	/**
	 * Compare two TableTreeData for ordering.
	 * 
	 * @param o
	 *            the object to compare with
	 * @return the result of the comparison (-1, 0 or 1)
	 */
	public int compareTo(Object o) {
		if (this == o) {
			return 0;
		}
		if (o == null) {
			return 1;
		}
		if (getClass() != o.getClass()) {
			return 0;
		}
		TableTreeData other = (TableTreeData) o;
		return this.compareTo(other);
	}

	/**
	 * Generate the hashCode of the TableTreeData.
	 * 
	 * @return the hashCode of the object
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((table == null) ? 0 : table.hashCode());
		return result;
	}

	/**
	 * Compare two TableTreeData for equality.
	 * 
	 * @param obj
	 *            the object to compare with
	 * @return true if the two objects are equal
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		TableTreeData other = (TableTreeData) obj;
		if (table == null) {
			if (other.table != null) {
				return false;
			}
		} else if (!table.equals(other.table)) {
			return false;
		}
		return true;
	}

}
