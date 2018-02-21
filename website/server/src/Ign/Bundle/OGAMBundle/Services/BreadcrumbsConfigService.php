<?php
namespace Ign\Bundle\OGAMBundle\Services;

use Symfony\Component\Yaml\Yaml;
use Symfony\Bundle\FrameworkBundle\Routing\Router;

/**
 * Class BreadcrumbsConfigService
 * @package Ign\Bundle\OGAMBundle\Services
 */
class BreadcrumbsConfigService {

    /**
     * @var Router
     */
    protected$router;

	protected $yamlConfig;

    /**
     * BreadcrumbsConfigService constructor.
     * @param Router $router
     * @param $configurationFilePath
     */
	public function __construct(Router $router, $configurationFilePath) {
	    // Set router
        $this->router = $router;
        // Read breadcrumb configuration
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
     * @return mixed
     */
	public function getConfig() {
		return $this->yamlConfig;
	}

	/**
	 * Return the config items in the path of an action.
	 *
	 * @param String $route
	 * @return array[]
	 */
	public function getPath($route) {
		return $this->getPathRecursive($this->yamlConfig, $route);
	}

    /**
     * Return the config items in the path of an action.
     *
     * @param String $route
     * @return array[]
     */
    protected function getPathRecursive($configArray, $route) {
        $result = false;
        // Search for the controller and action in the config
        foreach ($configArray as $item) {
            // If we find the route, return the values
            if (isset($item['route']) && strcasecmp($item['route'],$route) == 0) {
                    return array($item);
            }
            // If not we search deeper
            if (isset($item['pages'])) {
                $foundItem = $this->getPathRecursive($item['pages'], $route);
                if ($foundItem) {
                    if (!$result) {
                        $result = array($item);
                    }
                    $result = array_merge($result, $foundItem);
                }
            }
        }
        return $result;
    }

	/**
	 * Return the relative URL for a path item..
	 *
	 * @param array $item
	 * @return String
	 */
	public function getURL($item) {
        return (isset($item['route'])) ?
            ( (isset($item['defaults'])) ?
                $this->router->generate($item['route'],$item['defaults']) :
                $this->router->generate($item['route']) ) :
            '';
	}
}
