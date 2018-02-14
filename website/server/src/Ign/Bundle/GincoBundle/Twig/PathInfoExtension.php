<?php

namespace Ign\Bundle\GincoBundle\Twig;

/**
 * Provides an extension for Twig to return the results of pathinfo
 *
 * Class ParseUrlExtension
 * @package Ign\Bundle\GincoBundle\Twig
 */

class PathInfoExtension extends \Twig_Extension
{

	/**
	 * Return filters: pathinfo_dirname, pathinfo_basename, pathinfo_extension, pathinfo_filename
	 *
	 * {@inheritdoc}
	 */
	public function getFilters()
	{
		return array(
			new \Twig_SimpleFilter("pathinfo_*", function($what, $path) {
				switch($what) {
					case 'dirname':
						return pathinfo($path, PATHINFO_DIRNAME);
					case 'basename':
						return pathinfo($path, PATHINFO_BASENAME);
					case 'extension':
						return pathinfo($path, PATHINFO_EXTENSION);
					case 'filename':
						return pathinfo($path, PATHINFO_FILENAME);
					default:
						return "Parsing error";

				}
			}),
		);
	}

	public function getName()
	{
		return 'pathinfo_extension';
	}
}