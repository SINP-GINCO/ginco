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
 * Provides a radioButton input field
 *
 * @class OgamDesktop.ux.form.field.RadioButton
 * @extends Ext.form.RadioGroup
 * @constructor Create a newRadioButton
 * @param {Object} config
 * @xtype radiobuttonfield
 */
Ext.define('OgamDesktop.ux.form.field.RadioButton', {
    extend:'Ext.form.RadioGroup',
    alias: 'widget.radiobuttonfield',
    /**
     * @cfg {Boolean} [local=true]
     * override the {@link Ext.form.RadioGroup RadioGroup} in order to use multiple safer
     */
    local:true,
    
    /**
     * set the current value
     * allow single value
     * @link Ext.form.RadioGroup#setValue
     * @param {String |Object}
     * @returns OgamDesktop.ux.form.field.RadioButton
     */
    setValue:function(value) {
        var val={};
        if (!Ext.isObject(value)) {
            val[this.name] = value;
        } else {
            val = value;
        }
        return this.callParent([val]);
    }

});
