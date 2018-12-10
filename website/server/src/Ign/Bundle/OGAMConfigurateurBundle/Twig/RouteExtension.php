<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Twig;

/**
 * Provides an extension for Twig to test if a route exists
 *
 * Class RouteExtension
 * @package Ign\Bundle\OGAMConfigurateurBundle\Twig
 */
class RouteExtension extends \Twig_Extension
{
	protected $router;

	/**
	 * HelpLinkExtension constructor
	 *
	 * @param $configurationFilePath
	 */
	public function __construct($router) {
		$this->router = $router;
	}

	/**
	 * {@inheritdoc}
	 */
	public function getFunctions()
	{
		return array(
			new \Twig_SimpleFunction("route_exists", array($this, "routeExists")),
		);
	}

	/**
	 * Returns true if route exists
	 *
	 * @param $route
	 * @return bool
	 */
	public function routeExists($name)
	{
		return (null === $this->router->getRouteCollection()->get($name)) ? false : true;
	}

	public function getName()
	{
		return 'route_extension';
	}
}