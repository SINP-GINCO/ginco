<?php

class DEEModel {

	/**
	 * Concat time and date
	 *
	 * time fields : mask HH:mm (date('H:i'))
	 * date fields : mask yyyy-MM-dd ( date('Y-m-d') )
	 *
	 * @param $observation
	 * @return $observation
	 */
	public function concatDates($observation) 
	{
		$observation['datedetermination'] = $observation['datedetermination'] . 'T00:00:00+01:00';
		
		$observation['datefin'] = $observation['jourdatefin'] . 'T' . $observation['heuredatefin'] . ':00+01:00';
		$observation['datedebut'] = $observation['jourdatedebut'] . 'T' . $observation['heuredatedebut'] . ':00+01:00';
		
		unset($observation['heuredatedebut']);		
		unset($observation['heuredatefin']);		
		unset($observation['jourdatedebut']);		
		unset($observation['jourdatedebut']);
		
		return $observation;
	}

	/**
	 * Format date and datetime fields to expected format
	 *
	 * Datetime fields : ISO8601 ( date('c') )
	 * Date fields : format ISO de date, ex 2016-05-29 : 'Y-m-d'
	 *
	 * @param
	 *        	$observation
	 * @return mixed
	 */
	public function formatDates($observation) {
		$dateFormats = array(
			"anneerefcommune" => 'Y',
			"anneerefdepartement" => 'Y',
			"datedetermination" => 'Y-m-d',
			"dateme" => 'Y-m-d',
			"deedatedernieremodification" => 'c',
			"deedatetransformation" => 'c',
			"heuredatedebut" => 'H:i',
			"heuredatefin" => 'H:i',
			"jourdatedebut" => 'Y-m-d',
			"jourdatefin" => 'Y-m-d',
			"sensidateattribution" => 'c',
			"versionen" => 'Y-m-d'
		);
		foreach ($dateFormats as $dateField => $dateFormat) {
			if (isset($observation[$dateField]) && !empty($observation[$dateField])) {
				$date = new DateTime($observation[$dateField]);
				$observation[$dateField] = $date->format($dateFormat);
			}
		}
		$observation = $this->concatDates($observation);
		
		return $observation;
	}

	/**
	 * Transform some codes used in OGAM to DEE compliant codes
	 *
	 * @param
	 *        	$observation
	 * @return mixed
	 */
	public function transformCodes($observation) {
		$codes = array(
			'sensible' => array(
				'0' => 'NON',
				'1' => 'OUI'
			)
		);
		
		foreach ($codes as $field => $transform) {
			if (isset($observation[$field]) && isset($transform[$observation[$field]])) {
				$observation[$field] = $transform[$observation[$field]];
			}
		}
		return $observation;
	}

    /**
     * Fill values with DEE-calculated fields
     *
     * @param $observation array (associative and not nested)
     * @param $values array (associative, field => value)
     * @return array
     */
    public function fillValues($observation, $values) {
        foreach ($values as $field => $value) {
            $observation[$field] = $value;
        }
        return $observation;
    }

    /**
     * Escape special XML chars
     *
     * @param $observation array (associative and not nested)
     * @return array
     */
    public function specialCharsXML($observation) {
        // fields where NOT to escape special characters
        // geometry: because gml needs to remain intact
        $exclude = array('geometrie');

        foreach ($observation as $index => $obs) {
            if (!in_array($index, $exclude) && !empty($observation[$index])) {
                $observation[$index] = htmlspecialchars($obs, ENT_XML1, 'UTF-8');
            }
        }
        return $observation;
    }



