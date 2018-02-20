/**
 * @singleton
 * @class OgamDesktop.ux.grid.column.Factory
 *
 * This is a singleton object which contains a set of commonly used column build functions
 * 
 */
Ext.define('OgamDesktop.ux.grid.column.Factory', function () {
    var me; // holds our singleton instance

    return {
        requires: [
        ],
        singleton: true,
        gridColumnTrueText : 'Yes',
        gridColumnFalseText : 'No',
        gridColumnUndefinedText : '&#160;',

        constructor: function () {
            me = this; // we are a singleton, so cache our this pointer in scope
        },

        /**
         * Construct a checkbox field config from a record
         * @private
         * @return {Object} a Ext.grid.column.Boolean config object
         */
        buildBooleanColumnConfig : function() {
            var columnConfig = {};
            columnConfig.xtype = 'booleancolumn';
            columnConfig.trueText = this.gridColumnTrueText;
            columnConfig.falseText = this.gridColumnFalseText;
            columnConfig.undefinedText = this.gridColumnUndefinedText;
            // Patch to extjs 6.0.1.250
            columnConfig.defaultRenderer= function(value){
                if (value === null) {
                    return this.undefinedText;
                }
                if (!value || value === 'false') {
                    return this.falseText;
                }
                return this.trueText;
            };
            return columnConfig;
        }
    };
});