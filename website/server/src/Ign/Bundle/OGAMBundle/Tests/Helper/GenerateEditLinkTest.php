<?php
namespace Ign\Bundle\OGAMBundle\Test\Helper;

use Ign\Bundle\OGAMBundle\Helper\GenerateEditLink;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Format;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableSchema;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Data;

/**
 *
 * @author FBourcier
 *        
 */
class GenerateEditLinkTest extends \PHPUnit_Framework_TestCase {

	public function testGetEditLink() {
		
		// On charge le helper à tester
		$helper = new GenerateEditLink();
		
		// On récupère un objet générique correspondant une ligne vide de la table PLOT_DATA
		// $this->get('ogam.generic_service')->buildGenericTableFormat('RAW_DATA',,= 'PLOT_DATA');
		
		// TODO GenericTableFormat mock class or smoke buildGenericTableFormat?
		$format = new TableFormat();
		$format->setFormat('PLOT_DATA');
		$format->setSchema((new TableSchema())->setCode('RAW_DATA'));
		$data = new GenericTableFormat(null, $format);
		$field1 = new GenericField('PLOT_DATA', 'PROVIDER_ID');
		$field1->setValue('1')->setMetadata((new TableField())->setData(new Data('PROVIDER_ID'))
			->setFormat($format), null);
		$data->addIdField($field1);
		$field2 = new GenericField('PLOT_DATA', 'PLOT_CODE');
		$field2->setValue('01575-14060-4-0T')->setMetadata((new TableField())->setData(new Data('PLOT_CODE'))
			->setFormat($format), null);
		$data->addIdField($field2);
		$field3 = new GenericField('PLOT_DATA', 'CYCLE');
		$field3->setValue('5')->setMetadata((new TableField())->setData(new Data('CYCLE'))
			->setFormat($format), null);
		$data->addIdField($field3);
		
		// On génère un tableau correspondant à au lien
		$link = $helper->getEditLink($data);
		
		$this->assertNotNull($link);
		
		$this->assertNotNull($link['url']);
		
		$this->assertEquals('#edition-edit/SCHEMA/RAW_DATA/FORMAT/PLOT_DATA/PROVIDER_ID/1/PLOT_CODE/01575-14060-4-0T/CYCLE/5', $link['url']);
	}
}