Ext.define("OgamDesktop.locale.fr.Application", {
    override: "OgamDesktop.Application",
    toastTitle_401: 'Erreur 401 : utilisateur non authentifié.',
    toastHtml_401: 'Veuillez vous reconnecter <a href="/user" target="_blank">ici</a>.',
    toastTitle_404: 'Erreur 404 : page non trouvée.',
    toastHtml_404: 'La ressource est introuvable.',
    toastTitle_500: 'Erreur 500 : erreur serveur.',
    toastHtml_500: 'Une erreur interne au serveur ne permet pas de répondre à la demande.',
    toastTitle_default: 'Erreur',
    toastHtml_default: 'Voir la <a href="https://fr.wikipedia.org/wiki/Liste_des_codes_HTTP" target="_blank">liste des codes de statut</a> pour plus d\'information.'
});
Ext.define("OgamDesktop.locale.fr.view.main.Main", {
    override: "OgamDesktop.view.main.Main",
	homeButtonText: 'Accueil',
	homeButtonTooltip: "Retourner à la page d'accueil"
});
Ext.define("OgamDesktop.locale.fr.controller.result.Grid", {
    override: "OgamDesktop.controller.result.Grid",
	requestLoadingMessage: 'Veuillez patienter, pendant le chargement des résultats...',
	getGridColumnsErrorTitle: 'Chargement des colonnes de la grille échoué :'
});
Ext.define("OgamDesktop.locale.fr.controller.map.Main", {
    override: "OgamDesktop.controller.map.Main",
	requestLoadingMessage: 'Veuillez patienter, pendant le chargement de la carte...',
	getresultsbboxErrorTitle: "Chargement de l'emprise échoué :"
});
Ext.define("OgamDesktop.locale.fr.controller.request.PredefinedRequest", {
    override: "OgamDesktop.controller.request.PredefinedRequest",
    loadingMsg: 'Chargement...',
    deletionConfirmTitle: 'Suppression de la requête :',
    deletionConfirmMessage: 'Êtes-vous sûr de vouloir supprimer la requête?',
    predefinedRequestDeletionErrorTitle: 'Suppression de la requête échouée:'
});
Ext.define("OgamDesktop.locale.fr.ux.request.RequestFieldSet", {
    override: "OgamDesktop.ux.request.RequestFieldSet",
	criteriaComboEmptyText : "Sélectionner...",
	taxrefLatinNameColumnTitle : 'Nom latin',
	taxrefVernacularNameColumnTitle : 'Nom vernaculaire',
	taxrefReferentColumnTitle : 'Référent'
});
Ext.define("OgamDesktop.locale.fr.ux.request.AdvancedRequestFieldSet", {
    override: "OgamDesktop.ux.request.AdvancedRequestFieldSet",
	criteriaPanelTbarLabel : "Critères",
	criteriaPanelTbarComboEmptyText : "Sélectionner...",
	criteriaPanelTbarComboLoadingText : "Recherche en cours...",
	columnsPanelTbarLabel : "Colonnes",
	columnsPanelTbarComboEmptyText : "Sélectionner...",
	columnsPanelTbarComboLoadingText : "Recherche en cours...",
	columnsPanelTbarAddAllButtonTooltip : "Ajouter toutes les colonnes",
	columnsPanelTbarRemoveAllButtonTooltip : "Supprimer toutes les colonnes"
});

Ext.define("OgamDesktop.locale.fr.ux.picker.Tree", {
	override: "OgamDesktop.ux.picker.Tree",
	okButtonText : "ok"
});

Ext.define("OgamDesktop.locale.fr.ux.picker.NumberRange", {
		override: "OgamDesktop.ux.picker.NumberRange",
		minFieldLabel : "Min",
		maxFieldLabel : "Max",
		okButtonText : "ok"
});

Ext.define("OgamDesktop.loacle.fr.ux.picker.TimeRange", {
	override: "OgamDesktop.ux.picker.TimeRange",
	minFieldLabel : "Min",
	maxFieldLabel : "Max",
	okButtonText : "ok"
});

Ext.define("OgamDesktop.locale.fr.ux.picker.DateRange", {
	override: "OgamDesktop.ux.picker.DateRange",
	tbarStartDateButtonText : "Date de début ...",
	tbarRangeDateButtonText : "Intervalle",
	tbarEndDateButtonText : "... Date de fin",
	fbarOkButtonText : "ok"
});

