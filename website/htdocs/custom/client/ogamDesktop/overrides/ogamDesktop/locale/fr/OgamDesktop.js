/*
 * view edition
 */
Ext.define('Ginco.locale.fr.view.edition.Panel', {
    override: 'OgamDesktop.view.edition.Panel',
    toggleVisibilityLabel: 'Montrer/Cacher les champs facultatifs'
});
/*
 * Grid details panel
 */
Ext.define('Ginco.locale.fr.view.navigation.GridDetailsPanel', {
    override: 'OgamDesktop.view.navigation.GridDetailsPanel',
    panelTitle: 'Résultats pour la couche : '
});
/*
 * Advanced request panel
 */
Ext.define("Ginco.locale.fr.ux.request.AdvancedRequestFieldSet", {
    override: "OgamDesktop.ux.request.AdvancedRequestFieldSet",
    criteriaPanelTbarLabel : "<strong>Critères</strong>",
    columnsPanelTbarLabel : "<strong>Résultats</strong>"
});
/*
 * Main Panel
 */
Ext.define("Ginco.locale.fr.controller.map.Main", {
    override: "OgamDesktop.controller.map.Main",
    noGeometryErrorTitle: 'Pas de géométrie observation',
    noGeometryError: 'Cette observation n\'a pas de géométrie visible sur la carte.'
});
