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
 * Provides a tree field
 * 
 * @class OgamDesktop.ux.form.field.Tree
 * @extends Ext.form.field.ComboBox
 * @constructor Create a new tree field
 * @param {Object} config
 * @xtype treefield
 */
Ext.define('OgamDesktop.ux.form.field.Tree', {
    extend:'Ext.form.field.Tag',
    alias: 'widget.treefield',
	requires:['OgamDesktop.ux.picker.Tree'],
	triggers:{
		'tree':{
			handler:'onTreeTriggerClick',
			scope:'this'
		}
	},
	multiSelect:false,
	triggerAction:'query',
	queryMode:'remote',
	pageSize: 25,
	minChars : 2,

	/**
	 * @cfg {Boolean} hideValidationButton if true hide the tree validation button (defaults to true).
	 */
	hideValidationButton : false,

	/**
	 * Value field in the store
	 */
	valueField : 'code',

	/**
	 * Display field in the store,
	 */
	displayField : 'label',

	/**
	 * Manage multiple values,
	 */
	multiple : false,

	/**
	 * The field tree (displayed on a trigger click).
	 * 
	 * @property tree
	 * @type OgamDesktop.ux.picker.Tree
	 */
	tree : null,

	/**
	 * @cfg {bool} hidePickerTrigger Hide the picker trigger on the first render
	 * default to true
	 */
	hidePickerTrigger:true,

	/**
	 * @cfg {String} emptyText The default text to place into an empty field (defaults to 'Select...').
	 */
	//emptyText : 'Select...', //@see EXTJS-19841., EXTJS-1637

	/**
	 * @cfg {Ext.grid.column.Column[]/Object} treePickerColumns 
	 * array of column definition objects which define all columns that appear in this
     * tree
	 * @see Ext.tree.Panel.columns
	 */

	/**
	 * @cfg {Ext.data.store/Object} treePickerStore
	 * the store the tree should useas it data source 
	 */
	
	/**
	 * Initialise the component.
	 */
	initComponent : function() {

		// Set the submit name of the field
		this.hiddenName = this.name;

		this.callParent();
		this.getTrigger('picker').setHidden(this.hidePickerTrigger);
		
	},

	/**
	 * The function that handle the trigger's click event. Implements the
	 * default empty TriggerField.onTriggerClick function to display the
	 * TreePicker
	 * @private
	 */
	onTreeTriggerClick : function() {
		if (this.disabled) {
			return;
		}

		if (!this.tree) {
			this.createTreePicker();
		}
        var me = this,
        picker = me.tree,
        store = picker.store,
        values = me.value,
        node;
        
		if (!me.readOnly && !me.disabled) {
			if(picker.isVisible()){
				picker.hide();
			} else {
				picker.setSelection(null);
				picker.showBy(this.el, "tl-bl?");
			}
		}
	},

    /**
     * Create the tree picker
     * @private
     * @return {OgamDesktop.ux.picker.Tree} The picker
     */
	createTreePicker:function(){
		var storepiker = this.treePickerStore;

		this.tree = new OgamDesktop.ux.picker.Tree({
			columns : this.treePickerColumns,
			hideOnClick : false,
			hideValidationButton : this.hideValidationButton,
			store : storepiker,
			floating : true,
			focusable : false,
			resizable:true,
			multiple : this.multiple,
			width : '50%'
		});
		this.mon(this.tree, {
			choicemake : this.onTreeChoice,
			scope : this
		});
		return this.tree;
	},

	/**
     * Manage the choicemake event
     * @private
     * @param {OgamDesktop.ux.picker.Tree} view The tree picker
     * @param {Array} records The selected nodes
     */
	onTreeChoice : function(view, record) {
		if (this.multiple) {
			this.addValue(record);
		} else {
			this.setValue(record);
		}
		
		this.fireEvent('select', this, record);
		if (this.tree) {
			this.tree.hide();
		}		
		
	},

	/**
	 * Fonction handling the beforeDestroy event
	 * @private
	 */
	beforeDestroy: function(){
		if(this.tree) {
			this.tree.hide();
		}
		this.callParent();
	},

	/**
	 * Fonction handling the destroy event
	 * @private
	 */
	onDestroy : function() {
		Ext.destroy(this.tree, this.wrap);
		this.callParent();
	}
	
});
