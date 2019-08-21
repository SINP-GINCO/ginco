/**
 * @singleton
 * @class OgamDesktop.ux.data.field.Factory
 *
 * This is a singleton object which contains a set of commonly used field build functions
 * 
 */
Ext.define('OgamDesktop.ux.data.field.Factory', function () {
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
         * @param {Object} fieldParameters The field parameters returned per the server
         * @return {Object} a Ext.data.field.Boolean config object
         */
        buildCheckboxFieldConfig : function(fieldParameters) {
            var fieldConfig = {};
            switch (fieldParameters.type) {
                case 'BOOLEAN':
                    fieldConfig.convert = function (value) {
                        switch (value) {
                            case false: case 0: case '0':
                                return false;
                            case true: case 1: case '1':
                                return true;
                            default: 
                                console.warn('The value must be set to true or false for a checkbox field with a "BOOLEAN" type');
                                return null;
                        }
                    };
                    break;
                case 'STRING':
                    fieldConfig.convert = function (value) {
                        switch (value) {
                            case "0": return false;
                            case "1": return true;
                            default: 
                                console.warn('The value must be set to "0" or "1" for a checkbox field with a "STRING" type');
                                return null;
                        }
                    };
                    break;
                case 'CODE':
                    var uncheckedValue = '0', checkedValue = '1';
                    if (fieldParameters.uncheckedValue && fieldParameters.checkedValue) {
                        uncheckedValue = fieldParameters.uncheckedValue;
                        checkedValue = fieldParameters.checkedValue;
                    } else {
                        console.warn('The uncheckedValue and checkedValue parameters are missing for a checkbox field with a "CODE" type');
                        console.warn('The checkbox field defaults values are set to "0" and "1"');
                    }
                    fieldConfig.convert = (function (uncheckedValue, checkedValue, value) {
                        switch (value) {
                            case uncheckedValue: return false;
                            case checkedValue: return true;
                            default:
                                console.warn('The value must be set to "'+ uncheckedValue +'" or "'+ checkedValue +'" for a checkbox field with a "CODE" type');
                                return null;
                        }
                    }).bind(undefined, uncheckedValue, checkedValue);
                    break;
                default:
                    fieldConfig.convert = function (value) {
                        return null;
                    };
                    console.warn('The checkbox field value type is not specified for the "' + fieldParameters.type + '" type');
                    break;
            }
            return fieldConfig;
        }
    };
});