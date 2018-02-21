<?php
namespace Ign\Bundle\OGAMBundle\Test\Helper;

use Ign\Bundle\OGAMBundle\Helper\GenerateAddLink;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;

/**
 *
 * @author FBourcier
 *        
 */
class GenerateAddLinkTest extends \PHPUnit_Framework_TestCase {

	public function testGetAddLink() {
		$helper = new GenerateAddLink();
		$keyFields = array();
		
		$tableField1 = new GenericField('myFormat', 'myfield1');
		$tableField1->setValue('value1');
		$keyFields[] = $tableField1;
		
		$tableField2 = new GenericField('myFormat', 'myfield2');
		$tableField2->setValue('value2');
		$keyFields[] = $tableField2;
		
		// génère un lien
		$link = $helper->getAddLink('mySchema', 'myFormat', $keyFields);
		
		$this->assertNotNull($link);
		
		$this->assertEquals('#edition-add/SCHEMA/mySchema/FORMAT/myFormat/myfield1/value1/myfield2/value2', $link);
	}
}