    public function structureObservation($observation) {
		$deeStructuredObjects = array(
			'descriptifsujet' => array(
				'required' => false,
				'multiple' => false,
				'fields' => array(
					'preuveexistante' => '',
					'occstatutbiologique' => '',
					'occstatutbiogeographique' => '',
					'occstadedevie' => '',
					'occsexe' => '',
					'occnaturalite' => '',
					'occetatbiologique' => '',
					'obsmethode' => '',
					'preuvenonmumerique' => array(
						'required' => false
					),
					'obscontexte' => array(
						'required' => false
					),
					'preuvenumerique' => array(
						'required' => false
					),
					'occmethodedetermination' => array(
						'required' => false
					),
					'obsdescription' => array(
						'required' => false
					)
				)
			),
			'source' => array(
				'required' => true,
				'multiple' => false,
				'fields' => array(
					'deedatedernieremodification' => '',
					'deedatetransformation' => '',
					'dspublique' => '',
					'jddmetadonneedeeid' => '',
					'organismegestionnairedonnee' => '',
					'orgtransformation' => '',
					'sensible' => '',
					'sensiniveau' => '',
					'statutsource' => '',
					'codeidcnpdispositif' => array(
						'required' => false
					),
					'deefloutage' => array(
						'required' => false
					),
					'diffusionniveauprecision' => array(
						'required' => false
					),
					'identifiantorigine' => array(
						'required' => false
					),
					'jddcode' => array(
						'required' => false
					),
					'jddid' => array(
						'required' => false
					),
					'jddsourceid' => array(
						'required' => false
					),
					'referencebiblio' => array(
						'required' => false
					),
					'sensidateattribution' => array(
						'required' => false
					),
					'sensireferentiel' => array(
						'required' => false
					),
					'sensiversionreferentiel' => array(
						'required' => false
					)
				)
			),
			'departements' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'codedepartement' => array(
						'list' => true,
						'mainlist' => true
					),
					'anneerefdepartement' => '',
					'typeinfogeodepartement' => ''
				)
			),
			'communes' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'codecommune' => array(
						'list' => true,
						'mainlist' => true
					),
					'nomcommune' => array(
						'list' => true
					),
					'anneerefcommune' => '',
					'typeinfogeocommune' => ''
				)
			),
			'massesdeau' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'codeme' => array(
						'list' => true,
						'mainlist' => true
					),
					'versionme' => '',
					'dateme' => '',
					'typeinfogeome' => ''
				)
			),
			'mailles' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'codemaille' => array(
						'list' => true,
						'mainlist' => true
					),
					'versionrefmaille' => '',
					'nomrefmaille' => '',
					'typeinfogeomaille' => ''
				)
			),
			'espacesnaturels' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'codeen' => array(
						'list' => true,
						'mainlist' => true
					),
					'typeen' => array(
						'list' => true
					),
					'versionen' => '',
					'typeinfogeoen' => ''
				)
			),
			'denombrement' => array(
				'required' => false,
				'multiple' => false,
				'fields' => array(
					'objetdenombrement' => '',
					'denombrementmin' => '',
					'denombrementmax' => '',
					'typedenombrement' => array(
						'required' => false
					)
				)
			),
			'habitats' => array(
				'required' => false,
				'multiple' => true,
				'fields' => array(
					'refhabitat' => array(
						'list' => true,
						'mainlist' => true
					),
					'versionrefhabitat' => '',
					'codehabref' => array(
						'list' => true
					),
					'codehabitat' => array(
						'list' => true
					)
				)
			),
			'objetgeo' => array(
				'required' => false,
				'multiple' => false,
				'fields' => array(
					'geometrie' => '',
					'natureobjetgeo' => '',
					'precisiongeometrie' => array(
						'required' => false
					)
				)
			)
		);
		$observation = $this->structureObjects($observation, $deeStructuredObjects);
		
		$observation = $this->structurePersonnes($observation);
		
		return $observation;
	}

	/**
	 * Transforms a flat table with all dee fields in a structured one,
	 * following the DEE specification.
	 *
	 * Exemple flat observation:
	 * ...
	 * 'codedepartement' => "[12,45,38]"
	 * 'anneerefdepartement' => "2015"
	 * 'typeinfogeodepartement' => '1'
	 * ...
	 * Returns :
	 * 'departements' => {
	 * 0 => {
	 * 'codedepartement' => '12'
	 * 'anneerefdepartement' => "2015"
	 * 'typeinfogeodepartement' => '1'
	 * },
	 * 1 => {
	 * 'codedepartement' => '45'
	 * 'anneerefdepartement' => "2015"
	 * 'typeinfogeodepartement' => '1'
	 * },
	 * 2 =>{
	 * 'codedepartement' => '38'
	 * 'anneerefdepartement' => "2015"
	 * 'typeinfogeodepartement' => '1'
	 * }} *
	 * 
	 * @param $observation :
	 *        	flat array
	 * @param $objects :
	 *        	desription of the structure
	 * @return mixed: structured array
	 */
	protected function structureObjects($observation, $objects) {
		foreach ($objects as $label => $object) {
			
			// Read attributes or default them
			$required = (isset($object['required'])) ? $object['required'] : true; // default value for required
			$multiple = (isset($object['multiple'])) ? $object['multiple'] : false; // default value for multiple
			
			$fields = $object['fields'];
			$fieldLabels = array_keys($fields);
			
			// Do we have to create this object ?
			if ($required || $multiple) {
				// always create the object if required
				// or if multiple. If it is a multiple object with an empty mail list, it will have no children and
				// won't be rendered in twig.
				$create = true;
			} else {
				// Not required - unique
				// Test if at least one of the fields is not empty.
				$create = false;
				foreach ($fieldLabels as $field) {
					if (isset($observation[$field]) && !empty($observation[$field])) {
						$create = true;
						break;
					}
				}
			}
			
			// Creation of the object
			if ($create) {
				
				$child = array();
				
				if (!$multiple) {
					foreach ($fields as $fieldLabel => $attributes) {
						// Read attribute required or default
						$fieldRequired = (is_array($attributes) && isset($attributes['required'])) ? $attributes['required'] : true; // default value for required
						
						if ($fieldRequired) {
							$child[$fieldLabel] = (isset($observation[$fieldLabel])) ? $observation[$fieldLabel] : '';
						} else if (isset($observation[$fieldLabel]) && !empty($observation[$fieldLabel])) {
							$child[$fieldLabel] = $observation[$fieldLabel];
						}
					}
				} else { // multiple
				         
					// Read and store all attributes
				         // Find main list field
				         // Explode all lists
					$main = '';
					$lists = array();
					foreach ($fields as $fieldLabel => $attributes) {
						$fieldRequired = (is_array($attributes) && isset($attributes['required'])) ? $attributes['required'] : true; // default value for required
						$fields[$fieldLabel]['required'] = $fieldRequired;
						$fieldList = (is_array($attributes) && isset($attributes['list'])) ? $attributes['list'] : false; // default value for list
						if ($fieldList) {
							$fields[$fieldLabel]['list'] = explode(",", $observation[$fieldLabel]);
							$lists[] = $fieldLabel;
						}
						$fieldMain = (is_array($attributes) && isset($attributes['mainlist'])) ? $attributes['mainlist'] : false; // default value for required
						if ($fieldMain) {
							$main = $fieldLabel;
						}
					}
					if (!$main) {
						$main = $lists[0];
					}
					
					$mainList = $fields[$main]['list'];
					
					foreach ($mainList as $index => $value) {
						$subChild = array();
						foreach ($fieldLabels as $fieldLabel) {
							if ($fieldLabel == $main) {
								$subChild[$fieldLabel] = $value;
							} else if (in_array($fieldLabel, $lists)) {
								$subChild[$fieldLabel] = isset($fields[$fieldLabel]['list'][$index]) ? $fields[$fieldLabel]['list'][$index] : '';
							} else if ($fields[$fieldLabel]['required']) {
								$subChild[$fieldLabel] = (isset($observation[$fieldLabel])) ? $observation[$fieldLabel] : '';
							} else if (isset($observation[$fieldLabel]) && !empty($observation[$fieldLabel])) {
								$subChild[$fieldLabel] = $observation[$fieldLabel];
							}
						}
						$child[] = $subChild;
					}
				}
				
				// attach the result
				$observation[$label] = $child;
			}
			
			// Unset all processed fields from observation
			foreach ($fieldLabels as $field) {
				if (isset($observation[$field])) {
					unset($observation[$field]);
				}
			}
		}
		return $observation;
	}

	/**
	 * Structure flat 'personnes' fields into structured array
	 *
	 * @param $observation array
	 *        	with flat personnes list
	 * @return mixed array with structured personnes list
	 */
	protected function structurePersonnes($observation) {
		$persons = array(
			'observateur',
			'validateur',
			'determinateur'
		);
		
		$fields = array(
			'identite',
			'mail',
			'nomorganisme'
		);
		
		foreach ($persons as $person) {
			
			$isPersonDefined = (isset($observation[$person . 'identite']) && !empty($observation[$person . 'identite']));
			
			if ($isPersonDefined) {
				$personArray = array();
				
				// Extract variables and unset fields from initial array
				foreach ($fields as $field) {
					if (isset($observation[$person . $field])) {
						$personArray[$field] = $observation[$person . $field];
						unset($observation[$person . $field]);
					} else {
						$personArray[$field] = '';
					}
				}
				// Attach the result
				$observation[$person] = $personArray;
			}
		}
		return $observation;
	}

	/**
	 * Generate groups of observations - identified by 'identifiantregroupementpermanent'
	 * $groups[identifiantregroupementpermanet] = array(
	 * "attributes" => array(), - les attributs du regroupement et de sa source
	 * "observations" => array()) - les observations du regroupement
	 */
	public function groupObservations($observations, $groups = null) {
		if (!$groups) {
		    $groups = array();
        }
		
		// 1) Group observations
		foreach ($observations as $observation) {
			if (isset($observation['identifiantregroupementpermanent']) && !empty($observation['identifiantregroupementpermanent'])) {
				if (isset($groups[$observation['identifiantregroupementpermanent']])) {
					$groups[$observation['identifiantregroupementpermanent']]["observations"][] = $observation;
				} else {
					$groups[$observation['identifiantregroupementpermanent']] = array(
						"attributes" => array(),
						"observations" => array()
					);
					$groups[$observation['identifiantregroupementpermanent']]["observations"][] = $observation;
				}
			}
		}
		
		// 2) Compute attributes.
		// No coherence validation: value of the first observation of the group if it is the same in
		// all the group, min / max.
		foreach ($groups as $id => $group) {
			$groups[$id]['attributes']['identifiantregroupementpermanent'] = $id;
			$groups[$id]['attributes']['methoderegroupement'] = $group["observations"][0]['methoderegroupement'];
			$groups[$id]['attributes']['typeregroupement'] = $group["observations"][0]['typeregroupement'];
			
			// dspublique : si homogène, le même que les données d'observation, sinon NSP
			$groups[$id]['attributes']['dspublique'] = (count(array_unique(array_column($group["observations"], 'dspublique'))) == 1) ? reset(array_column($group["observations"], 'dspublique')) : 'NSP';
			
			// sensibilite : le max du regroupement, sensible : oui si une donnée est sensible
			$groups[$id]['attributes']['sensiniveau'] = max(array_column($group["observations"], 'sensiniveau'));
			$groups[$id]['attributes']['sensible'] = ($groups[$id]['attributes']['sensiniveau'] > 0) ? 'OUI' : 'NON';
			
			// statutsource : si homogène, le même que les données d'observation, sinon NSP
			$groups[$id]['attributes']['statutsource'] = (count(array_unique(array_column($group["observations"], 'statutsource'))) == 1) ? reset(array_column($group["observations"], 'statutsource')) : 'NSP';
			
			// jddmetadonneedeeid : sensés être tous les mêmes
			$groups[$id]['attributes']['jddmetadonneedeeid'] = reset(array_column($group["observations"], 'jddmetadonneedeeid'));
			
			// organismegestionnairedonnee > Si organisme homogène : mettre le même que pour les sujets d'observation. Sinon, "organismes multiples".
			$groups[$id]['attributes']['organismegestionnairedonnee'] = (count(array_unique(array_column($group["observations"], 'organismegestionnairedonnee'))) == 1) ? reset(array_column($group["observations"], 'organismegestionnairedonnee')) : 'Organismes multiples';
			
			// orgTransformation > Nom de la plateforme
			$groups[$id]['attributes']['orgtransformation'] = $_SERVER['HTTP_HOST'];
			
			// date de transformation = date où l'on génère la DEE = maintenant
			$groups[$id]['attributes']['deedatetransformation'] = date('c');
			
			// date de dernière modification : on remet celle rentrée lors de l'import (le max) ==> à vérifier
			$dateMax = max(array_column($group["observations"], 'deedatedernieremodification'));
			$date = new DateTime($dateMax);
			$groups[$id]['attributes']['deedatedernieremodification'] = $date->format('c');
		}
		
		return $groups;
	}
}