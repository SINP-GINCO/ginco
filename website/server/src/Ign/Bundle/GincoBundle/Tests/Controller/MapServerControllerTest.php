<?php

namespace Ign\Bundle\GincoBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class MapServerControllerTest extends WebTestCase
{
    public function testProxy()
    {
        $client = static::createClient();

        $crawler = $client->request('GET', 'mapserverProxy.php');
    }

}
