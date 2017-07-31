<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils\TablesGenerationTest as TablesGenerationTestBase;

/**
 * This test class is for custom TablesGenerationTest
 */
class TablesGenerationTest extends TablesGenerationTestBase {

	/**
	 * Tests if a trigger is created on the table observation (has the "identifiantpermanent" column)
	 * But not on the table localisation (has not the column)
	 */
	public function testCreateIdentifierTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_localisation'
				and trigger_name LIKE 'perm_id_generate%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 0);

		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name LIKE 'perm_id_generate%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}

	/**
	 * Tests if sensitive triggers are created on the table observation (has the needed columns)
	 */
	public function testCreateSensitiveTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name = 'sensitive_manual'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);

		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name = 'sensitive_automatic'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}

	/**
	 * Tests if init trigger is created on the table observation (has the needed columns)
	 */
	public function testInitTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name LIKE 'init_trigger%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}
}