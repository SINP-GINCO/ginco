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
 * 
 * A twin number field.
 * 
 * @class OgamDesktop.ux.form.field.TwinNumberField
 * @extends Ext.form.TwinTriggerField
 * @constructor Create a new TwinNumberField
 * @param {Object} config
 * @xtype twinnumberfield
 */
Ext.define('OgamDesktop.ux.form.field.TwinNumberField', {
    extend:'Ext.form.field.Text',
    alias: 'widget.twinnumberfield',
    config:{
        triggers:{
            cleaner:{
                cls:'x-form-clear-trigger',
                handler:'onTrigger1Click',
                scope:'this'
            }
        }
    },

    /*
     * Internationalization.
     */
    //<locale>
    decimalSeparator : ".",
    minText : "The minimum value for this field is {0}",
    maxText : "The maximum value for this field is {0}",
    nanText : "{0} is not a valid number",
    //</locale>

    /**
     * @cfg {String} fieldClass The default CSS class for the field (defaults to "x-form-field x-form-num-field")
     */
    fieldClass : "x-form-field x-form-num-field",
    /**
     * @cfg {Boolean} allowDecimals False to disallow decimal values (defaults to true)
     */
    allowDecimals : true,
    /**
     * @cfg {Number} decimalPrecision The maximum precision to display after the decimal separator (defaults to 2)
     */
    decimalPrecision : 2,
    /**
     * @cfg {Boolean} allowNegative False to prevent entering a negative sign (defaults to true)
     */
    allowNegative : true,
    /**
     * @cfg {Number} minValue The minimum allowed value (defaults to Number.NEGATIVE_INFINITY)
     */
    minValue : -Number.MAX_VALUE,
    /**
     * @cfg {Number} maxValue The maximum allowed value (defaults to Number.MAX_VALUE)
     */
    maxValue : Number.MAX_VALUE,
    /**
     * @cfg {String} baseChars The base set of characters to evaluate as valid numbers (defaults to '0123456789').
     */
    baseChars : "0123456789",
    /**
     *
     * @cfg {String} trigger1Class An additional CSS class used to style the
     * trigger button. The trigger will always get the class
     * 'x-form-clear-trigger' by default and triggerClass will be appended if specified.
     */
    trigger1Class : 'x-form-clear-trigger',
    /**
     * @cfg {Boolean} hideTrigger1 true to hide the first trigger. (Default to
     * true) See Ext.form.TwinTriggerField#initTrigger also.
     */
    hideTrigger1 : true,
    
    /**
     * @deprecated ?
     * @cfg {Boolean} hideTrigger2 true to hide the second trigger. (Default to
     * true) See Ext.form.TwinTriggerField#initTrigger also.
     */
    hideTrigger2 : true,
 
    /**
     * Initialise the component.
     */
    initComponent : function() {
        //this.on('change', this.onChange, this); //must be even map
        this.callParent();
    },

    /**
     * Initialize the events
     */
    initEvents : function() {
        var allowed = this.baseChars + '';
        if (this.allowDecimals) {
            allowed += this.decimalSeparator;
        }
        if (this.allowNegative) {
            allowed += '-';
        }
        this.maskRe = new RegExp('[' + Ext.String.escapeRegex(allowed) + ']');
        this.callParent();
    },

    /**
     * Apply the triggers
     * @param {Object} triggers (Ext.form.trigger.TriggerView)
     * @return {Object} The applied triggers
     */
    applyTriggers: function(triggers) {
        var me = this,
        cleaner = triggers.cleaner;

        if (!cleaner.cls) {
            cleaner.cls = me.trigger1Class;
        }

        return me.callParent([triggers]);
    },

    /**
     * The function that handle the trigger's click event. See
     * {@link Ext.form.TriggerField#onTriggerClick} for additional information.
     * @private
     */
    onTrigger1Click : function() {
//<debug>
        console.log('onTrigger1Click');
//</debug>
        this.reset();
        this.triggers.cleaner.hide();
    },

    /**
     * Fonction handling the change event
     * @private
     */
    onChange : function() {
        var v = this.getValue();
        if (v !== '' && v !== null) {
            this.triggers.cleaner.show();
        } else {
            this.triggers.cleaner.hide();
        }
        this.callParent(arguments);
    },

    /**
     * Validate the passed value
     * @private
     * @param {Number} value The value to validate
     * @return {Boolean} True id the passed value is valide
     */
    validateValue : function(value) {
        var format = Ext.String.format;
        if (!Ext.form.NumberField.superclass.validateValue.call(this, value)) {
            return false;
        }
        if (value.length < 1) { // if it's blank and textfield didn't flag it
                                // then it's valid
            return true;
        }
        value = String(value).replace(this.decimalSeparator, ".");
        if (isNaN(value)) {
            this.markInvalid(format(this.nanText, value));
            return false;
        }
        var num = this.parseValue(value);
        if (num < this.minValue) {
            this.markInvalid(format(this.minText, this.minValue));
            return false;
        }
        if (num > this.maxValue) {
            this.markInvalid(format(this.maxText, this.maxValue));
            return false;
        }
        return true;
    },

    /**
     * Returns the normalized data value (undefined or emptyText will be
     * returned as ''). To return the raw value see {@link #getRawValue}.
     * @return {Mixed} value The field value
     */
    getValue : function() {
        return this.fixPrecision(this.parseValue(Ext.form.NumberField.superclass.getValue.call(this)));
    },

    /**
     * Sets a data value into the field and validates it. To set the value
     * directly without validation see {@link #setRawValue}.
     * @param {Mixed} value The value to set
     * @return {Ext.form.Field} this
     */
    setValue : function(v) {
        v = typeof v === 'number' ? v : parseFloat(String(v).replace(this.decimalSeparator, "."));
        v = isNaN(v) ? '' : String(v).replace(".", this.decimalSeparator);
        if (this.triggers) {
            if (v !== '' && v !== null && v !== this.minValue && v !== this.maxValue) {
                this.triggers.cleaner.show();
            } else {
                this.triggers.cleaner.hide();
            }
        }
        return Ext.form.NumberField.superclass.setValue.call(this, v);
    },

    /**
     * Parse the value
     * @private
     * @param {Number} value The value to parse
     * @return {Number/''} The parsed number or ''
     */
    parseValue : function(value) {
        value = parseFloat(String(value).replace(this.decimalSeparator, "."));
        return isNaN(value) ? '' : value;
    },

    /**
     * Round the value to the specified number of decimals.
     * @param {Number} value The value to round
     * @return {Number} Return the rounded number or ''.
     */
    fixPrecision : function(value) {
        var nan = isNaN(value);
        if (!this.allowDecimals || this.decimalPrecision === -1 || nan || !value) {
            return nan ? '' : value;
        }
        return parseFloat(parseFloat(value).toFixed(this.decimalPrecision));
    },

    /**
     * Fonction handling the beforeBlur event
     * @private
     */
    beforeBlur : function() {
        var v = this.parseValue(this.getRawValue());
        if (v !== '' && v !== null) {
            this.setValue(this.fixPrecision(v));
        }
    }
});