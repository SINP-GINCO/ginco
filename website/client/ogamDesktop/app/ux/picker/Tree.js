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
 * Simple tree picker class.
 * 
 * @class OgamDesktop.ux.picker.Tree
 * @extends Ext.TreePanel
 * @constructor Create a new tree picker
 * @param {Object}
 *            config The config object
 * @xtype treepicker
 */
Ext.define('OgamDesktop.ux.picker.Tree', {
    extend:'Ext.tree.TreePanel',
    // alias: 'widget.treepicker',// OGAM-599 - TODO fix or overwrite this xtype (same Ext.ux.TreePicker)
	requires:['Ext.selection.TreeModel'],
	padding : 5,
	enableDD : false,
	animate : true,
	border : true,
	shadow:false,
	rootVisible : false,
	useArrows : true,
	autoScroll : true,
	containerScroll : true,
	frame : true,
	listeners : {
		'itemdblclick' : {// Select the node on double click
			fn : function(panel, node, item, index, event) {
				this.fireEvent('choicemake',this, [node]);
			}
		}
	},

	//<locale>
	okButtonText : "ok",
	//</locale>

	/**
	 * @cfg {Number} height The height of this component in pixels (defaults to
	 *      300).
	 */
	height : 300,

	/**
	 * @cfg {Number} width The width of this component in pixels (defaults to
	 *      500).
	 */
	width : 500,

	/**
	 * @cfg {String} buttonAlign The alignment of any {@link #buttons} added to
	 *      this panel. Valid values are 'right', 'left' and 'center' (defaults
	 *      to 'center').
	 */
	buttonAlign : 'center',

	/**
	 * @cfg {String} cls An optional extra CSS class that will be added to this
	 *      component's Element (defaults to 'x-menu-number-range-item'). This
	 *      can be useful for adding customized styles to the component or any
	 *      of its children using standard CSS rules.
	 */
	cls : 'x-menu-tree-item',

	/**
	 * Manage multiple values,
	 */
	multiple : false,

	/**
	 * @cfg {Boolean} hideValidationButton if true hide the menu validation
	 *      button (defaults to true).
	 */
	hideValidationButton : true,

	/**
	 * Validation button
	 * 
	 * @type Ext.Button
	 */
	validationButton : null,

	/**
	 * Initialise the component
	 */
	initComponent : function() {
		/*
		 * The root must be instancied here and not in the static part of the
		 * class to avoid a conflict between the instance of the class
		 */
		
		this.validationButton = {
			xtype : 'button',
			text : this.okButtonText,
			width : 'auto',
			handler : Ext.Function.bind(this.onOkButtonPress,this)
		};

		// Add the validation button
		if (!this.hideValidationButton) {
			this.buttons = [ this.validationButton ];
			// this.height = this.height + 28;
		}

		// Allow multiple selection in the picker
		if (this.multiple) {
			this.selModel = new Ext.selection.TreeModel({mode:'MULTI'});
		}

		this.callParent();
	},

	/**
	 * Fonction handling the ok button click event
	 * @private
	 * @param {Ext.Button} button The ok button
	 * @param {Boolean} state True if the button is pressed
	 */
	onOkButtonPress : function(button, state) {
		if (state) {
				var selectedNodes = this.getSelection();
				this.fireEvent('choicemake', this, !selectedNodes ? null : selectedNodes);
		}
	}
});