Ext.define("OgamDesktop.locale.fr.ux.form.field.DateRangeField", {
	override: "OgamDesktop.ux.form.field.DateRangeField",
	minText : "Les dates contenues dans ce champ doivent être égales ou postérieures au {0}",
	maxText : "Les dates contenues dans ce champ doivent être égales ou antérieures au {0}",
	reverseText : "La date de fin doit être postérieure à la date de début",
	notEqualText : "Les dates de début et de fin ne peuvent être égales",
    dateSeparator: ' - ',
    endDatePrefix: '<= ',
    startDatePrefix: '>= '
});

Ext.define("OgamDesktop.locale.fr.ux.form.field.TwinNumberField", {
	override: "OgamDesktop.ux.form.field.TwinNumberField",
	decimalSeparator : ".",
	minText : "La valeur minimum pour ce champ est {0}",
	maxText : "La valeur maximum pour ce champ est {0}",
	nanText : "'{0}' n'est pas un nombre valide"
});

Ext.define("OgamDesktop.locale.fr.ux.form.field.Tree", {
	override: "OgamDesktop.ux.form.field.Tree"
});

Ext.define("OgamDesktop.locale.fr.ux.form.field.NumberRangeField", {
	override: "OgamDesktop.ux.form.field.NumberRangeField",
	numberSeparator: ' - ',
	decimalSeparator : ".",
	maxNumberPrefix: '<= ',
	minNumberPrefix: '>= ',
	minText : "La valeur minimum pour ce champ est {0}",
	maxText : "La valeur maximum pour ce champ est {0}",
	reverseText : "Le maximum doit être supérieur au minimum",
	formatText : "Les formats corrects sont",
	nanText : "'{0}' n'est pas un nombre valide"
});

Ext.define("OgamDesktop.locale.fr.ux.form.field.GeometryField", {
	override: "OgamDesktop.ux.form.field.GeometryField",
	fieldLabel : "Localisation",
	mapWindowTitle : "Dessinez la zone recherchée sur la carte :",
	mapWindowValidateButtonText : "Valider",
	mapWindowValidateAndSearchButtonText : "Valider et rechercher",
	mapWindowCancelButtonText : "Annuler"
});

Ext.define("OgamDesktop.loacle.fr.ux.form.field.TimeRangeField", {
	override: "OgamDesktop.ux.form.field.TimeRangeField",
	formatText: 'Le format attendu est: HH:MM',
	minText : "Les heures contenues dans ce champ doivent être égales ou postérieures au {0}",
	maxText : "Les heures contenues dans ce champ doivent être égales ou antérieures au {0}",
	reverseText : "L'heure de fin doit être postérieure à l'heure de début",
	notEqualText : "Les heures de début et de fin ne peuvent être égales",
    dateSeparator: ' - ',
    maxFieldPrefix: '<= ',
    minFieldPrefix: '>= '
});

Ext.define("OgamDesktop.locale.fr.ux.grid.column.Factory", {
	override: "OgamDesktop.ux.grid.column.Factory",
	gridColumnTrueText : 'Oui',
	gridColumnFalseText : 'Non',
	gridColumnUndefinedText : '&#160;'
});

/*
 * view
 */

/*
 * view edition
 */
Ext.define('OgamDesktop.locale.fr.view.edition.Panel',{
	override:'OgamDesktop.view.edition.Panel',
	geoMapWindowTitle :'Saisir la localisation',
	unsavedChangesMessage :'Vous avez des modifications non sauvegardées',
	config:{
		title : 'Edition'
	},
	parentsFSTitle : 'Parents',
	dataEditFSDeleteButtonText :'Supprimer',
	dataEditFSDeleteButtonTooltip : 'Supprimer la donnée',
	dataEditFSDeleteButtonConfirmTitle: 'Confirmer la suppression :',
	dataEditFSDeleteButtonConfirmMessage :'Voulez-vous vraiment effacer cette donnée ?',
	dataEditFSDeleteButtonDisabledTooltip : 'La donnée ne peut pas être supprimée (des enfants existent)',
	dataEditFSValidateButtonText :  'Valider',
	dataEditFSValidateButtonTooltip :  'Sauvegarder les modifications',
	dataEditFSSavingMessage : 'Sauvegarde en cours ...',
	dataEditFSLoadingMessage : 'Chargement ...',
	dataEditFSValidateButtonDisabledTooltip :  'La donnée ne peut pas être éditée (droits manquants)',
	childrenFSTitle :  'Enfants',
	childrenFSAddNewChildButtonText : 'Ajouter',
	childrenFSAddNewChildButtonTooltip : 'Ajouter un nouvel enfant',
	contentTitleAddPrefix : 'Ajout d\'un(e)',
	contentTitleEditPrefix : 'Edition d\'un(e)',
	tipEditPrefix :'Editer le/la/l\'',
	editToastTitle : 'Soumission du formulaire :',
	deleteToastTitle : 'Opération de suppression :'
});

