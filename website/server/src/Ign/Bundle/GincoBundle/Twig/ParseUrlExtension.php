<?php

namespace Ign\Bundle\GincoBundle\Twig;

/**
 * Provides an extension for Twig to parse urls
 *
 * Class ParseUrlExtension
 * @package Ign\Bundle\GincoBundle\Twig
 */

class ParseUrlExtension extends \Twig_Extension
{

	/**
	 * {@inheritdoc}
	 */
	public function getFilters()
	{
		return array(
			new \Twig_SimpleFilter("parse_url", array($this, "parseUrlWithComponent")),
		);
	}

	public function parseUrlWithComponent($url, $component) {
		$parsedUrl = parse_url($url);
		if (is_array($parsedUrl) && key_exists($component, $parsedUrl)) {
			return $parsedUrl[$component];
		}
		return 'Parsing error';
	}

	public function getName()
	{
		return 'parse_url_extension';
	}
}