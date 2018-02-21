<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class MapControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	
	public function getNotLoggedUrls() {
        return [
            'getMapParametersAction' => [[
                'uri' => '/map/get-map-parameters',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'HARMONIZED_DATA'
                    ]
                ]
            ]],
            'ajaxgetlayertreenodesAction' => [[
                'uri' => '/map/ajaxgetlayertreenodes'
            ],[
                'isJson' => true
            ]]
        ];
	}

	public function getVisitorUrls() {
        return [
        // With schema set to 'RAW_DATA'
            'getMapParametersAction__RAW_DATA' => [[
                'uri' => '/map/get-map-parameters',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'RAW_DATA'
                    ]
                ]
            ],[
                'statusCode' => Response::HTTP_FORBIDDEN
            ]],
            'ajaxgetlayertreenodesAction__RAW_DATA' => [[
                'uri' => '/map/ajaxgetlayertreenodes',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'RAW_DATA'
                    ]
                ]
            ],[
                'statusCode' => Response::HTTP_FORBIDDEN,
                'isJson' => true
            ]],
        // With schema set to 'HARMONIZED_DATA'
            'getMapParametersAction__HARMONIZED_DATA' => [[
                'uri' => '/map/get-map-parameters',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'HARMONIZED_DATA'
                    ]
                ]
            ],[
                'statusCode' => Response::HTTP_OK
            ]],
            'ajaxgetlayertreenodesAction__HARMONIZED_DATA' => [[
                'uri' => '/map/ajaxgetlayertreenodes',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'HARMONIZED_DATA'
                    ]
                ]
            ],[
                'statusCode' => Response::HTTP_OK,
                'isJson' => true
            ]]
        ];
	}

	public function getAdminUrls() {
		return [
        // With schema set to 'RAW_DATA'
            'getMapParametersAction__RAW_DATA' => [[
                'uri' => '/map/get-map-parameters',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'RAW_DATA'
                    ]
                ]
            ]],
            'ajaxgetlayertreenodesAction__RAW_DATA' => [[
                'uri' => '/map/ajaxgetlayertreenodes',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'RAW_DATA'
                    ]
				]
            ],[
					'isJson' => true
            ]],
        // With schema set to 'HARMONIZED_DATA'
            'getMapParametersAction__HARMONIZED_DATA' => [[
                'uri' => '/map/get-map-parameters',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'HARMONIZED_DATA'
				]
			]
            ]],
            'ajaxgetlayertreenodesAction__HARMONIZED_DATA' => [[
                'uri' => '/map/ajaxgetlayertreenodes',
                'sessionParameters' => [
                    '_schema' => [
                        'value' => 'HARMONIZED_DATA'
                    ]
                ]
            ],[
                'isJson' => true
            ]]
		];
	}
}