/*
 * view result
 */
Ext.define("OgamDesktop.locale.fr.view.result.MainWin", {
	override: 'OgamDesktop.view.result.MainWin',
	config: {
		title : 'Résultats'
	},
	locales: {
		buttons: {
			exportSplit: {
				text : 'Export',
				tooltip: 'Exporte les résultats (format CSV par défaut)'
			}
		}
	},
	csvExportMenuItemText: 'Export CSV',
	kmlExportMenuItemText: 'Export KML',
	geojsonExportMenuItemText: 'Export GeoJSON',
	csvExportAlertTitle : "Exportation d'un fichier CSV avec Internet Explorer",
	csvExportAlertMsg : "<div>Pour votre confort, utilisez Chrome ou FireFox</div>",
	maskMsg : "Chargement..."
});

Ext.define("OgamDesktop.locale.fr.view.result.GridTab", {
	override: 'OgamDesktop.view.result.GridTab',
	emptyText : "Pas de résultat...",
	openNavigationButtonTitle : "Voir les détails",
	openNavigationButtonTip : "Affiche les informations détaillées dans l'onglet des détails.",
	seeOnMapButtonTitle : "Voir sur la carte",
	seeOnMapButtonTip :  "Affiche la carte, puis zoom et centre sur la localisation.",
	editDataButtonTitle : "Editer les données",
	//	dateFormat : 'Y/m/d',
	editDataButtonTip : "Ouvre la page d'édition pour éditer les données."
});

/*
 * view request
 */
Ext.define("OgamDesktop.locale.fr.view.request.MainWin", {
	override: 'OgamDesktop.view.request.MainWin',
	config: {
		title : 'Requêteur'
	}
});

Ext.define("OgamDesktop.locale.fr.view.request.AdvancedRequest", {
	override:'OgamDesktop.view.request.AdvancedRequest',
	requestSelectTitle:'<b>Formulaires</b>',
	processPanelTitle:'Type de données',
	processCBEmptyText:'Selectionner un type de données...'
}, function(overriddenClass){

	var bbar = overriddenClass.prototype.bbar;

	// Cancel button
	Ext.apply(bbar[0], {
		text : 'Annuler',
		tooltip : 'Annuler la requête'
	});
	// Reset button
	Ext.apply(bbar[2], {
		text : 'Réinitialiser',
		tooltip : 'Réinitialiser le formulaire'
	});
	// Save button
	Ext.apply(bbar[4], {
		text : 'Enregistrer',
		tooltip : 'Enregistrer la requête'
	});
	// Submit button
	Ext.apply(bbar[6], {
		text : 'Rechercher',
		tooltip : 'Lancer la requête'
	});
});

Ext.define('OgamDesktop.locale.fr.view.request.AdvancedRequestController', {
	override:'OgamDesktop.view.request.AdvancedRequestController',
	loadingText: 'Chargement...',
	toastTitle_noColumn: 'Soumission du formulaire :',
	toastHtml_noColumn: "Il semblerait qu'aucune colonne n'ait été sélectionnées. Veuillez sélectionner au moins une colonne.",
	invalidValueSubmittedErrorTitle: 'Soumission du formulaire :',
	invalidValueSubmittedErrorMessage: 'Un champ semble contenir une erreur. Veuillez vérifier vos critères de filtrage.'
});

