/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * Â© European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * Simple date range picker class.
 * 
 * @class OgamDesktop.ux.picker.DateRange
 * @extends Ext.Panel
 * @constructor Create a new DateRangePicker
 * @param {Object} config The config object
 * @xtype daterangepicker
 */

Ext.define('OgamDesktop.ux.picker.DateRange', {
    extend:'Ext.Panel',// OGAM-597 - TODO a component with tpl or menu may be lighter ?
    alias: 'widget.daterangepicker',
	alternateClassName:['OgamDesktop.ux.picker.DateRangePicker'],
	requires:['Ext.picker.Date'],
	/*
	 * Internationalization.
	 */ 
	//<locale>
	tbarStartDateButtonText : 'Start Date ...',
	tbarRangeDateButtonText : 'Range Date',
	tbarEndDateButtonText : '... End Date',
	fbarOkButtonText : 'ok',
	//</locale>

    /**
     * @cfg {String/Boolean} shadow
     * Specifies whether the floating component should be given a shadow. Set to true to automatically create an
     * {@link Ext.Shadow}, or a string indicating the shadow's display {@link Ext.Shadow#mode}. Set to false to
     * disable the shadow.
     */
    shadow: false,

	/**
	 * @cfg {String/Object} layout Specify the layout manager class for this
	 *      container either as an Object or as a String. See
	 *      {@link Ext.Container#layout layout manager} also. Default to
	 *      'column'.
	 */
	layout : 'column', 

	/**
	 * @cfg {String} cls An optional extra CSS class that will be added to this
	 *      component's Element (defaults to 'x-menu-date-range-item'). This can
	 *      be useful for adding customized styles to the component or any of
	 *      its children using standard CSS rules.
	 */
	cls : 'x-menu-date-range-item',

	/**
	 * @cfg {String} buttonAlign The alignment of any {@link #buttons} added to
	 *      this panel. Valid values are 'right', 'left' and 'center' (defaults
	 *      to 'center').
	 */
	buttonAlign : 'center',

	/**
	 * @cfg {Boolean} hideValidationButton if true hide the menu validation
	 *      button (defaults to false).
	 */
	hideValidationButton : false,

	/**
	 * The selected dates (Default to '{startDate:null, endDate:null}').
	 * Read-only.
	 * 
	 * @type Object
	 * @property selectedDate
	 */
	selectedDate : {
		startDate : null,
		endDate : null
	},

	/**
	 * The start date picker (The left picker).
	 * 
	 * @property startDatePicker
	 * @type Ext.DatePicker
	 */
	startDatePicker : null,

	/**
	 * The end date picker (The right picker).
	 * 
	 * @property endDatePicker
	 * @type Ext.DatePicker
	 */
	endDatePicker : null,

	/**
	 * The top toolbar.
	 * 
	 * @property tbar
	 * @type Ext.Toolbar
	 */
	tbar : null,

	/**
	 * Start button.
	 * 
	 * @type Ext.Button
	 */
	startDateButton : null,

	/**
	 * Range button.
	 * 
	 * @type Ext.Button
	 */
	rangeDateButton : null,

	/**
	 * End button.
	 * 
	 * @type Ext.Button
	 */
	endDateButton : null,

	/**
	 * The bottom toolbar.
	 * 
	 * @property fbar
	 * @type Ext.Toolbar
	 */
	fbar : null,

	/**
	 * @cfg {Object} startDatePickerConfig config for the start part
	 * @see #Ext.picker.DatePicker
	 */

	/**
	 * @cfg {Object} endDatePickerConfig config for the end part picker
	 * @see #Ext.picker.DatePicker
	 */

	/**
	 * Initialise the component.
	 */
	initComponent : function() {

		// Initialise the start picker
		this.startDatePicker = new Ext.picker.Date(Ext.apply({
			ctCls : 'x-menu-date-item',
			pickerField: this.pickerField,
			columnWidth : 0.5,
			focusable: false
		},this.startDatePickerConfig));

		// Initialise the end picker
		this.endDatePicker = new Ext.picker.Date(Ext.apply({
			ctCls : 'x-menu-date-item',
			pickerField: this.pickerField,
			columnWidth : 0.5,
			focusable: false
		}, this.endDatePickerConfig));

		// List the items
		this.items = [ this.startDatePicker, {
			xtype : 'box',
			width : 5,
			html : '&nbsp;' // For FF and IE8
		}, this.endDatePicker ];

		// Plug events
		this.startDatePicker.on('select', this.startDateSelect, this);
		this.endDatePicker.on('select', this.endDateSelect, this);

		// Initialise the buttons
		this.startDateButton = new Ext.Button({
			text : this.tbarStartDateButtonText,
			enableToggle : true,
			allowDepress : false,
			toggleGroup : 'DateButtonsGroup',
			toggleHandler : this.onStartDatePress.bind(this)
		});

		this.rangeDateButton = new Ext.Button({
			text : this.tbarRangeDateButtonText,
			pressed : true,
			enableToggle : true,
			allowDepress : false,
			toggleGroup : 'DateButtonsGroup',
			toggleHandler : this.onRangeDatePress.bind(this)
		});

		this.endDateButton = new Ext.Button({
			text : this.tbarEndDateButtonText,
			enableToggle : true,
			allowDepress : false,
			toggleGroup : 'DateButtonsGroup',
			toggleHandler : this.onEndDatePress.bind(this)
		});

		// Initialise the toolbar
		this.tbar = new Ext.toolbar.Toolbar({
			items : [ this.startDateButton, '->', this.rangeDateButton, '->', this.endDateButton ]
		});

		if (!this.hideValidationButton) {
			this.fbar = new Ext.toolbar.Toolbar({
				cls : 'o-date-range-picker-footer-toolbar',
				items : [ '->', {
					xtype : 'button',
					text : this.fbarOkButtonText,
					width : 'auto',
					handler : this.onOkButtonPress.bind(this)
				}, '->' ]
			});
		}

		this.callParent();
	},

	/**
	 * Initialise the events
	 */
	initEvents: function(){
		var me =this;
		me.callParent();

        // If this is not focusable (eg being used as the picker of a DateField)
        // then prevent mousedown from blurring the input field.
        if (!me.focusable) {
            me.el.on({
                mousedown: me.onMouseDown
            });
        }
	},

	/**
	 * Keep the tree structure correct for Ext.form.field.Picker input fields which poke a 'pickerField' reference down into their pop-up pickers.
	 * @return {Ext.form.field.PickerView} The picker field
	 */
    getRefOwner: function() {
        return this.pickerField || this.callParent();
    },

	/**
	 * Fonction handling the range date button toggle event
	 * @private
	 * @param {Ext.Button} button The range date button
	 * @param {Boolean} state True if the button is pressed
	 */
	onRangeDatePress : function(button, state) {
		if (state) {
			this.startDatePicker.enable();
			this.endDatePicker.enable();
			this.resetDates();
		}
	},

	/**
	 * Fonction handling the start date button toggle event
	 * @private
	 * @param {Ext.Button} button The start date button
	 * @param {Boolean} state True if the button is pressed
	 */
	onStartDatePress : function(button, state) {
		if (state) {
			this.startDatePicker.enable();
			this.endDatePicker.disable();
			this.resetDates();
		}
	},

	/**
	 * Fonction handling the end date button toggle event
	 * @private
	 * @param {Ext.Button} button The end date button
	 * @param {Boolean} state True if the button is pressed
	 */
	onEndDatePress : function(button, state) {
		if (state) {
			this.startDatePicker.disable();
			this.endDatePicker.enable();
			this.resetDates();
		}
	},

	/**
	 * Fonction handling the start date picker select event
	 * @private
	 * @param {Ext.picker.Date} startDatePicker The start date picker
	 * @param {Date} date The selected date
	 */
	startDateSelect : function(startDatePicker, date) {
		this.selectedDate.startDate = date;
		if (this.startDateButton.pressed) {
			this.fireSelectEventAndResetSelectedDate();
		} else { // rangeDateButton is pressed
			if (this.selectedDate.endDate !== null) {
				this.fireSelectEventAndResetSelectedDate();
			}
		}
	},

	/**
	 * Fonction handling the end date picker select event
	 * @private
	 * @param {Ext.picker.Date} endDatePicker The end date picker
	 * @param {Date} date The selected date
	 */
	endDateSelect : function(endDatePicker, date) {
		this.selectedDate.endDate = date;
		if (this.endDateButton.pressed) {
			this.fireSelectEventAndResetSelectedDate();
		} else { // rangeDateButton is pressed
			if (this.selectedDate.startDate !== null) {
				this.fireSelectEventAndResetSelectedDate();
			}
		}
	},

	/**
	 * Resets the selected date
	 */
	resetSelectedDate : function() {
		this.selectedDate = {
			startDate : null,
			endDate : null
		};
	},

	/**
	 * Reset the selected date and set the pickers values to defaults
	 */
	resetDates : function() {
		this.resetSelectedDate();
		this.startDatePicker.setValue(this.startDatePicker.defaultValue);
		this.endDatePicker.setValue(this.endDatePicker.defaultValue);
	},

	/**
	 * Fire a select event and reset the selected date
	 * @private
	 */
	fireSelectEventAndResetSelectedDate : function() {
		this.fireEvent('select', this, this.selectedDate);
		this.resetSelectedDate();
	},

	/**
	 * Checks if the date is in the interval [minDate,maxDate] of the picker
	 * @param {Ext.picker.Date} picker The picker
	 * @return {Boolean} True if the date is in the interval
	 */
	isEnabledDate : function(picker) {
		if ((picker.activeDate.getTime() - picker.minDate.getTime() >= 0) && (picker.maxDate.getTime() - picker.activeDate.getTime() >= 0)) {
			return true;
		} else {
			return false;
		}
	},

	/**
	 * Fonction handling the ok button click event
	 * @private
	 * @param {Ext.Button} button The ok button
	 * @param {Boolean} state True if the button is pressed
	 */
	onOkButtonPress : function(button, state) {
		if (state) {
			if (this.startDateButton.pressed) {
				if (this.isEnabledDate(this.startDatePicker)) {
					this.selectedDate = {
						startDate : this.startDatePicker.activeDate,
						endDate : null
					};
					this.fireSelectEventAndResetSelectedDate();
				}
			} else if (this.endDateButton.pressed) {
				if (this.isEnabledDate(this.endDatePicker)) {
					this.selectedDate = {
						startDate : null,
						endDate : this.endDatePicker.activeDate
					};
					this.fireSelectEventAndResetSelectedDate();
				}
			} else {
				if (this.isEnabledDate(this.startDatePicker) && this.isEnabledDate(this.endDatePicker)) {
					this.selectedDate = {
						startDate : this.startDatePicker.activeDate,
						endDate : this.endDatePicker.activeDate
					};
					this.fireSelectEventAndResetSelectedDate();
				}
			}
		}
	}
});