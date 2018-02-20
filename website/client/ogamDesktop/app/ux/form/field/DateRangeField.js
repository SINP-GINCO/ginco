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
 * Provides a date range input field with a {@link OgamDesktop.ux.picker.DateRange} dropdown and automatic date validation.
 *  
 * @class OgamDesktop.ux.form.field.DateRangeField
 * @extends Ext.form.DateField
 * @constructor Create a new DateRangeField
 * @param {Object} config
 * @xtype daterangefield
 */

Ext.define('OgamDesktop.ux.form.field.DateRangeField', {
    extend:'Ext.form.DateField',
    alias:'widget.daterangefield',
    requires:['OgamDesktop.ux.picker.DateRange'],
    
    /*
     * Internationalization.
     */ 
    //<locale>
    minText: "The dates in this field must be equal to or after {0}",
    maxText: "The dates in this field must be equal to or before {0}",
    reverseText: "The end date must be posterior to the start date",
    notEqualText: "The end date can't be equal to the start date",
    dateSeparator: ' - ',
    endDatePrefix: '<= ',
    startDatePrefix: '>= ',
    //</locale>
    /**
     * @cfg {Boolean} usePrefix if true, endDatePrefix and startDatePrefix are used (defaults to true).
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
    /**
     * @cfg {Date/String} minValue
     * The minimum allowed date. Can be either a Javascript date object or a string date in a
     * valid format (defaults to 'new Date(0)').
     */
    minValue : new Date(0),
    /**
     * @cfg {Date/String} maxValue
     * The maximum allowed date. Can be either a Javascript date object or a string date in a
     * valid format (defaults to 'new Date(2999,11,31)').
     */
    maxValue : new Date(2999,11,31),
    /**
     * @cfg {Date/String} minDefaultValue
     * The minimum default date. Can be either a Javascript date object or a string date in a
     * valid format (defaults to 'new Date()').
     */
    minDefaultValue : new Date(),
    /**
     * @cfg {Date/String} maxDefaultValue
     * The maximum default date. Can be either a Javascript date object or a string date in a
     * valid format (defaults to 'new Date()').
     */
    maxDefaultValue : new Date(),

    /**
     * Replaces any existing disabled dates with new values and refreshes the DateRangePicker.
     * @param {Array} disabledDates An array of date strings (see the <tt>{@link #disabledDates}</tt> config
     * for details on supported values) used to disable a pattern of dates.
     */
    setDisabledDates : function(dd){
        var me = this,
        picker = me.picker;
        me.disabledDates = dd;
        me.initDisabledDays();
        if(picker){
            picker.startDatePicker.setDisabledDates(me.disabledDatesRE);
            picker.endDatePicker.setDisabledDates(me.disabledDatesRE);
        }
    },

    /**
     * Replaces any existing disabled days (by index, 0-6) with new values and refreshes the DateRangePicker.
     * @param {Array} disabledDays An array of disabled day indexes. See the <tt>{@link #disabledDays}</tt>
     * config for details on supported values.
     */
    setDisabledDays : function(dd){
        var me = this,
        picker = me.picker;
        me.disabledDays = dd;
        if(picker){
            picker.startDatePicker.setDisabledDays(dd);
            picker.endDatePicker.setDisabledDays(dd);
        }
    },

    /**
     * Replaces any existing <tt>{@link #minValue}</tt> with the new value and refreshes the DateRangePicker.
     * @param {Date} value The minimum date that can be selected
     */
    setMinValue : function(dt){
        var me = this,
        picker = me.picker;
        me.minValue = (typeof dt === "string" ? me.parseDate(dt) : dt);
        if(picker){
            picker.startDatePicker.setMinDate(me.minValue);
            picker.endDatePicker.setMinDate(me.minValue);
        }
    },

    /**
     * Replaces any existing <tt>{@link #maxValue}</tt> with the new value and refreshes the DateRangePicker.
     * @param {Date} value The maximum date that can be selected
     */
    setMaxValue : function(dt){
        var me = this,
        picker = me.picker;
        me.maxValue = (typeof dt === "string" ? me.parseDate(dt) : dt);
        if(picker){
            picker.startDatePicker.setMaxDate(me.maxValue);
            picker.endDatePicker.setMaxDate(me.maxValue);
        }
    },

    /**
     * Runs all of NumberFields validations and returns an array of any errors. Note that this first
     * runs TextField's validations, so the returned array is an amalgamation of all field errors.
     * The additional validation checks are testing that the date format is valid, that the chosen
     * date is within the min and max date constraints set, that the date chosen is not in the disabledDates
     * regex and that the day chosed is not one of the disabledDays.
     * @param {Mixed} value The value to get errors for (defaults to the current field value)
     * @return {Array} All validation errors for this field
     */
    getErrors: function(value) {
         value = arguments.length > 0 ? value : this.formatDate(this.processRawValue(this.getRawValue()));
        var errors = Ext.form.DateField.superclass.getErrors.apply(this, [value]),
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
            var scErrors = Ext.form.DateField.superclass.getErrors.call(this, value);
            if (!Ext.isEmpty(scErrors)){
                errors.push(format(this.invalidText, value, this.format));
                return errors;
            }
        }else if(values.length === 2){
            if (!rangeDate){
                errors.push(format(this.invalidText, value, this.format+this.dateSeparator+this.format));
                return errors;
            }
            var scErrors = Ext.form.DateField.superclass.getErrors.call(this, value);
            if (!Ext.isEmpty(scErrors)){
                errors.push(format(this.invalidText, value, this.format+this.dateSeparator+this.format));
                return errors;
            }
            if (rangeDate.endDate.getTime() - rangeDate.startDate.getTime() < 0){
                errors.push(this.reverseText);
                return errors;
            }
            if (!this.authorizeEqualValues && Ext.Date.getElapsed(rangeDate.startDate, rangeDate.endDate) === 0){
                errors.push(this.notEqualText);
                return errors;
            }
        }
        //Checks if the start date is in the interval [minDate,maxDate]
        if (rangeDate.startDate !== null){
            if (rangeDate.startDate.getTime() - this.minValue.getTime() < 0){
                errors.push(format(this.minText, this.formatDate(this.minValue)));
                return errors;
            }
            if (this.maxValue.getTime() - rangeDate.startDate.getTime() < 0){
                errors.push(format(this.maxText, this.formatDate(this.maxValue)));
                return errors;
            }
        }
        //Checks if the end date is in the interval [minDate,maxDate]
        if (rangeDate.endDate !== null){
            if (rangeDate.endDate.getTime() - this.minValue.getTime() < 0){
                errors.push(format(this.minText, this.formatDate(this.minValue)));
                return errors;
            }
            if (this.maxValue.getTime() - rangeDate.endDate.getTime() < 0){
                errors.push(format(this.maxText, this.formatDate(this.maxValue)));
                return errors;
            }
        }
        return errors;
    },

    /**
     * Return a range date object or null for failed parse operations
     * @private
     * @param {String/Date/RangeDate} value The range date to parse
     * @return {Object} The parsed range date {startDate:{Date}, endDate:{Date}}
     */
    parseRangeDate : function(value){
        if(!value){
            return null;
        }
        if(this.isRangeDate(value)){
            return value;
        }
        if(Ext.isDate(value)){
            return {startDate:value, endDate:value};
        }
        var values = value.split(this.dateSeparator);
        if(values.length === 1){
            var sdpIndex = value.indexOf(this.startDatePrefix,0);
            var edpIndex = value.indexOf(this.endDatePrefix,0);
            if(sdpIndex !== -1){
            // Case ">= YYYY/MM/DD"
                var startDate = this.parseDate.call(this, value.substring(sdpIndex + this.startDatePrefix.length));
                if(startDate){
                    return {startDate:startDate, endDate:null};
                }else{
                    return null;
                }
            }else if(edpIndex !== -1){
            // Case "<= YYYY/MM/DD"
                var endDate = this.parseDate.call(this, value.substring(edpIndex + this.endDatePrefix.length));
                if(endDate){
                    return {startDate:null, endDate:endDate};
                }else{
                    return null;
                }
            }else{
            // Case "YYYY/MM/DD"
                var date = this.parseDate.call(this, value);
                if(date){
                    return {startDate:date, endDate:date};
                }else{
                    return null;
                }
            }
        }else if(values.length === 2){
            // Case "YYYY/MM/DD - YYYY/MM/DD"
            var sv = Ext.Date.parse(values[0], this.format);
            var ev = Ext.Date.parse(values[1], this.format);
            if((!sv || !ev) && this.altFormats){
                if(!this.altFormatsArray){
                    this.altFormatsArray = this.altFormats.split("|");
                }
                var i,len;
                if(!sv){
                    for(i = 0, len = this.altFormatsArray.length; i < len && !sv; i++){
                        sv = Ext.Date.parse(values[0], this.altFormatsArray[i]);
                    }
                }
                if(!ev){
                    for(i = 0, len = this.altFormatsArray.length; i < len && !ev; i++){
                        ev = Ext.Date.parse(values[1], this.altFormatsArray[i]);
                    }
                }
            }
            if(!sv || !ev){
                return null;
            }else{
                return {startDate:sv, endDate:ev};
            }
        }else{
            return null;
        }
    },

    /**
     * Format the passed date
     * @private
     * @param {Date/RangeDate} date The date to format
     * @return {String} The formated date
     */
    formatDate : function(date){
        if(Ext.isDate(date)){
            return this.callParent(arguments);
        }
        if(this.isRangeDate(date)){
            if(date.startDate === null && date.endDate !== null){
                if(this.usePrefix){
                    return this.endDatePrefix + this.callParent([date.endDate]);
                }else{
                    return this.callParent([this.minValue]) + this.dateSeparator + this.callParent([date.endDate]);
                }
            }else if(date.startDate !== null && date.endDate === null){
                if(this.usePrefix){
                    return this.startDatePrefix + this.callParent([date.startDate]);
                }else{
                    return formatDate(date.startDate, this.format) + this.dateSeparator + formatDate(this.maxValue, this.format);
                }
            }else if(date.startDate !== null && date.endDate !== null){
                if(this.mergeEqualValues && Ext.Date.getElapsed(date.startDate, date.endDate) === 0){
                    return this.callParent([date.startDate]);
                }else if(this.autoReverse && date.endDate.getTime() - date.startDate.getTime() < 0){
                    return this.callParent([date.endDate]) + this.dateSeparator + this.callParent([date.startDate]);
                }else{
                    return this.callParent([date.startDate]) + this.dateSeparator + this.callParent([date.endDate]);
                }
            }else{
                return '';
            }
        }else{
            return date;
        }
    },

    /**
     * Checks if the object is a correct range date
     * @param {Object} rangeDate The rangeDate to check. <br/>
     * An object containing the following properties:<br/>
     *      <ul><li><b>startDate</b> : Date <br/>the start date</li>
     *      <li><b>endDate</b> : Date <br/>the end date</li></ul>
     * @return {Boolean} true if the object is a range date
     */
    isRangeDate : function(rangeDate){
        return (Ext.isObject(rangeDate) && (Ext.isDate(rangeDate.startDate) || rangeDate.startDate === null) && (Ext.isDate(rangeDate.endDate) || rangeDate.endDate === null));
    },

    /**
     * Create the date range picker
     * @private
     * @return {OgamDesktop.ux.picker.DateRange} The picker
     */
    createPicker: function() {
        var me = this,
            format = Ext.String.format;
        
        if(typeof me.minDefaultValue === 'string'){
            me.minDefaultValue = new Date(me.minDefaultValue);
        }
        if(typeof me.maxDefaultValue === 'string'){
            me.maxDefaultValue = new Date(me.maxDefaultValue);
        }
        
        return new OgamDesktop.ux.picker.DateRange(
        {
            pickerField: me,
            floating: true,
            focusable: false, // Key events are listened from the input field which is never blurred
            hidden: true,
            
            hideValidationButton: me.hideValidationButton,

            showToday : me.showToday,

            listeners: {
                scope: me,
                select: me.onSelect
            },
            keyNavConfig: {
                esc: function() {
                    me.collapse();
                }
            },
            startDatePickerConfig: {
                minDate : this.minValue,
                maxDate : this.maxValue,
                defaultValue : this.minDefaultValue,
                format : this.format,
                showToday : this.showToday,
                minText : format(this.minText, this.formatDate(this.minValue)),
                maxText : format(this.maxText, this.formatDate(this.maxValue))
            },
            endDatePickerConfig: {
                minDate : this.minValue,
                maxDate : this.maxValue,
                defaultValue : this.maxDefaultValue,
                format : this.format,
                showToday : this.showToday,
                minText : format(this.minText, this.formatDate(this.minValue)),
                maxText : format(this.maxText, this.formatDate(this.maxValue))
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
        values =(this.isRangeDate(value) ? value : {startDate:new Date(),endDate:new Date()});
        this.picker.startDatePicker.setValue(values.startDate);
        this.picker.endDatePicker.setValue(values.endDate);
    },

    /**
     * Return a range date object or null for failed parse operations
     * @private
     * @param {String/Date/RangeDate} rawValue The rawValue to parse
     * @return {Object/rawValue/null} The parsed range date {startDate:{Date}, endDate:{Date}}
     */
    rawToValue: function(rawValue) {
        return this.parseRangeDate(rawValue) || rawValue || null;
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
     * @return {String} The value to be submitted, or ''.
     */
    getSubmitValue: function() {
        var value = this.getValue();

        return value ? this.formatDate(this.parseRangeDate(value)) : '';
    }
});