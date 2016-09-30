Ext.define('Ginco.view.navigation.MainWin', {
    override: 'OgamDesktop.view.navigation.MainWin',

    /**
     * Open the row details.
     * @param {String} id The details id
     * @param {String} url The url to get the details
     */
    openDetails : function(record) {
        var id = (typeof record == 'string') ? record : record.id;
        var bbox = (typeof record == 'string') ? '' : record.data.location_centroid;
        if (!Ext.isEmpty(id)) {
            this.expand();
            var tab = this.items.getByKey(id);
            if (Ext.isEmpty(tab)) {
                tab = this.add(Ext.create('OgamDesktop.view.navigation.Tab',{
                    rowId : id,
                    bbox: bbox
                }));
            }
            this.setActiveTab(tab);
        }
    }

});