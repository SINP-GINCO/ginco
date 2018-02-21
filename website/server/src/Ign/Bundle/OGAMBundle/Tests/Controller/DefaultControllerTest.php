<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class DefaultControllerTest extends AbstractControllerTest {

	public function testIndex() {
		$client = static::createClient();
		
		$crawler = $client->request('GET', '/');
		
		$this->assertContains('OGAM', $client->getResponse()
			->getContent());
	}
	
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return $this->getAdminUrls();
	}

	public function getVisitorUrls() {
		return $this->getAdminUrls();
	}

	public function getAdminUrls() {
		return [
			'index' => [
				[
					'uri' => '/'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			]
		];
	}
}
