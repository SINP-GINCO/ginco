Ext.define('Ginco.view.edition.Panel', {
    override: 'OgamDesktop.view.edition.Panel',

    // Change width of fields - widths of labels is in sass/src/view/edition/Panel.js
    fieldSetWidth : 700,
    fieldWidth : 650,

    toggleVisibleButton : null,
    toggleVisibilityLabel: 'Show/Hide optional fields',

    /**
     * Overwrite : add the "toggle visibility for optionel fields" button
     */
    initComponent: function () {

        // Call ogam parent initComponent
        this.callParent();

        // Hide/Show not-required fields button
        this.toggleVisibleButton = new Ext.Button({
            text: this.toggleVisibilityLabel,
            tooltip: this.toggleVisibilityLabel,
            handler: this.toggleOptionnalFieldsVisibility,
            scope: this,
            style: {
                'max-width': '200px',
                marginBottom: '10px',
                marginRight: '15px',
                float: 'right'
            }
        });
        // Insert the button in the already existing panel
        this.dataEditFS.insert(0,this.toggleVisibleButton);

    },

    /**
     * Handler for the toggle visibility button
      */
    toggleOptionnalFieldsVisibility: function () {
        Ext.each(Ext.select('.not-required'), function (item) {
            // console.log(item);
            item.toggle();
        });
        // Redo the layout to adjust height
        this.dataEditForm.updateLayout();
    },


    /**
     * Overwrite: dont'show at all non editable/inseratble fields
     */
    getFieldConfig : function(record) {
        var field = this.callParent(arguments);

        if ((this.mode === this.editMode && !Ext.isEmpty(record.editable) && record.editable !== "1")
            || (this.mode === this.addMode && !Ext.isEmpty(record.insertable) && record.insertable !== "1")) {
            field.xtype = 'hidden';
            field.cls = '';
        }

        return field;
    }

});
