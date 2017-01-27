<?php
use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Config\Loader\LoaderInterface;
use Symfony\Component\DependencyInjection\Container;

class AppKernel extends Kernel {

	public function registerBundles() {
		$bundles = array(
			new Symfony\Bundle\FrameworkBundle\FrameworkBundle(),
			new Symfony\Bundle\SecurityBundle\SecurityBundle(),
			new Symfony\Bundle\TwigBundle\TwigBundle(),
			new Symfony\Bundle\MonologBundle\MonologBundle(),
			new Symfony\Bundle\SwiftmailerBundle\SwiftmailerBundle(),
			new Symfony\Bundle\AsseticBundle\AsseticBundle(),
			new Doctrine\Bundle\DoctrineBundle\DoctrineBundle(),
			new Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle(),
			new Braincrafted\Bundle\BootstrapBundle\BraincraftedBootstrapBundle(),
			new FOS\JsRoutingBundle\FOSJsRoutingBundle(),
			new Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle(),
			new Ign\Bundle\GincoConfigurateurBundle\IgnGincoConfigurateurBundle()
		);

		if (in_array($this->getEnvironment(), array(
			'dev',
			'test',
			'test_auth'
		))) {
			$bundles[] = new Symfony\Bundle\DebugBundle\DebugBundle();
			$bundles[] = new Symfony\Bundle\WebProfilerBundle\WebProfilerBundle();
			$bundles[] = new Sensio\Bundle\DistributionBundle\SensioDistributionBundle();
			$bundles[] = new Sensio\Bundle\GeneratorBundle\SensioGeneratorBundle();
		}

		return $bundles;
	}

	public function registerContainerConfiguration(LoaderInterface $loader) {
		$loader->load($this->getRootDir() . '/config/config_' . $this->getEnvironment() . '.yml');
	}

	public function getCacheDir() {
		// if SYMFONY__DATABASE__NAME is not set in environment, it is set to ''
		// in order to avoid error messages when the project is build (composer install).
		if (!array_key_exists('SYMFONY__DATABASE__NAME', $_SERVER)) {
			$_SERVER['SYMFONY__DATABASE__NAME'] = "";
		}
		return $this->rootDir . '/cache/' . $this->environment . '/' . $_SERVER['SYMFONY__DATABASE__NAME'];
	}

}
