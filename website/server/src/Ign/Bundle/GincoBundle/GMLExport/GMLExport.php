<?php

/**
 * Class GMLExport
 *
 * Class for the GML export of the DEE
 */
class GMLExport {

	public function indexAction($name) {
		$msg = array(
			'user_id' => 1235
		);
		$this->get('old_sound_rabbit_mq.task_example_producer')->publish(serialize($msg));
	}
}