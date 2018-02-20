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
 * Provides a number range input field with a {@link OgamDesktop.ux.NumberRangePicker} dropdown and automatic number validation.
 *
 * @class OgamDesktop.ux.form.field.NumberRangeField
 * @extends Ext.form.field.Picker
 * @constructor Create a new NumberRangeField
 * @param {Object} config
 * @xtype numberrangefield
 */
Ext.define('OgamDesktop.ux.form.field.NumberRangeField', {
    extend:'Ext.form.field.Picker',
    alias: 'widget.numberrangefield',
    requires:['OgamDesktop.ux.picker.NumberRange'],

    /*
     * Internationalization.
     */
    //<locale>
    numberSeparator: ' - ',
    decimalSeparator : ".",
    maxNumberPrefix: '<= ',
    minNumberPrefix: '>= ',
    minText : "The minimum value for this field is {0}",
    maxText : "The maximum value for this field is {0}",
    reverseText : "The max number must be superior to the min number",
    formatText : "The correct formats are",
    nanText : "'{0}' is not a valid number",
    //</locale>
    
    /**
     * @cfg {Boolean} usePrefix if true, maxNumberPrefix and minNumberPrefix are used (defaults to true).
     * Otherwise minValue and maxValue are used.
     */
    usePrefix: true,
       
    /**
     * @cfg {Boolean} allowDecimals False to disallow decimal values (defaults to true)
     */
    allowDecimals : true,
    
    //<locale>
    /**
     * @cfg {Number} decimalPrecision The maximum precision to display after the decimal separator (defaults to 2)
     */
    decimalPrecision : 2,
    //</locale>
    
    /**
     * @cfg {Boolean} allowNegative False to prevent entering a negative sign (defaults to true)
     */
    allowNegative : true,
    /**
     * @cfg {Number} minValue The minimum allowed value (defaults to -Number.MAX_VALUE)
     */
    minValue : -Number.MAX_VALUE,
    /**
     * @cfg {Number} maxValue The maximum allowed value (defaults to Number.MAX_VALUE)
     */
    maxValue : Number.MAX_VALUE,
    /**
     * @cfg {String} baseChars The base set of characters to evaluate as valid (defaults to '0123456789<>= ').
     */
    baseChars : "0123456789",
    /**
     * @cfg {Boolean} hideValidationButton if true hide the menu validation button (defaults to true).
     */
    hideValidationButton : false,
    /**
     * @cfg {Boolean} setEmptyText if true set emptyText of the fields with the min and the max values (defaults to false).
     */
    setEmptyText : false,
    
    /**
     * @inheritdoc
     */
    valuePublishEvent: ['select', 'blur'],

    /**
     * Initialise the events management.
     */
    initEvents : function(){
        var allowed = '';
        allowed += this.baseChars; // ! this.baseChars can be null
        allowed += this.maxNumberPrefix + this.minNumberPrefix;
        if (this.allowDecimals) {
            allowed += this.decimalSeparator;
        }
        if (this.allowNegative) {
            allowed += '-';
        }
        allowed = Ext.Array.unique(allowed.split('')).join(); //simplify the regex
        this.maskRe = new RegExp('[' + Ext.String.escapeRegex(allowed) + ']');
        this.callParent(arguments);
    },

    /**
     * Initialise the component.
     */
    initComponent : function(){
        var i;
        this.callParent(arguments);

        if (this.setEmptyText){
            this.emptyText = this.minValue + this.numberSeparator + this.maxValue;
        }
        // Formating of the formatText string
        var format = 0;
        if (this.decimalPrecision > 0) {
            format = format+ this.decimalSeparator;
            for (var iter = 0; iter < this.decimalPrecision; iter++) {
                format += "0";
            }
        }
        this.formatText = this.formatText + " '{0}', '"+this.maxNumberPrefix+" {0}', '"+this.minNumberPrefix+" {0}', '{0} "+this.numberSeparator+" {0}'.";
        this.formatText = Ext.String.format(this.formatText, format);
    },

    /**
     * Validate the value.
     * @param {Number} value The value to check
     * @return {Boolean} True if the number is valide
     */
    validateValue : function(value){// OGAM-595 - TODO : override getErrors, recommended since 3.2
        var format =Ext.String.format;

        if (!this.callParent(arguments)){ //super! not parent, in override case
            return false;
        }
        if (value.length < 1){ // if it's blank and textfield didn't flag it then it's valid
             return true;
        }
        var values = this.splitValue(value);
        if (values === null){
            this.markInvalid(this.formatText);
            return false;
        } else {
            var minv = values.minValue;
            var maxv = values.maxValue;
            if (minv !== null){
                minv = this.getNumber(minv);
                if (minv === null){
                    this.markInvalid(format(this.nanText, values.minValue));
                    return false;
                }
                if (minv < this.minValue){
                    this.markInvalid(format(this.minText, this.minValue));
                    return false;
                }
            }
            if (maxv !== null){
                maxv = this.getNumber(maxv);
                if (maxv === null){
                    this.markInvalid(format(this.nanText, values.maxValue));
                    return false;
                }
                if (maxv > this.maxValue){
                    this.markInvalid(format(this.maxText, this.maxValue));
                    return false;
                }
            }
            if (minv !== null && maxv !== null && (maxv - minv) < 0){
                this.markInvalid(this.reverseText);
                return false;
            }
            return true;
        }
    },

    /**
     * Returns the normalized data value (undefined or emptyText will be returned as '').
     * To return the raw value see {@link #getRawValue}.
     * @return {Mixed} value The field value
     */
    getValue : function(){
        var value = this.callParent(arguments);
        value = this.formatNumberValue(value);
        return value === null ? '' : value;
    },

    /**
     * Returns the values.
     * @return {Object} The field values
     */
    getValues : function(){
        var value =  this.superclass.getValue.call(this);
        return this.getNumbersObject(this.splitValue(value));
    },

    /**
     * Sets a data value into the field and validates it.
     * To set the value directly without validation see {@link #setRawValue}.
     * @param {Mixed} value The value to set
     * @return {Ext.form.Field} this
     */
    setValue : function(v){
        v = this.formatNumberValue(v);
        return  this.callParent([v]);
    },
    
    /**
     * Format the field.
     * @param {Mixed} value The value to set
     * @return {String} The formated string value
     */
    formatNumberValue : function(v){
        var minv, maxv, mins, maxs;
        if (!Ext.isObject(v)){
            v = this.splitValue(v);
        }
        v = this.getNumbersObject(v);

        if (v !== null){
            minv = v.minValue;
            maxv = v.maxValue;
            mins = isNaN(minv) ? '' : String(this.fixPrecision(minv)).replace(".", this.decimalSeparator);
            maxs = isNaN(maxv) ? '' : String(this.fixPrecision(maxv)).replace(".", this.decimalSeparator);

            if (this.usePrefix === true){
                if (minv === null && maxv !== null){
                    v = this.maxNumberPrefix + maxv;
                } else if (minv !== null && maxv === null){
                    v = this.minNumberPrefix + minv;
                } else if (minv !== null && maxv !== null){
                    if (minv === maxv){
                        v = mins;
                    } else {
                        v = mins + this.numberSeparator + maxs;
                    }
                } else {
                    v = '';
                }
            } else {
                if (minv === null && maxv !== null){
                    v = this.minValue + this.numberSeparator + maxs;
                } else if (minv !== null && maxv === null){
                    v = mins + this.numberSeparator + this.maxValue;
                } else if (minv !== null && maxv !== null){
                    if (minv === maxv){
                        v = mins;
                    } else {
                        v = mins + this.numberSeparator + maxs;
                    }
                } else {
                    v = '';
                }
            }
        }
        return v;
    },

    /**
     * Round the value to the specified number of decimals.
     * @param {Number} value The value to round
     * @return {Number} Return the rounded number or ''.
     */
    fixPrecision : function(value){
        var nan = isNaN(value);
        if (!this.allowDecimals || this.decimalPrecision === -1 || nan || !value){
           return nan ? '' : value;
        }
        return parseFloat(parseFloat(value).toFixed(this.decimalPrecision));
    },

    /**
     * Return the number corresponding to the passed value or null
     * @private
     * @param {Number} value The value to parse
     * @return {Number} Return the number or null.
     */
    getNumber : function(value){
        return Ext.Number.from(String(value).replace(this.decimalSeparator, "."), null);
    },

    /**
     * Return a range number if the object is valid or null
     * @private
     * @param {Object} obj The object to check
     * @return {Number/null} Return the range number or null.
     */
    getNumbersObject : function(obj){
        if (!obj || !Ext.isObject(obj)){
            return null;
        }
        var minv = this.getNumber(obj.minValue);
        var maxv = this.getNumber(obj.maxValue);
        if (minv !== null || maxv !== null){
            return {minValue:minv, maxValue:maxv};
        } else {
            return null;
        }
    },

    /**
     * Return an object with the numbers found in the string
     * @private
     * @param {String} value The string value to parse
     * @return {object/null} An object with min and max values or null for failed match operations
     */
    splitValue : function(value){
        var minv, maxv, minnpIndex, maxnpIndex;
        if (!value || !Ext.isString(value)){
            return null;
        }
        var values = value.split(this.numberSeparator);
        if (values.length === 1){
            minnpIndex = value.indexOf(this.minNumberPrefix,0);
            maxnpIndex = value.indexOf(this.maxNumberPrefix,0);
            if (minnpIndex !== -1){
            // Case ">= 00.00"
                minv = value.substring(minnpIndex + this.minNumberPrefix.length);
                return {minValue:minv, maxValue:null};
            }else if (maxnpIndex !== -1){
            // Case "<= 00.00"
                maxv = value.substring(maxnpIndex + this.maxNumberPrefix.length);
                return {minValue:null, maxValue:maxv};
            }else{
            // Case "00.00"
                return {minValue:value, maxValue:value};
            }
        }else if (values.length === 2){
            // Case "00.00 - 00.00"
                return {minValue:values[0], maxValue:values[1]};
        }else{
            return null;
        }
    },

    /**
     * Manage the select event
     * @private
     * @param {Ext.form.field.Picker} field This field instance
     * @param {Object} value The value that was selected
     */
    onSelect: function(field, value){
        this.setValue(value);
        this.fireEvent('select', this, value);
        this.collapse();
    },
    
    /**
     * Create the number range picker
     * @private
     * @return {OgamDesktop.ux.picker.NumberRange} The picker
     */
    createPicker: function() {
        var me = this,
            format = Ext.String.format;

        // Create floating Picker BoundList. It will acquire a floatParent by looking up
        // its ancestor hierarchy (Pickers use their pickerField property as an upward link)
        // for a floating component.
        return new OgamDesktop.ux.picker.NumberRange({
            pickerField: me,
            floating:true,
            focusable: false, // Key events are listened from the input field which is never blurred
            hidden: true,
            hideValidationButton: me.hideValidationButton,
            minField:{
                emptyText: me.setEmptyText ? me.minValue : null,
                allowDecimals : me.allowDecimals,
                decimalSeparator : me.decimalSeparator,
                decimalPrecision : me.decimalPrecision,
                allowNegative : me.allowNegative,
                minValue : me.minValue,
                maxValue : me.maxValue,
                baseChars : me.baseChars
            },
            maxField: {
                emptyText : me.setEmptyText ? me.maxValue : null,
                        allowDecimals : me.allowDecimals,
                        decimalSeparator : me.decimalSeparator,
                        decimalPrecision : me.decimalPrecision,
                        allowNegative : me.allowNegative,
                        minValue : me.minValue,
                        maxValue : me.maxValue,
                        baseChars : me.baseChars
                    },
            listeners: {
                scope: me,
                select: me.onSelect
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            }
        });
    },

    /**
     * Sets the range picker's value to match the current field value when expanding.
     * @private
     */
    onExpand: function() {
        var values = this.getValues();
        if (values !== null){
            this.picker.minField.setValue(values.minValue);
            this.picker.maxField.setValue(values.maxValue);
        } else {
            if (this.getRawValue() !== ''){
                return;
            }
        }

        this.picker.minField.focus(true, 60);
    },

    /**
     * Gets the range picker's value to match the current field value when collapsing.
     * @private
     */
    onCollapse: function() {
        this.focus(false, 60);
        this.setValue({
            minValue: this.picker.minField.getValue(),
            maxValue: this.picker.maxField.getValue()
        });
    }
});