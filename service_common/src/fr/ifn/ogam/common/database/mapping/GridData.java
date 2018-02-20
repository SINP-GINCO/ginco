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
package fr.ifn.ogam.common.database.mapping;

/**
 * Describe a grid.
 */
public class GridData {

	// Logical name of the grid
	String gridName;

	// Label of the grid
	String gridLabel;

	// Name of PostGIS table containing the geometry
	String gridTable;

	// Name of the column of the location table containing the cell id	
	String locationColumn;

	// Logical name of the mapserver layer corresponding to the aggregation on this grid
	String aggregationLayerName;

	/**
	 * @return the gridName
	 */
	public String getGridName() {
		return gridName;
	}

	/**
	 * @param gridName
	 *            the gridName to set
	 */
	public void setGridName(String gridName) {
		this.gridName = gridName;
	}

	/**
	 * @return the gridLabel
	 */
	public String getGridLabel() {
		return gridLabel;
	}

	/**
	 * @param gridLabel
	 *            the gridLabel to set
	 */
	public void setGridLabel(String gridLabel) {
		this.gridLabel = gridLabel;
	}

	/**
	 * @return the gridTable
	 */
	public String getGridTable() {
		return gridTable;
	}

	/**
	 * @param gridTable
	 *            the gridTable to set
	 */
	public void setGridTable(String gridTable) {
		this.gridTable = gridTable;
	}

	/**
	 * @return the locationColumn
	 */
	public String getLocationColumn() {
		return locationColumn;
	}

	/**
	 * @param locationColumn
	 *            the locationColumn to set
	 */
	public void setLocationColumn(String locationColumn) {
		this.locationColumn = locationColumn;
	}

	/**
	 * @return the aggregationLayerName
	 */
	public String getAggregationLayerName() {
		return aggregationLayerName;
	}

	/**
	 * @param aggregationLayerName
	 *            the aggregationLayerName to set
	 */
	public void setAggregationLayerName(String aggregationLayerName) {
		this.aggregationLayerName = aggregationLayerName;
	}

}
