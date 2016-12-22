Ext.define('Ginco.view.request.AdvancedRequest', {
    override: 'OgamDesktop.view.request.AdvancedRequest'

}, function(overriddenClass){

    var bbar = overriddenClass.prototype.bbar;

    // Submit button: add the x-btn-submit class
    Ext.apply(bbar[4], {
        cls: 'x-btn-submit'
    });

    // Cancel and reset button: add the x-btn-cancel class
    Ext.apply(bbar[0], {
        cls: 'x-btn-cancel'
    });
    Ext.apply(bbar[2], {
        cls: 'x-btn-cancel'
    });
});