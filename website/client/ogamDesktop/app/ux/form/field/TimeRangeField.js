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
 * Provides a date range input field with a {@link OgamDesktop.ux.picker.TimeRange} dropdown and automatic date validation.
 *  
 * @class OgamDesktop.ux.form.field.TimeRangeField
 * @extends Ext.form.field.Picker
 * @mixins Ext.form.TimeField
 * @constructor Create a new TimeRangeField
 * @param {Object} config
 * @xtype timerangefield
 */

Ext.define('OgamDesktop.ux.form.field.TimeRangeField', {
    extend:'Ext.form.field.Picker',
    alias:'widget.timerangefield',
    requires:[
              'OgamDesktop.ux.picker.TimeRange',
              'Ext.form.field.Date'
              ],
    mixins:{
        mxTime:'Ext.form.field.Time'
    },
    /*
     * Internationalization.
     */ 
    //<locale>
    formatText: 'Expected time format: HH:MM',
    minText: "The times in this field must be equal to or after {0}",
    maxText: "The times in this field must be equal to or before {0}",
    reverseText: "The end time must be posterior to the start time",
    notEqualText: "The end time can't be equal to the start time",
    dateSeparator: ' - ',
    maxFieldPrefix: '<= ',
    minFieldPrefix: '>= ',
    /**
     * @cfg {String} [format=undefined]
     * The default time format string which can be overridden for localization support. 
     * The format must be valid according to {@link Ext.Date#parse}.
     *
     * Defaults to `'h:i'`, e.g., `'17:15'`..
     */
    format : "H:i",
    //</locale>
    
    /**
     * @cfg {Boolean} usePrefix if true, maxFieldPrefix and minFieldPrefix are used (defaults to true).
     * Otherwise minValue and maxValue are used.
     */
    usePrefix: true,
    /**
     * @cfg {Boolean} hideValidationButton if true, hide the menu validation button (defaults to false).
     */
    hideValidationButton : false,
    /**
     * @cfg {Boolean} authorizeEqualValues if true, a unique value 
     * can be entered for the min and the max values.
     * If false, the min and max values can't be equal (defaults to true).
     */
    authorizeEqualValues : true,
    /**
     * @cfg {Boolean} mergeEqualValues if true and if the max and min values
     * are equal, an unique value will be displayed instead of the min and max values.
     * (authorizeEqualValues must be set to true)
     * If false, the min and max values are displayed normally even if they are equals (defaults to true).
     */
    mergeEqualValues : true,
    /**
     * @cfg {Boolean} autoReverse if true, reverse the min and max values if max < min (defaults to true).
     */
    autoReverse : true,
    config:{
    /**
     * @cfg {String} minValue
     * The minimum allowed time.
     * defaults to '00:00').
     */
    minValue : '00:00',
    /**
     * @cfg {String} maxValue
     * The maximum allowed time. match with format
     *(defaults to '23:59').
     */
    maxValue : '23:59'
    },

    /**
     * Replaces any existing <tt>{@link #minValue}</tt> with the new value and refreshes the TimeRangePicker.
     * @param {Date} value The minimum date that can be selected
     */
    setMinValue : function(dt){
        var me = this,
        picker = me.picker;
        me.minValue = (typeof dt === "string" ? me.parseDate(dt) : dt);
        if(picker){
            picker.minField.setMinValue(me.minValue);
            picker.maxField.setMinValue(me.minValue);
        }
    },

    /**
     * Replaces any existing <tt>{@link #maxValue}</tt> with the new value and refreshes the TimeRangePicker.
     * @param {Date} value The maximum date that can be selected
     */
    setMaxValue : function(dt){
        var me = this,
        picker = me.picker;
        me.maxValue = (typeof dt === "string" ? me.parseDate(dt) : dt);
        if(picker){
            picker.minField.setMaxValue(me.maxValue);
            picker.maxField.setMaxValue(me.maxValue);
        }
    },

    /**
     * @param {Mixed} value The value to get errors for (defaults to the current field value)
     * @return {Array} All validation errors for this field
     */
    getErrors: function(value) {
        value = arguments.length > 0 ? value : this.formatDate(this.processRawValue(this.getRawValue()));
        var errors = this.callParent([value]);
        format = Ext.String.format;
        
        if (value.length < 1){ // if it's blank and textfield didn't flag it then it's valid
             return errors;
        }
        var values = value.split(this.dateSeparator);
        if (values.length !== 1 && values.length !== 2){
            errors.push(format(this.invalidText, value, this.format+this.dateSeparator+this.format));
            return errors;
        }
        var rangeDate = this.parseRangeDate(value);
        if(values.length === 1){
            if (!rangeDate){
                errors.push(format(this.invalidText, value, this.format));
                return errors;
            }
            var scErrors = this.callParent([value]);//picker getError
            if (!Ext.isEmpty(scErrors)){
                errors.push(format(this.invalidText, value, this.format));
                return errors;
            }
        }else if(values.length === 2){
            if (!rangeDate){
                errors.push(format(this.invalidText, value, this.format+this.dateSeparator+this.format));
                return errors;
            }
            var scErrors = this.callParent([value]);//picker getError
            if (!Ext.isEmpty(scErrors)){
                errors.push(format(this.invalidText, value, this.format+this.dateSeparator+this.format));
                return errors;
            }
            if (rangeDate.endTime.getTime() - rangeDate.startTime.getTime() < 0){
                errors.push(this.reverseText);
                return errors;
            }
            if (!this.authorizeEqualValues && Ext.Date.getElapsed(rangeDate.startTime, rangeDate.endTime) === 0){
                errors.push(this.notEqualText);
                return errors;
            }
        }
        //Checks if the start date is in the interval [minDate,maxDate]
        if (rangeDate.startTime !== null){
            if (this.minValue && (rangeDate.startTime.getTime() - this.minValue.getTime() < 0)){
                errors.push(format(this.minText, this.formatDate(this.minValue)));
                return errors;
            }
            if (this.maxValue && (this.maxValue.getTime() - rangeDate.startTime.getTime() < 0)){
                errors.push(format(this.maxText, this.formatDate(this.maxValue)));
                return errors;
            }
        }
        //Checks if the end date is in the interval [minDate,maxDate]
        if (rangeDate.endTime !== null){
            if (this.minValue && (rangeDate.endTime.getTime() - this.minValue.getTime() < 0)){
                errors.push(format(this.minText, this.formatDate(this.minValue)));
                return errors;
            }
            if (this.maxValue && (this.maxValue.getTime() - rangeDate.endTime.getTime() < 0)){
                errors.push(format(this.maxText, this.formatDate(this.maxValue)));
                return errors;
            }
        }
        return errors;
    },

    /**
     * Return a range time object or null for failed parse operations
     * @private
     * @param {String/Date/RangeTime} value The range time to parse
     * @return {Object} The parsed range time {minField:{Date}, maxField:{Date}}
     */
    parseRangeDate : function(value){
        if(!value){
            return null;
        }
        if(this.isRangeDate(value)){
            return value;
        }
        if(Ext.isDate(value)){
            return {startTime:value, endTime:value};
        }
        var values = value.split(this.dateSeparator);
        if(values.length === 1){
            var sdpIndex = value.indexOf(this.minFieldPrefix,0);
            var edpIndex = value.indexOf(this.maxFieldPrefix,0);
            if(sdpIndex !== -1){
            // Case ">= time"
                var minField = this.parseDate.call(this, value.substring(sdpIndex + this.minFieldPrefix.length));
                if(minField){
                    return {startTime:minField, endTime:null};
                }else{
                    return null;
                }
            }else if(edpIndex !== -1){
            // Case "<= time"
                var maxField = this.parseDate.call(this, value.substring(edpIndex + this.maxFieldPrefix.length));
                if(maxField){
                    return {startTime:null, endTime:maxField};
                }else{
                    return null;
                }
            }else{
            // Case "time"
                var date = this.parseDate.call(this, value);
                if(date){
                    return {startTime:date, endTime:date};
                }else{
                    return null;
                }
            }
        }else if(values.length === 2){
            // Case "time1 - time2"
            var sv = this.parseDate(values[0]);
            var ev = this.parseDate(values[1]);
            if(!sv || !ev){
                return null;
            }else{
                return {startTime:sv, endTime:ev};
            }
        }else{
            return null;
        }
    },

    /**
     * Format the passed date
     * @private
     * @param {Date/RangeDate} date The date to format
     * @pram {String} format default {@link #format}.
     * @return {String} The formated date
     */
    formatDate : function(date, format){
        format = format || this.format;
        var callFormat =Ext.form.field.Date.prototype.formatDate;
        if(Ext.isDate(date)){
            return Ext.form.field.Date.prototype.formatDate.call(this, date, format);//this.mixins.mxTime.formatDate.call(this,date);
        }
        if(this.isRangeDate(date)){
            if(date.startTime === null && date.endTime !== null){
                if(this.usePrefix){
                    return this.maxFieldPrefix + this.formatDate(date.endTime, format);
                }else{
                    return this.formatDate(this.minValue) + this.dateSeparator + this.formatDate(date.endTime, format);
                }
            }else if(date.startTime !== null && date.endTime === null){
                if(this.usePrefix){
                    return this.minFieldPrefix + callFormat.call(this,date.startTime, format);
                }else{
                    return this.formatDate(date.startTime, format) + this.dateSeparator + this.formatDate(this.maxValue, format);
                }
            }else if(date.minField !== null && date.maxField !== null){
                if(this.mergeEqualValues && Ext.Date.getElapsed(date.startTime, date.endTime) === 0){
                    return this.formatDate(date.startTime, format);
                }else if(this.autoReverse && date.endTime.getTime() - date.startTime.getTime() < 0){
                    return this.formatDate(date.endTime, format) + this.dateSeparator + this.formatDate(date.startTime, format);
                }else{
                    return this.formatDate(date.startTime, format) + this.dateSeparator + this.formatDate(date.endTime, format);
                }
            }else{
                return '';
            }
        }else{
            return date;
        }
    },
    parseDate:function(value){
        return this.mixins.mxTime.parseDate.call(this,value);
    },

    /**
     * Checks if the object is a correct range date
     * @param {Object} rangeDate The rangeDate to check. <br/>
     * An object containing the following properties:<br/>
     *      <ul><li><b>minField</b> : Date <br/>the start date</li>
     *      <li><b>maxField</b> : Date <br/>the end date</li></ul>
     * @return {Boolean} true if the object is a range date
     */
    isRangeDate : function(rangeDate){
        
        return (Ext.isObject(rangeDate) && (this.isDateOTime(rangeDate.startTime) || rangeDate.startTime === null) && (this.isDateOTime(rangeDate.endTime) || rangeDate.endTime === null));
    },
    isDateOTime: function (date){
        return Ext.isDate(this.parseDate(date));
    },
    /**
     * Create the date range picker
     * @private
     * @return {OgamDesktop.ux.picker.DateRange} The picker
     */
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        
        
        return new OgamDesktop.ux.picker.TimeRange(
        {
            pickerField: me,
            floating: true,
            focusable: false, // Key events are listened from the input field which is never blurred
            hidden: true,
            
            hideValidationButton: me.hideValidationButton,

            listeners: {
                scope: me,
                select: me.onSelect
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            },
            format:me.format,
            minField: {
                minValue : me.minValue,
                maxValue : me.maxValue,
                value : me.minDefaultValue,
                format : me.format,
                minText : format(me.minText, me.formatDate(me.minValue)),
                maxText : format(me.maxText, me.formatDate(me.maxValue))
            },
            maxField: {
                minValue : me.minValue,
                maxValue : me.maxValue,
                value : me.maxDefaultValue,
                format : me.format,
                minText : format(me.minText, me.formatDate(me.minValue)),
                maxText : format(me.maxText, me.formatDate(me.maxValue))
            }
        }
        );
    },
    
    /**
     * Manage the select event
     * @private
     * @param {Ext.form.field.Picker} field This field instance
     * @param {Object} value The value that was selected
     */
    onSelect: function(field, value) {
        var me = this;
        me.setValue(value);
        me.fireEvent('select', me, value);
        me.collapse();
    },

    /**
     * Sets the Date picker's value to match the current field value when expanding.
     * @private
     */
    onExpand: function() {
        var value = this.getValue(),
        values =(this.isRangeDate(value) ? value : {startTime:new Date(),endTime:new Date()});
        this.picker.minField.setValue(values.startTime);
        this.picker.maxField.setValue(values.endTime);
    },

    /**
     * Return a range date object or null for failed parse operations
     * @private
     * @param {String/Date/RangeDate} rawValue The rawValue to parse
     * @return {Object/null} The parsed range time {startTime:{Date}, endTime:{Date}}
     */
    rawToValue: function(rawValue) {
        return this.parseRangeDate(rawValue) || null;
    },

    /**
     * Parse and format the passed date
     * @private
     * @param {String/Date/RangeDate} value The value to parse
     * @return {String} The formated date
     */
    valueToRaw: function(value) {
        return this.formatDate(this.parseRangeDate(value));
    },
    /**
     * Returns the submit value for the dateRange which can be used when submitting forms.
     * @private
     * @return {String} The value to be submitted, or null.
     */
    getSubmitValue: function() {
        var value = this.getValue();

        return value ? this.formatDate(this.parseRangeDate(value), this.submitFormat || this.format) : null;
    },
    getValue: function () {
        return this.rawToValue(this.callParent(arguments));
    }
});