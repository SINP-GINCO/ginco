<?php

namespace Ign\Bundle\GincoBundle\Twig;

use Symfony\Component\Yaml\Yaml;

/**
 * Provides an extension for Twig to output a link to the documentation
 * Based on the route of the page.
 *
 * Class HelpLinkExtension
 * @package Ign\Bundle\GincoBundle\Twig
 */

class HelpLinkExtension extends \Twig_Extension
{
	protected $yamlConfig;

	/**
	 * HelpLinkExtension constructor
	 *
	 * @param $configurationFilePath
	 */
	public function __construct($configurationFilePath) {
		// Read help configuration
		$this->readConfiguration($configurationFilePath);
	}

	/**
	 * Read the configuration.
	 *
	 * @param $configurationFilePath
	 */
	protected function readConfiguration($configurationFilePath) {
		$this->yamlConfig = Yaml::parse(file_get_contents($configurationFilePath));
	}

	/**
	 * {@inheritdoc}
	 */
	public function getFunctions()
	{
		return array(
			new \Twig_SimpleFunction("ginco_help_label", array($this, "getHelpLabel")),
			new \Twig_SimpleFunction("ginco_help_url", array($this, "getHelpUrl")),
		);
	}

	/**
	 * Returns the help label
	 * Or the $default value if no label found for this route
	 *
	 * @param string $route
	 * @param string $default
	 * @return mixed|string
	 */
	public function getHelpLabel($route = '', $default = 'Help')
	{
		if (($item = $this->getHelpItem($route)) && (isset($item['label']) && $item['label'])) {
			return $item['label'];
		}
		return $default;
	}

	/**
	 * Returns the help url
	 * Or the $default value if no url found for this route
	 *
	 * @param string $route
	 * @param string $default
	 * @return mixed|string
	 */
	public function getHelpUrl($route = '', $default = '/')
	{
		if (($item = $this->getHelpItem($route)) && (isset($item['url']) && $item['url'])) {
			return $item['url'];
		}
		return $default;
	}

	/**
	 * Searchs and return help item in configuration, for given route name
	 *
	 * @param $route
	 * @return array|null
	 */
	protected function getHelpItem($route)
	{
		// Read configuration file and find route
		foreach ($this->yamlConfig as $item) {
			// If we find the route in 'route', return the values
			if (isset($item['route']) && strcasecmp($item['route'],$route) == 0) {
				return $item;
			}
			// If we find the route in 'routes' array, return the values
			if (isset($item['routes']) && in_array(strtolower($route), array_map('strtolower', $item['routes']))) {
				return $item;
			}
		}
		return null;
	}


	public function getName()
	{
		return 'help_link_extension';
	}
}