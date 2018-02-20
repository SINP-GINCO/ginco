/**
 * This class manages the advanced request view.
 */
Ext.define('OgamDesktop.view.request.AdvancedRequestController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.advancedrequest', // enable "controller: 'advancedrequest'" in the AdvancedRequest view
    config: {
        listen: {
            store:{
                '#processStore': {
                    load: 'onProcessStoreLoad'
                }
            },
            component:{
                '#SubmitButton': {
                    click:'onSubmit'
                },
                '#CancelButton': {
                    click:'onCancel'
                },
                '#SaveButton': {
                    click:'onSave'
                },
                '#ResetButton': {
                    click:'onReset'
                }
            }
        }
    },

//<locale>
    /**
     * @cfg {String} loadingText
     * The loading text used when the submit button is pressed(defaults to <tt>'Loading...'</tt>)
     */
    loadingText: 'Loading...',
    /**
     * @cfg {String} toastTitle_noColumn
     * The toast title used for the no column error (defaults to <tt>'Form submission:'</tt>)
     */
    toastTitle_noColumn: 'Form submission:',
    /**
     * @cfg {String} toastHtml_noColumn
     * The toast html used for the no column error (defaults to <tt>'It seems that no column has been selected. Please select at least one column.'</tt>)
     */
    toastHtml_noColumn: 'It seems that no column has been selected. Please select at least one column.',
    /**
     * @cfg {String} invalidValueSubmittedErrorTitle
     * The invalid value submitted error title (defaults to <tt>'Form submission:'</tt>)
     */
    invalidValueSubmittedErrorTitle: 'Form submission:',
    /**
     * @cfg {String} invalidValueSubmittedErrorMessage
     * The invalid value submitted error message (defaults to <tt>'A field appears to contain an error. Please check your filter criteria.'</tt>)
     */
    invalidValueSubmittedErrorMessage: 'A field appears to contain an error. Please check your filter criteria.',
//</locale>

    /**
     * Set the default process after the process store load.
     * @param {Ext.data.Store} this
     * @param {Ext.data.Model[]} records An array of records
     * @param {Boolean} successful True if the operation was successful.
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     * @private
     */
    onProcessStoreLoad: function(store, records, successful, options) {
        var defaultRecord;

        if(successful){
            defaultRecord = store.findRecord('is_default', true);
            defaultRecord = defaultRecord ? defaultRecord : store.first(); 
        }
        else {
            defaultRecord = undefined;
        }
        Ext.Function.defer(this.getViewModel().set, 200, this.getViewModel(), ['currentProcess', defaultRecord]);
        //this.getViewModel().set('currentProcess', defaultRecord);
        
    },

    /**
     * Submit the current request form
     * @param button submit boutton
     */
    onSubmit: function(button){
        var form = button.up('form').getForm();
        var mask = new Ext.LoadMask({
            target : button,
            msg: this.loadingText,
            width: 110 // Must be as width as the submit button (see AdvancedRequest.js)
        });
        mask.show();

        // Checks the presence of minimum of one column
        if (form.getFields().filter('name', 'column__').getCount() > 0) {
            button.fireEvent('submitRequest', this);//the form may fire beforeaction

            Ext.Ajax.on('beforerequest', function(conn, options) {
                this.requestConn = conn;
            }, this, {
                single : true
        });
            form.submit({
                clientValidation: true,
                submitEmptyText: false,
                //waitMsg: Ext.view.AbstractView.prototype.loadingText,
                autoAbort:true,
                url: Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxbuildrequest',
                success: function(form, action) {
                    this.requestConn = null;
                    this.fireEvent('requestSuccess', action.result.columns);
                    mask.hide();
                },
                failure: function(form, action) {
                    switch (action.failureType) {
                        case Ext.form.action.Action.CLIENT_INVALID:
                            OgamDesktop.toast(this.invalidValueSubmittedErrorMessage, this.invalidValueSubmittedErrorTitle);
                            break;
                        case Ext.form.action.Action.SERVER_INVALID:
                            OgamDesktop.toast(action.result.errorMessage, this.invalidValueSubmittedErrorTitle);
                            break;
                    }
                    mask.hide();
                },
                scope: this
            });
        } else {
            OgamDesktop.toast(this.toastHtml_noColumn, this.toastTitle_noColumn);
            mask.hide();
        }
    },

    /**
     * Fonction handling the select event on the process combobox.
     * @param {Ext.form.field.ComboBox} combo This combo box
     * @param {Ext.data.Model/Ext.data.Model[]} record With {@link #multiSelect}
     * `false`, the value will be a single record. With {@link #multiSelect} `true`, the 
     * value will be an array of records.
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}.
     */
    onUpdateDataset:function(combo, record, eOpts){
        this.getViewModel().set('userchoices',[]);
         combo.selection.fieldsets({success:function(records){
            this.getViewModel().set('fieldsets',records);
         }, scope:this});
    },

    /**
     * Cancels the current ajax request.
     */
    onCancel: function(button) {
        if (this.requestConn && this.requestConn !== null) {
            this.requestConn.abort();
        }
    },

    /**
     * Resets the current request form.
     */
    onReset : function(button) {
        this.lookupReference('advancedRequestSelector').reloadForm();
    },

    /**
     * Save the request.
     */
    onSave : function(button) {
        var form = button.up('form').getForm(); // Ext.form.Basic
        // Checks the presence of minimum of one column
        if (form.getFields().filter('name', 'column__').getCount() > 0) {
            // Removes the unnecessary combobox (columns and criteria filters)
        	var values = form.getValues();
            var requestFieldsValues = {};
            for (var prop in values) {
                if ( values.hasOwnProperty( prop ) ) {
                    if(prop.indexOf('combobox-') === -1) {
                        requestFieldsValues[prop] = values[prop];
                    }
                }
            }
            // Creates the saving window
            var win = new OgamDesktop.view.request.SaveRequestWindow({
                requestId: this.getViewModel().get('requestId'),
                requestFieldsValues: requestFieldsValues
            });
            win.show();
            // Listens and changes the model request id if necessary
            win.on('requestIdChange', function(requestId){
                this.getViewModel().set('requestId', requestId);
            },this);
        } else {
            OgamDesktop.toast(this.toastHtml_noColumn, this.toastTitle_noColumn);
        }
    }
});