Ext.define('OgamDesktop.locale.fr.view.request.PredefinedRequest', {
	override:'OgamDesktop.view.request.PredefinedRequest',
	config:{
		title: 'Requêtes enregistrées'
	},
	labelColumnHeader : "Libellé",
	resetButtonText:"Réinitialiser",
	resetButtonTooltip: "Réinitialise le formulaire avec les valeurs par défaut",
	launchRequestButtonText:"Rechercher",
	launchRequestButtonTooltip:"Lance la requête dans la page de consultation",
	loadingText:"Chargement...",
	defaultErrorCardPanelText:"Désolé, le chargement a échoué...",
	criteriaPanelTitle:"Indiquez votre choix :",
	groupTextTpl:" ({children.length:plural('requête')})",
    editRequestButtonTitle:"Editer la requête",
    editRequestButtonTip:"Ouvre la page de consultation avec la requête préchargée.",
    removeRequestButtonTitle:"Supprimer la requête",
    removeRequestButtonTip:"Supprime la requête de manière permanente.",
    datasetColumnTitle:"Type de données",
    groupColumnTitle:"Groupe",
    defaultGroupName:'Non groupée{[values.rows.length > 1 ? "s" : ""]}'
});

Ext.define('OgamDesktop.locale.fr.view.request.PredefinedRequestSelector', {
	override:'OgamDesktop.view.request.PredefinedRequestSelector',
	defaultCardPanelText : 'Veuillez sélectionner une requête...',
	loadingMsg: 'Chargement...'
});
Ext.define('OgamDesktop.locale.fr.view.request.SaveRequestWindow', {
	override:'OgamDesktop.view.request.SaveRequestWindow',
	config:{
		title : 'Sauvegarder la requête'
	},
    selectionFieldsetTitle:'Sélection de la requête',
    createRadioFieldLabel:'Créer une nouvelle requête',
    editRadioFieldLabel:'Modifier une requête existante',
    resquestComboLabel:'Requête',
    comboEmptyText:'Sélectionner...',
    formFieldsetTitle:'Informations sur la requête',
    groupComboLabel:'Groupe *',
    labelTextFieldLabel:'Libellé *',
    definitionTextFieldLabel:'Description',
    radioFieldContainerLabel:'Portée',
    privateRadioFieldLabel:'Privée',
    publicRadioFieldLabel:'Publique',
	cancelButtonText:'Annuler',
	cancelButtonTooltip:'Annuler la requête',
	saveButtonText:'Enregistrer',
	saveButtonTooltip:'Enregistrer la requête',
	saveAndDisplayButtonText:'Enregistrer et visualiser',
	saveAndDisplayButtonTooltip:'Enregistrer et ouvrir la page des requêtes prédéfinies'
});
Ext.define('OgamDesktop.locale.fr.view.request.SaveRequestWindowController', {
	override:'OgamDesktop.view.request.SaveRequestWindowController',
    loadingText: 'Chargement...',
	toastTitle_invalidForm: 'Soumission du formulaire:',
	toastHtml_invalidForm: 'Le formulaire n\'est pas valide. Veuillez corriger l\'erreur(s).',
	invalidValueSubmittedErrorTitle: 'Soumission du formulaire:',
	invalidValueSubmittedErrorMessage: 'Un champ est en erreur. Veuillez vérifier vos critères de filtrage.',
	toastTitle_formSaved: 'Soumission du formulaire:',
	toastHtml_formSaved: 'Votre requête a été sauvegardée.'
});

/*
 * view map
 */
Ext.define('OgamDesktop.locale.fr.view.map.MainWin', {//TODO fix override warning
	override: 'OgamDesktop.view.map.MainWin',
	config: {
		title : 'Carte'
	}
});

Ext.define('OgamDesktop.locale.fr.view.map.MapComponentController', {
	override: 'OgamDesktop.view.map.MapComponentController',
	noFeatureErrorTitle : 'Zoom sur les résultat :',
    noFeatureErrorMessage : 'La couche des résultats ne contient aucune géométrie sur laquelle zoomer.'
});

Ext.define('OgamDesktop.locale.fr.view.map.MapToolbar', {
	override: 'OgamDesktop.view.map.MapToolbar',
	zoomToDrawingFeaturesButtonTooltip: "Zoomer sur la sélection",
	modifyfeatureButtonTooltip:"Modifier la géométrie",
	selectButtonTooltip:"Selectionner une géometrie",
	drawPointButtonTooltip:"Dessiner un point",
	drawLineButtonTooltip:"Dessiner une ligne",
	drawPolygonButtonTooltip: "Dessiner un polygone",
	deleteFeatureButtonTooltip:"Effacer la géométrie",
	validateEditionButtonTooltip:"Valider la(es) modification(s)",
	cancelEditionButtonTooltip:"Annuler la(es) modification(s)",
	resultFeatureInfoButtonTooltip: "Voir les informations sur le point",
	zoomInButtonTooltip:'Zoom en avant',
	zoomToResultFeaturesButtonTooltip:"Zoomer sur le résultat",
	zoomToMaxExtentButtonTooltip: "Zoom arrière maximum",
	printMapButtonTooltip:'Imprimer la carte'
});

