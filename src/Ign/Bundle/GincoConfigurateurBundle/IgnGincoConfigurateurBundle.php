<?php
namespace Ign\Bundle\GincoConfigurateurBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;

class IgnGincoConfigurateurBundle extends Bundle {

	public function getParent() {
		return 'IgnOGAMConfigurateurBundle';
	}
}
