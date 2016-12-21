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
    panelTitle: 'Résultat(s) depuis la couche des ',
    panelTitleNoResults: 'Pas de résultats'
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
    noGeometryError: 'Cette observation n\'a pas de géométrie visible sur la carte.',
    restrainedBboxWarningTitle: 'L\'emprise spatiale des résultats est restreinte',
    restrainedBboxWarning: 'Le nombre de résultats étant très élevé, l\'emprise spatiale affichée correspond à l\'emprise par défaut de la plateforme',
});

/*
* Request field set
*/
Ext.define("Ginco.locale.fr.ux.request.RequestFieldSet", {
	override: 'OgamDesktop.ux.request.RequestFieldSet',
	taxrefScientificNameColumnTitle : 'Nom scientifique',
	taxrefScientificNameColumnTooltip : 'Le nom scientifique sans l\'autorité (LB_NOM) du taxon',
	taxrefLatinNameColumnTitle : 'Code',
	taxrefLatinNameColumnTooltip : 'Le code (CD_NOM) du taxon',
	taxrefVernacularNameColumnTitle : 'Nom vernaculaire',
	taxrefVernacularNameColumnTooltip : 'Le nom vernaculaire du taxon',
	taxrefCompleteNameColumnTitle : 'Nom complet',
	taxrefCompleteNameColumnTooltip : 'Le nom complet du taxon (nom et auteur)'
});

Ext.define("Ginco.locale.fr.view.request.AdvancedRequest", {
	override: 'OgamDesktop.view.request.AdvancedRequest',
	processPanelHelpTitle: 'Sélectionner un modèle de données',
	processPanelHelpDefinition:	"Ce composant permet de sélectionner l'ensemble de données dans lequel rechercher des données."
});
