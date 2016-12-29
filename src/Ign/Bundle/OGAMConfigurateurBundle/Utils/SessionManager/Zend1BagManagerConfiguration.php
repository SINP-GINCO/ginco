<?php
namespace Ign\Bundle\ConfigurateurBundle\Utils\SessionManager;

use Theodo\Evolution\Bundle\SessionBundle\Manager\BagManagerConfigurationInterface;

class Zend1BagManagerConfiguration implements BagManagerConfigurationInterface {

	public function getNamespaces() {
		/*
		 * This is the important part. Just return an array of all $_SESSION keys
		 * which you want to be available as bags.
		 */
		return [
			'user',
		];
	}

	public function getNamespace($key) {
		return $key;
	}

	public function isArray($namespaceName) {
		/*
		 * If some of the $_SESSION values are in fact arrays, you should return true
		 * here for corresponding keys.
		 */
		if ($namespaceName == 'user') {
			return true;
		}

		return false;
	}
}