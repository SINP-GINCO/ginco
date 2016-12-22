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
 * @class Ginco.ux.form.field.Tree
 * @extends Ext.form.field.ComboBox
 * @constructor Create a new tree field
 * @param {Object}
 *            config
 * @xtype treefield
 */
Ext.define('Ginco.ux.form.field.Tree', {
	override : 'OgamDesktop.ux.form.field.Tree',
	alias : 'widget.treefield',
	minChars : 2,
	
	/**
	 * Create the tree picker.
	 * Customized for making the widget larger.
	 *
	 * @private
	 * @return {OgamDesktop.ux.picker.Tree} The picker
	 */
	createTreePicker : function() {
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
	}

});