Ext.define('OgamDesktop.locale.fr.view.map.MapToolbarController', {
	override: 'OgamDesktop.view.map.MapToolbarController',
	noDrawingFeatureErrorTitle : 'Zoom sur les tracés :',
    noDrawingFeatureErrorMessage : 'La couche des tracés ne contient aucune géométrie sur laquelle zoomer.'
});

Ext.define('OgamDesktop.locale.fr.view.map.toolbar.LayerFeatureInfoButton', {
	override:'OgamDesktop.view.map.toolbar.LayerFeatureInfoButton',
	tooltip: 'Voir les informations sur la couche sélectionnée',
	popupTitleText: 'Information(s) sur la couche'
});

Ext.define('OgamDesktop.locale.en.view.map.toolbar.LayerFeatureInfoButtonController', {
	override:'OgamDesktop.view.map.toolbar.LayerFeatureInfoButtonController',
	layerFeatureInfoButtonErrorTitle : "Information(s) sur la couche :",
    layerFeatureInfoButtonErrorMessage : 'Veuillez sélectionner une couche dans le menu.'
});

Ext.define('OgamDesktop.locale.fr.view.map.toolbar.SnappingButton', {
	override:'OgamDesktop.view.map.toolbar.SnappingButton',
	tooltip: 'Snapping'
});

Ext.define('OgamDesktop.locale.fr.view.map.toolbar.SelectWFSFeatureButton', {
	override:'OgamDesktop.view.map.toolbar.SelectWFSFeatureButton',
	tooltip: "Selectionner un contour sur la couche sélectionnée"
});

Ext.define('OgamDesktop.locale.en.view.map.toolbar.SelectWFSFeatureButtonController', {
	override:'OgamDesktop.view.map.toolbar.SelectWFSFeatureButtonController',
	selectWFSFeatureButtonErrorTitle : "Importation d'une géométrie :",
    selectWFSFeatureButtonErrorMessage : 'Veuillez sélectionner une couche dans le menu.'
});

Ext.define('OgamDesktop.locale.fr.view.map.MapAddonsPanel', {
	override: 'OgamDesktop.view.map.MapAddonsPanel',
	config: {
		title: 'Couches & Legendes'
	}
});

Ext.define('OgamDesktop.locale.fr.view.map.LegendsPanel', {
	override: 'OgamDesktop.view.map.LegendsPanel',
	config: {
		title:'Legendes'
	}
});

Ext.define('OgamDesktop.locale.fr.view.map.LayersPanel', {
	override: 'OgamDesktop.view.map.LayersPanel',
	config: {
		title:'Couches'
	}
});
/*
* view navigation
*/
Ext.define('OgamDesktop.locale.fr.view.navigation.MainWin', {
	override: 'OgamDesktop.view.navigation.MainWin',
	config: {
		title: 'Détails',
		printButtonText: "Imprimer"
	}
});

Ext.define('OgamDesktop.locale.fr.view.navigation.Tab', {
	override: 'OgamDesktop.view.navigation.Tab',
	config: {
		title: 'Détails'
	},
    seeChildrenButtonTitleSingular : 'Voir l\'unique enfant',
    seeChildrenButtonTitlePlural : 'Voir les enfants',
	seeChildrenButtonTip : 'Afficher les enfants dans le tableau des détails.',
    editLinkButtonTitle : 'Editer les données',
    editLinkButtonTip : 'Ouvre la page d\'édition pour éditer les données.',
    linkFieldDefaultText : 'Consulter',
    //TODO  tpl
    loadingMsg : "Cgmt..."
});

Ext.define('OgamDesktop.locale.fr.view.navigation.Tab', {
	override: 'OgamDesktop.view.navigation.GridDetailsPanel',
	config:{
		title: "Tableau(x) détaillé(s)"
	},
    loadingMsg: "Cgmt...",
    //dateFormat : 'Y/m/d',
    openNavigationButtonTitle : 'Afficher les détails',
    openNavigationButtonTip : 'Affiche la fiche détaillée dans l\'onglet des fiches détaillées.'
});