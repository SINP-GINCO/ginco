#Traductions
##

**parameters.yml :**

    locale: fr

**config.yml :**

    framework:
		translator:      { fallbacks: ["%locale%"] }

doit être décommentée.

**messages.fr.yml :**

Les traductions se trouvent dans le répertoire Resources/translations
Fichier messages.fr.yml pour le français. Elles s'écrivent sous la forme

	clé: valeur
	Field name: Nom du champ

#Views :
Les messages à traduire sont encadrés par des balises twig trans :

	{% trans %}Tables list{%endtrans %}

***Passage d'un paramètre :***
	
	{{'Edition'|trans({'%nom%': modele.nom}) }}

La clé 'Edition' se retouve dans messages.fr.yml

	Edition: Edition du modèle %nom%

ou de plusieurs :

	{{ 'table.delete.warning'|trans({'%table.tableName%':table.tableName, '%nomModele%': nomModele}) }}


#Form :

Les clés des traductions sont passées dans le paramètre 'label' des champs de formulaire.


	$builder->add('nom', 
					null,
					array('label' => 'Name')
					)
					
#Assert:

La traduction des messages de validation (contraintes) se fait dans le fichier **validators.fr.yml**, se trouvant dans Resources/translations

	@Assert\NotBlank(message="dataset.label.notBlank")
pour l'annotation de l'entité.

	dataset.label.notBlank: Veuillez saisir un nom de modèle d'import
	OU
	dataset:
		label:
			notBlank:Veuillez saisir un nom de modèle d'import
Dans le fichier de traduction.

#Controller:

La traduction de message peut également se faire dans les controleurs :

	$errorMessage = $this->get('Translator')->trans('This table name already exists in the model modelName', array(
					'%modelName%' => $model->getName()
				));