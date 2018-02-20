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

/**
 * Provides a Geometry input field.
 * 
 * @class OgamDesktop.ux.form.field.GeometryField
 * @extends Ext.form.TriggerField
 * @constructor Create a new GeometryField
 * @param {Object} config
 * @xtype geometryfield
 */

Ext.define('OgamDesktop.ux.form.field.GeometryField',{
	extend: 'Ext.form.field.Text',
	xtype: 'geometryfield',

    /**
     * @event featureEditionValidated
     * Fires when the feature edition on the map is validated.
     */

    /**
     * @event featureEditionCancelled
     * Fires when the feature edition on the map is cancelled.
     */

	/*
	 * Internationalization.
	 */
	fieldLabel : 'Location',

	/**
	 * @cfg {Boolean} hideWKT if true hide the WKT value.
	 */
	hideWKT : false,

	/**
	 * @cfg {Boolean} editable false to prevent the user from typing text
	 *      directly into the field, the field will only respond to a click on
	 *      the trigger to set the value. (defaults to false).
	 */
	editable : false,

	/**
	 * The current state of the trigger.
	 * 
	 * @property isPressed
	 * @type {Boolean}
	 */
	isPressed : false,

	/**
	 * Set the visibility of the point button into the drawing toolbar
	 * Default to 'false'.
	 * 
	 * @property hideDrawPointButton
	 * @type {Boolean}
	 */
	hideDrawPointButton : false,

	/**
	 * Set the visibility of the line button into the drawing toolbar
	 * Default to 'false'.
	 * 
	 * @property hideDrawLineButton
	 * @type {Boolean}
	 */
	hideDrawLineButton : false,

	/**
	 * Set the visibility of the polygon button into the drawing toolbar
	 * Default to 'false'.
	 * 
	 * @property hideDrawPolygonButton
	 * @type {Boolean}
	 */
	hideDrawPolygonButton : false,

	/**
	 * Set the default activated drawing button into the drawing toolbar
	 * The possibles values are 'point','line' or 'polygon'.
	 * Default to 'polygon'.
	 *
	 * @property defaultActivatedDrawingButton
	 * @type {String}
	 */
	defaultActivatedDrawingButton : 'polygon',

	/**
	 * Set the visibility of the validate and the cancel buttons into the drawing toolbar
	 * Default to 'false'.
	 *
	 * @property hideValidateAndCancelButtons
	 * @type {Boolean}
	 */
	hideValidateAndCancelButtons : false,

	/**
	 * Forces the creation of a unique feature
	 * Default to 'false'.
	 *
	 * @property forceSingleFeature
	 * @type {Boolean}
	 */
	forceSingleFeature : false,

	triggers:  {
		editMapTrigger: {
			cls: 'o-ux-form-field-tools-map-addgeomcriteria',
			handler: function(field, trigger, event) {
				if(field.isPressed){
					field.onUnpress();
				} else {
					field.onPress();
				}
			}
		} 
	},

	/**
	 * Function handling the press event
	 * @private
	 */
	onPress : function () {
		if(!this.isPressed){
			this.getTrigger('editMapTrigger').getEl().addCls('x-form-trigger-click');
			this.isPressed = true;
			this.fireEvent('geomCriteriaPress', this);
		}
	},

	/**
	 * Function handling the unPress event
	 * @private
	 */
	onUnpress : function () {
		if(this.isPressed){
			this.getTrigger('editMapTrigger').getEl().removeCls('x-form-trigger-click');
			this.isPressed = false;
			this.fireEvent('geomCriteriaUnpress', this);
		}
	},

	/**
	 * Initialise the component.
	 * @private
	 */
	initComponent : function() {
		this.callParent(arguments);
	},

	/**
	 * On destroy of the geometry field, deactivate query tbar buttons
	 * @private
	 */
	onDestroy: function() {
		this.fireEvent('geomCriteriaDestroy', this);
		this.callParent(arguments);
	}
});