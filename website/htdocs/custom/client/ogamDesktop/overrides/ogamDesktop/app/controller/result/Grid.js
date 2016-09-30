Ext.define('Ginco.controller.result.Grid', {
    override: 'OgamDesktop.controller.result.Grid'

},

function(overriddenClass){
    /*
     * Override: catch the 'resultsPrepared' event instead of the 'requestSuccess'.
     * See: app/controller/map/Main.js
     */
    var config = overriddenClass.prototype.config;
    delete config.listen;
    config.listen = {
        global : {
            resultsPrepared : 'getGridColumns'
        }
    };
});