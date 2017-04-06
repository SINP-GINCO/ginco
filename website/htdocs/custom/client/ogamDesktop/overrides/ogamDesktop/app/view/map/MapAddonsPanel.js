/**
 * This class defines the view that contains 
 * the layers panel and the legends panel.
 */
Ext.define('Ginco.view.map.MapAddonsPanel', {
	override:'OgamDesktop.view.map.MapAddonsPanel',
	tools:[{
		type:'help',
		tooltipType:'title',
		tooltip:{
			anchor: 'left',
			title: "Information",
			text: "Date d'édition des couches d'espaces naturels"
		},
		handler : function() {
			window.open('https://www.geoportail.gouv.fr/depot/fiches/mnhn/actualite_donnees_mnhn.pdf', '_blank');
		}
	}]
});