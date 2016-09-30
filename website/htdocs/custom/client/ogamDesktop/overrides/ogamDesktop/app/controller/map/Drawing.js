/**
 * This class defines a controller with actions related to the drawing on map
 */
Ext.define('Ginco.controller.map.Drawing', {
	override : 'OgamDesktop.controller.map.Drawing',

	/**
	 * Manage the geometry field press event
	 * 
	 * @private
	 * @param {Ext.form.field.Field}
	 *            field The pressed field
	 */
	onGeomCriteriaPress : function(field) {
		// Call ogam parent onGeomCriteriaPress function
		this.callParent(arguments);

		// Desactive on map click result feature info
		this.getMaptb().getController().onResultFeatureInfoButtonPress(null,
				false, null);
	},

	/**
	 * Manage the geometry field unpress event
	 * 
	 * @private
	 * @param {Ext.form.field.Field}
	 *            field The unpressed field
	 */
	onGeomCriteriaUnpress : function(field) {
		// Call ogam parent onGeomCriteriaUnpress function
		this.callParent(arguments);

		// Active on map click result feature info
		this.getMaptb().getController().onResultFeatureInfoButtonPress(null,
				true, null);
	}
});