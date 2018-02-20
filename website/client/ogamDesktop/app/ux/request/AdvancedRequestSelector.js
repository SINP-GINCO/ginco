/**
 * This class defined the advanced request selector.
 */
Ext.define('OgamDesktop.ux.request.AdvancedRequestSelector', {
    extend: 'Ext.form.FieldSet',
    xtype: 'advanced-request-selector',
    mixins: {
        storeholder: 'Ext.util.StoreHolder'
    },
    requires: [
        'OgamDesktop.ux.request.AdvancedRequestFieldSet'
    ],

    /**
     * @cfg {Array} criteriaValues The criteria values (defaults to <tt>'[]'</tt>)
     */
    criteriaValues:[],
    
    /**
     * Fonction called when the store is bound to the current instance.
     * @private
     * @param {Ext.data.AbstractStore} store The store being bound
     * @param {Boolean} initial True if this store is being bound as initialization of the instance.
     */
    onBindStore: function(store, initial){
        this.reloadForm();
    },

    /**
     * Sets the criteriaValues propertie.
     * @param {Array/Object} value The new value
     */
    setCriteriaValues:function(value){
        this.criteriaValues = (Ext.isIterable(value) || Ext.isObject(value)) ? value : [];
    },

    /**
     * Sets the currentProcess propertie.
     * @param {Object} currentProcess The currentProcess
     */
    setCurrentProcess:function(currentProcess){
        this.currentProcess = currentProcess;
    },
    
    /**
     * Reloads the form.
     */
    reloadForm: function(){
        this.removeAll();
        this.store.getData().each(function(item, index, length){

            var criteria = item.criteria(); 
            var columns =  item.columns();

            if (!(Ext.isEmpty(criteria) && Ext.isEmpty(columns))) {
                this.add({
                    xtype:'advanced-request-fieldset',
                    title : item.get('label'),
                    id : item.get('id'),
                    currentProcessId : this.currentProcess.id,
                    criteriaValues : this.criteriaValues,
                    criteriaDS : criteria,
                    columnsDS : columns
                });
            }
        },this);
        this.updateLayout();
    },

    /**
     * Destoy the component.
     */
    destroy: function () {
        this.mixins.storeholder.destroy.call(this);
        this.callParent();
    }
});