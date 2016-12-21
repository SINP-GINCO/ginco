Ext.define('Ginco.view.result.MainWin', {
    override: 'OgamDesktop.view.result.MainWin',

    /**
     * @cfg {Boolean} hideExportButton if true hide the export button (defaults to false).
     */
    hideGridCsvExportMenuItem: false,
    hideGridKmlExportMenuItem: true,
    hideGridGeoJSONExportMenuItem: true

});