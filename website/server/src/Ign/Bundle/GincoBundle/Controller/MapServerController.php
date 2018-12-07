<?php

namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Ign\Bundle\GincoBundle\Services\ConfigurationManager;

class MapServerController extends Controller
{
    /**
     * @Route("/mapserverProxy.php")
     */
    public function proxyAction(Request $request) {
		
		$configurationManager = $this->get('ginco.configuration_manager') ;
		
		parse_str(ltrim($_SERVER["QUERY_STRING"], '?'), $query); // recupere la requete envoyée partie (GET params)...
		$query = array_change_key_case($query, CASE_UPPER); // force les clés en majuscule
		$queryParamsAllow = array( // paramNom => requis
			'BBOX',
			'LAYERS',
			'EXCEPTIONS',
			'SRS',
			'CRS',
			'FORMAT',
			'WIDTH',
			'HEIGHT',
			'PROVIDER_ID', // TODO: use the query parameter
			'PLOT_CODE', // TODO: use the query parameter
			'TRANSPARENT',
			'VERSION',
			'STYLES',
			'QUERY_LAYERS',
			'X',
			'Y',
			'INFO_FORMAT',
			'HASSLD',
			'SERVICE',
			'REQUEST',
			'LAYER',
			'MAP.SCALEBAR',
			'OUTPUTFORMAT',
			'TYPENAME',
			'SRSNAME'
		);

		// Vérifie que les paramètres sont dans la liste des ceux autorisés
		$queriesArg = array();
		foreach ($queryParamsAllow as $param) {
			if (isset($query[$param])) {
				$queriesArg[$param] = $query[$param];
			}
		}

		// force la valeur de REQUEST
		if (!empty($queriesArg['REQUEST']) && strcasecmp($queriesArg['REQUEST'], "getlegendgraphic") == 0) {
			$queriesArg['REQUEST'] = 'GetLegendGraphic';
		} else if (!empty($queriesArg['REQUEST']) && strcasecmp($queriesArg['REQUEST'], "getmap") == 0) {
			$queriesArg['REQUEST'] = 'GetMap';
		} else {
			$queriesArg['REQUEST'] = 'GetFeature';
		}

		$headers = array('Access-Control-Allow-Origin' => '*') ;
		
		// force la valeur de SERVICE
		$geoJSONOFRequired = false;
		if (!empty($queriesArg['SERVICE']) && strcasecmp($queriesArg['SERVICE'], "WFS") !== 0) {
			$headers['Content-Type'] = 'image/png';
			$queriesArg['SERVICE'] = 'WMS';
		} elseif (!empty($queriesArg['OUTPUTFORMAT']) && (strcasecmp($queriesArg['OUTPUTFORMAT'], "geojsonogr") === 0 || strcasecmp($queriesArg['OUTPUTFORMAT'], "geojsontpl") === 0)) {
			$geoJSONOFRequired = true;
			$headers['Content-Type'] = 'application/json,subtype=geojson,charset=utf-8';
		}

		$url = $configurationManager->getConfig('mapserver_private_url') ;

		// Set the uri (url + urn)
		$uri = rtrim($url, '?') . '?' . http_build_query($queriesArg);

		$content = file_get_contents($uri);
		if ($content !== FALSE) {
			if ($content === "" && $geoJSONOFRequired) { // BugFix: gdal-bin 1.10 OGR driver return nothing when there are no feature
				$content = '{
					"type": "FeatureCollection",
					"features": []
				}';
			}
		}
		
		return new Response($content, 200, $headers) ;
    }

}
