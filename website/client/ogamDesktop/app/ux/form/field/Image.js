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
 * Provides a image upload field
 * 
 * @class OgamDesktop.ux.form.field.ImageField
 * @extends Ext.ux.form.FileUploadField
 * @constructor Create a new ImageField
 * @param {Object} config
 * @xtype imagefield
 */

Ext.define('OgamDesktop.ux.form.field.ImageField',{
	extend:'Ext.form.field.File', 
	xtype:'imagefield',
	requires:[
	'Ext.form.Panel',
	'Ext.window.Window'
	],
	
	/*
	 * Internationalization.
	 */
	emptyImageUploadFieldTest : 'Select an image',
	/**
	 * Identifier submited
	 */
	uploadId:null,
	/**
	 * A hidden form used to submit the file
	 */
	imageForm : null,

	/**
	 * Window used to display the uplad form
	 */
	uploadWindow : null,

	/**
	 * Initializes the component.
	 */
	initComponent : function() {

		// Default configuration
		var config = {
			emptyText : this.emptyImageUploadFieldTest,
			buttonText : '',
			buttonCfg : {
				iconCls : 'upload-icon'
			}
		};

		// apply config
		Ext.apply(this, Ext.apply(this.initialConfig, config));

		// call parent init component
		this.callParent(arguments);

		// Upload the file as soon as it is selected
		this.on('change', this.selectFile, this);

	},

	/**
	 * Select the file
	 * @private
	 */
	selectFile : function(field, file) {

		// Lazy initialisation of a form used to submit the image
		if (this.imageForm == null) {

			// Create a hidden form for the image field
			this.imageForm = new Ext.FormPanel({
				method : 'POST',
				fileUpload : true,
				frame : true,
				encoding : 'multipart/data',
				layout : 'fit',
				defaults : {
					anchor : '95%',
					allowBlank : false,
					msgTarget : 'side'
				},
				items : [ {
					xtype : 'hidden',
					name : 'type',
					value : 'image'
				}, {
					xtype : 'hidden',
					name : 'id',
					value : this.uploadId
				}, this // ugly but works OK
				// {
				// xtype : 'fileuploadfield',
				// name : 'file',
				// value : this.value
				// }
				]
			});

			// Automatically launch the upload after render
			this.imageForm.on('afterrender', this.uploadFile, this);

			// Display the form in a window
			this.uploadWindow = new Ext.Window({
				closeAction : 'hide',
				title : 'Upload',
				items : [ this.imageForm ]
			});
		}

		this.uploadWindow.show();

	},

	/**
	 * Upload the file
	 * @private
	 */
	uploadFile : function() {
		// Submit the image
		if (this.imageForm.getForm().isValid()) {
			this.imageForm.getForm().submit({
				url : Ext.manifest.OgamDesktop.editionServiceUrl + 'ajaximageupload',
				method : 'POST',
				enctype : 'multipart/form-data',
				waitTitle : 'Connexion au serveur ...',
				waitMsg : 'Upload en cours ...',
				success : this.onUploadSuccess,
				failure : this.onUploadFailure,
				scope : this
			});
		}

		// Set the value as a hidden field ???
		// alert("value : " + this.value);

	},

	/**
	 * Fonction handling the upload success
	 * @private
	 */
	onUploadSuccess : function() {
		// this.uploadWindow.close();
		console.log('success');
	},

	/**
	 * Fonction handling the upload failure
	 * @private
	 */
	onUploadFailure : function() {
		// this.uploadWindow.close();
		console.log('failure');
	},

	/**
	 * Destroy the component
	 * @private
	 */
	onDestroy : function() {
		console.log('destroy');
		Ext.destroy(this.imageForm);
		this.callParent();
	}

});
