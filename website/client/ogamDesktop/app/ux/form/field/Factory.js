/**
 * @singleton
 * @class OgamDesktop.ux.form.field.Factory
 *
 * This is a singleton object which contains a set of commonly used field build functions
 * 
 */
Ext.define('OgamDesktop.ux.form.field.Factory', function () {
    var me; // holds our singleton instance

    return {
        requires: [
        ],

        singleton: true,

        constructor: function () {
            me = this; // we are a singleton, so cache our this pointer in scope
        },

        /**
         * Construct a checkbox field config from a record
         * @param {Ext.data.Record} record The field record
         * @return {Object} a checkbox Field config
         */
        buildCheckboxFieldConfig : function(record) {
            var field = {xtype : 'checkbox'};
            switch (record.get('type')) {
                case 'BOOLEAN': // We assume that the field is a boolean with two possible values: true and false
                    field.uncheckedValue = false;
                    field.inputValue = true;
                    if (record.get('default_value')) {
                        if (Ext.isBoolean(record.get('default_value'))) {
                            field.checked = record.get('default_value');
                        } else {
                            console.warn('The default_value parameter must be of boolean type for a checkbox field with a "BOOLEAN" type');
                            console.warn('The default_value parameter is ignored');
                        }
                    }
                    break;
                case 'STRING': // We assume that the field is a char(1) with two possible values: '0' and '1'
                    field.uncheckedValue = '0';
                    field.inputValue = '1';
                    if (record.get('default_value')) {
                        if (Ext.isString(record.get('default_value'))) {
                            switch (record.get('default_value')) {
                                case "0": field.checked = false; break;
                                case "1": field.checked = true; break;
                                default:
                                    console.warn('The default_value parameter must be set to "0" or "1" for a checkbox field with a "STRING" type');
                                    console.warn('The default_value parameter is ignored');
                                    break;
                            }
                        } else {
                            console.warn('The default_value parameter must be of string type for a checkbox field with a "STRING" type');
                            console.warn('The default_value parameter is ignored');
                        }
                    }
                    break;
                case 'CODE': // We assume that the field is a code with two possible values set per the "uncheckedValue" and "checkedValue" parameters
                    var uncheckedValue = '0', checkedValue = '1';
                    if (record.get('uncheckedValue') && record.get('checkedValue')) {
                        uncheckedValue = record.get('uncheckedValue');
                        checkedValue = record.get('checkedValue');
                    } else {
                        console.warn('The uncheckedValue and checkedValue parameters are missing for a checkbox field with a "CODE" type');
                        console.warn('The checkbox field defaults values are set to "0" and "1"');
                    }
                    field.uncheckedValue = uncheckedValue;
                    field.inputValue = checkedValue;
                    if (record.get('default_value')) {
                        if (Ext.isString(record.get('default_value'))) {
                            switch (record.get('default_value')) {
                                case uncheckedValue: field.checked = false; break;
                                case checkedValue: field.checked = true; break;
                                default:
                                    console.warn('The default_value parameter must be set to "'+ uncheckedValue +'" or "'+ checkedValue +'" for a checkbox field with a "CODE" type');
                                    console.warn('The default_value parameter is ignored');
                                    break;
                            }
                        } else {
                            console.warn('The default_value parameter must be of string type for a checkbox field with a "CODE" type');
                            console.warn('The default_value parameter is ignored');
                        }
                    }
                    break;
                default: 
                    field.uncheckedValue = false;
                    field.inputValue = true;
                    field.checked = new Boolean(record.get('default_value'));
                    console.warn('The checkbox field value type is not specified for the "' + record.get('type') + '" type');
                    console.warn('The checkbox field value default type is set to Boolean');
                    break;
            }
            return field;
        },
        /**
         * Construct a radioa field config from a record
         * @param {Ext.data.Record} record The field record
         * @return {Object} a radio Field config
         */
        buildRadioFieldConfig : function(record) {
            var field = {xtype : 'radiobuttonfield'};
            switch (record.get('type')) {
            case 'CODE':
                var radios = [];
                if(record.get('codes')){
                    record.get('codes').forEach(function (code, index) {
                        radios.push({
                            xtype:'radio',
                            inputValue: code.code,
                            boxLabel:code.label,
                            checked:code.code === record.get('value')
                        });
                    });
                    field.items=radios;
                }
                break;
            default: 
                console.error('The radio field value type is not specified for the "' + record.get('type') + '" type');
                break;
            }
            return field;
        }
    };
});