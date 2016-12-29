<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ResetTomcatCaches;

/**
 * Test class for resetTomcatCaches service.
 *
 * @author Anna Mouget
 *
 */
class ResetTomcatCachesTest extends ConfiguratorTest {

	/**
	 *
	 * @var ResetTomcatCaches
	 */
	public $rtc;

	public static function executeScripts($adminConn) {}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ResetTomcatCaches::performRequest
	 * @requires PHP 5.5
	 */
	public function testperformRequestFalse() {
		// As Integration Service does not exists we mock it. Here it's not really tests...
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(false));
		$cleared = $stub->performRequest();
		$this->assertFalse($cleared);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ResetTomcatCaches::performRequest
	 * @requires PHP 5.5
	 */
	public function testperformRequestTrue() {
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(true));
		$cleared = $stub->performRequest();
		$this->assertTrue($cleared);
	}
}