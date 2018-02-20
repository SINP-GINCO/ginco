/**
 * This class defines the predefined request selector view.
 */
Ext.define('OgamDesktop.view.request.PredefinedRequestSelector', {
    extend : 'Ext.Panel',
    xtype : 'predefined-request-selector',
    alias : 'widget.predefined-request-selector',
    uses : [
        'OgamDesktop.model.request.predefined.PredefinedRequest',
        'Ext.form.Label'
    ],
    config : {
        /**
         * @cfg {OgamDesktop.model.request.predefined.PredefinedRequest} request A predefined request
         */
        request: undefined
    },
    
    /**
     * @cfg {String} defaultCardPanelText The default Card Panel Text (defaults
     *      to <tt>'Please select a request...'</tt>)
     */
    defaultCardPanelText : 'Please select a request...',
    
    /**
     * @cfg {String} loadingMsg
     * The loading message (defaults to <tt>'Loading...'</tt>)
     */
    loadingMsg: 'Loading...',

    scrollable: true,

    /**
     * Fonction handling the update of the request property
     * @param {OgamDesktop.model.request.predefined.PredefinedRequest} n The new value
     * @param {OgamDesktop.model.request.predefined.PredefinedRequest} o The old value
     */
    updateRequest : function(n, o) {
        Ext.suspendLayouts();
        this.removeAll();
    
        if (n && !Ext.isEmpty(n)) {
            this.add([{ // Dataset fieldset
                xtype: 'fieldset',
                title: 'Type de données',
                hideMode: 'display',
                margin: '10 10 10 10',
                defaults:{
                    margin: '10 0 10 10',
                    style:'display:block;'
                },
                items: [{
                    xtype: 'label',
                    html: n.get("dataset_label")
                }]
            },{ // Criteria fieldset
                xtype: 'fieldset',
                itemId: 'criteriaFieldset',
                title: 'Critères',
                cls: 'o-saved-request-criteria-fieldset',
                hideMode: 'display',
                margin: '10 10 10 10',
                minHeight:50,
                defaults:{
                    margin: '10 0 10 10'
                },
                items: [{ // Loading message
                    xtype: 'label',
                    style: 'display:block;',
                    html: '<span class="x-mask-msg-text">' + this.loadingMsg + '</span>'
                }]
            },{ // Columns fieldset
                xtype:'fieldset',
                itemId: 'columnsFieldset',
                title: 'Colonnes',
                hideMode: 'display',
                margin: '10 10 10 10',
                minHeight:50,
                defaults:{
                    margin: '10 0 10 10',
                    style:'display:block;'
                },
                items: [{ // Loading message
                    xtype: 'label',
                    style: 'display:block;',
                    html: '<span class="x-mask-msg-text">' + this.loadingMsg + '</span>'
                }]
            }]);
            
            n.reqfieldsets({ // Get the criteria and columns information
                success:function(records){
                    var criteria = [];
                    var columns = [];
                    records.each(function(fieldset) { // OgamDesktop.model.request.FieldSet
                        fieldset.criteria().each(function(criterion) { // OgamDesktop.model.request.fieldset.Criterion
                            if(criterion.get('is_default')){
                                criteria.push(OgamDesktop.ux.request.RequestFieldSet.getCriteriaConfig(criterion, true));
                            }
                        }, this);
                        fieldset.columns().each(function(column) { // OgamDesktop.model.request.fieldset.Column
                            if(column.get('is_default')){
                                columns.push(OgamDesktop.ux.request.RequestFieldSet.getColumnConfig(column));
                            }
                        }, this);
                    }, this);
                    
                    this.queryById('criteriaFieldset').removeAll();
                    this.queryById('columnsFieldset').removeAll();
                    this.queryById('criteriaFieldset').add(criteria);
                    this.queryById('columnsFieldset').add(columns);
                    
                },
                scope:this
            });
        } else {
            // Default message
            this.add([{
                xtype : 'box',
                margin: '10 10 10 10',
                html : this.defaultCardPanelText
            }]);
        }
        Ext.resumeLayouts(true);
    }
});