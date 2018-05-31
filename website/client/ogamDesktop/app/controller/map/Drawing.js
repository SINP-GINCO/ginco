/**
 * This class defines a controller with actions related to the drawing on map
 */
Ext.define('OgamDesktop.controller.map.Drawing', {
	extend: 'Ext.app.Controller',

	/**
	 * The wkt format.
	 * @property wktFormat
	 * @type {ol.format.WKT}
	 */
	wktFormat : new ol.format.WKT({splitCollection:true}),

	/**
	 * The current edition field linked to the drawing toolbar
	 * @private
	 * @property
	 * @type OgamDesktop.ux.form.field.GeometryField
	 */
	currentEditionField: null,

	/**
	 * The previous edition field id linked to the drawing toolbar
	 * @private
	 * @property
	 * @type String
	 */
	previousEditionFieldId: null,

	/*
	 * The refs to get the views concerned
	 * and the control to define the handlers of the
	 * MapPanel, toolbar and LayersPanel events
	 */
	config: {
		refs: {
			mapcmp: 'mapcomponent',
			maptb: 'maptoolbar',
			consultationpanel : '#consultationTab',
			mapmainwin :  'map-mainwin'
		},
		control: {
			'geometryfield': {
				geomCriteriaPress: 'onGeomCriteriaPress',
				geomCriteriaUnpress: 'onGeomCriteriaUnpress',
				geomCriteriaDestroy: 'onGeomCriteriaUnpress'
			},
			'mapcomponent': {
				render: 'onMapComponentRender',
				drawingLayerFeatureChange: 'onDrawingLayerFeatureChange'
			},
			'maptoolbar':{
				validateFeatureEdition:'onValidateFeatureEdition',
				cancelFeatureEdition:'onCancelFeatureEdition'
			},
			'advanced-request button[action = submit]': {
				submitRequest: 'onSubmitRequest'
			}
		}
	},

	/**
	 * Initialize few controller attributes
	 * @private
	 */
	onMapComponentRender: function() {
		this.drawingLayer = this.getMapcmp().getController().getMapLayer('drawingLayer');
	},

	/**
	 * Manage the validateFeatureEdition event
	 * @private
	 */
	onValidateFeatureEdition: function() {
		this.currentEditionField.fireEvent('featureEditionValidated');
		this.unpressField();
	},

	/**
	 * Manage the cancelFeatureEdition event
	 * @private
	 */
	onCancelFeatureEdition: function() {
		this.currentEditionField.fireEvent('featureEditionCancelled');
		this.currentEditionField.setValue(this.currentEditionFieldOldValue);
		this.unpressField();
	},

	/**
	 * Set the features of the drawing layer from a WKT
	 * @param {String} wkt WKT to draw
	 */
	setDrawingLayerFeaturesFromWKT: function(wkt) {
		this.removeDrawingLayerFeatures();
		if (!Ext.isEmpty(wkt)) {
			this.drawingLayer.getSource().addFeatures(this.wktFormat.readFeatures(wkt));
		}
	},

	/**
	 * Manage the drawing layer feature change event
	 * @private
	 */
	onDrawingLayerFeatureChange: function(event) {
		if (event.type === 'addfeature') {
			this.removePreviousFeature(event.feature);
		}
		this.updateCurrentEditionFieldValue();
	},

	/**
	 * Removes the previous feature when forceSingleFeature is set to true
	 * @private
	 * @param {ol.layer} newFeature The last added feature
	 */
	removePreviousFeature: function(newFeature) {
		var forceSingleFeature = false;
		if (this.currentEditionField !== null) {
			forceSingleFeature = this.currentEditionField.forceSingleFeature;
		}
		if (forceSingleFeature) {

			var drawingLayerSource = this.drawingLayer.getSource();
			var drawingFeaturesClt = drawingLayerSource.getFeaturesCollection();
			var featuresCount = drawingFeaturesClt.getLength();

			if (featuresCount > 1) {

				/*
				 * Note about ol v3.15.1:
				 * We gets the following error with that code:
				 * Uncaught AssertionError: Assertion failed: featureChangeKeys is an empty object now
				 */
				//drawingLayerSource.clear();
				//drawingLayerSource.addFeature(newFeature);

				/*
				 * The removeFeature function must be used to refresh correctly the layer.
				 * Note about ol v3.15.1: 
				 * The c_array is not updated (contains all the removed features).
				 */
				drawingFeaturesClt.forEach(
					function(el, index, c_array){
						if (index < c_array.length - 1) {
							drawingLayerSource.removeFeature(el);
						}
					}
				);

				/*
				 * The collection must be updated to refresh the c_array
				 * Note about ol v3.15.1: 
				 * The ol.Collection.removeAt() function doesn't update the layer source.
				 */
				for(var i = 0; i < featuresCount - 1; i++) {
					drawingFeaturesClt.removeAt(i);
				}
			}
		}
	},

	/**
	 * Update the WKT value of the current geometry field
	 * @private
	 */
	updateCurrentEditionFieldValue: function() {
		var wktValue = null;
		var drawingFeatures = this.drawingLayer.getSource().getFeatures();
		if (drawingFeatures.length === 1) { // Avoid the GEOMETRYCOLLECTION for only one feature
			wktValue = this.wktFormat.writeFeature(drawingFeatures[0]);
		} else if (drawingFeatures.length > 1) { // Return a GEOMETRYCOLLECTION
			wktValue = this.wktFormat.writeFeatures(drawingFeatures);
		}
		if (this.currentEditionField !== null) {
			this.currentEditionField.setValue(wktValue);
		}
	},

	/**
	 * Manage the geometry field press event
	 * @private
	 * @param {Ext.form.field.Field} field The pressed field
	 */
	onGeomCriteriaPress: function(field) {
		if (this.currentEditionField !== null) {
			// Deactivation of the previous edition mode and field
			this.previousEditionFieldId = this.currentEditionField.getId();
			this.currentEditionField.onUnpress();
		}
		this.currentEditionField = field;
		var wkt = field.getValue();
		this.currentEditionFieldOldValue = wkt;
		this.setDrawingLayerFeaturesFromWKT(wkt);
		this.toggleDrawingTbar(true);
		var consultationPanel = this.getConsultationpanel();
		consultationPanel.ownerCt.setActiveTab(consultationPanel);
		var mapMainWin = this.getMapmainwin();
		mapMainWin.ownerCt.setActiveTab(mapMainWin);
		
		// Zoom and center on the geometry
		var map = this.getMapcmp().map;
		if (!Ext.isEmpty(wkt)) {
			map.getView().fit(
				this.wktFormat.readGeometry(wkt).getExtent(), 
				map.getSize()
			);
		}
		
		// Desactive on map click result feature info
		this.getMaptb().getController().onResultFeatureInfoButtonPress(null,
				false, null);
	},

	/**
	 * Manage the geometry field unpress event
	 * @private
	 * @param {Ext.form.field.Field} field The unpressed field
	 */
	onGeomCriteriaUnpress: function(field) {
		if(field && field.getId() === this.previousEditionFieldId){ // Do nothing
			this.previousEditionFieldId = null;
		} else {
			this.currentEditionField = null;
			this.toggleDrawingTbar(false);
			this.removeDrawingLayerFeatures();
		}
		
		// Active on map click result feature info
		this.getMaptb().getController().onResultFeatureInfoButtonPress(null,
				true, null);
	},

	/**
	 * Deactivation of the previous edition mode and field on a request launch
	 * @private
	 */
	onSubmitRequest: function() {
		this.unpressField();
	},

	/**
	 * Unpress the current edition field linked to the drawing toolbar
	 */
	unpressField: function() {
		if (this.currentEditionField !== null) {
			this.currentEditionField.onUnpress();
		}
	},

	/**
	 * Setup the drawing toolbar buttons (visibilities and default controls)
	 */
	setupDrawingTbarButtons: function() {
		// Set the buttons visibilities
		var drawingButtonsGroup = this.getMaptb().getComponent('drawingButtonsGroup');
		var drawPointButton = drawingButtonsGroup.getComponent('drawPointButton');
		drawPointButton.setVisible(!this.currentEditionField.hideDrawPointButton);
		var drawLineButton = drawingButtonsGroup.getComponent('drawLineButton');
		drawLineButton.setVisible(!this.currentEditionField.hideDrawLineButton);
		var drawPolygonButton = drawingButtonsGroup.getComponent('drawPolygonButton');
		drawPolygonButton.setVisible(!this.currentEditionField.hideDrawPolygonButton);
		drawingButtonsGroup.getComponent('selectWFSFeatureButton').setVisible(!this.currentEditionField.hideSelectWFSFeatureButton);

		var drawValidationButtons = drawingButtonsGroup.items.filter('group', 'drawValidation');
		drawValidationButtons.each(function(item){
			item.setVisible(!this.currentEditionField.hideValidateAndCancelButtons);
		},this);

		// Set the default control
		switch (this.currentEditionField.defaultActivatedDrawingButton) {
			case 'point' : drawPointButton.toggle(true); break;
			case 'line' : drawLineButton.toggle(true); break;
			case 'polygon' : drawPolygonButton.toggle(true); break;
		}
	},

	/**
	 * Activates / Deactivates drawing tbar
	 * @param {boolean} enable Enable or disable the drawing toolbar
	 */
	toggleDrawingTbar: function(enable) {
		var drawingButtonsGroup = this.getMaptb().getComponent('drawingButtonsGroup');
		if(enable){
			// Setup the drawing toolbar buttons
			this.setupDrawingTbarButtons();
		} else {
			// Deactivates all the drawing toolbar buttons controls on the toolbar disappearance
			var drawingTbarButtons = drawingButtonsGroup.items.filter('enableToggle', true);
			drawingTbarButtons.each(function(item){
				item.toggle(false);
				var itemMenu = item.getMenu();
				if(itemMenu !== null){
					itemMenu.items.each(function(item, index, len){
						item.setChecked(false, false);
					});
				}
			});
		}
		// Show or hide drawing buttons group
		drawingButtonsGroup.setVisible(enable);
	},

	/**
	 * Remove drawing layer features
	 */
	removeDrawingLayerFeatures: function () {
		this.drawingLayer.getSource().clear({'fast':true});
	}
});