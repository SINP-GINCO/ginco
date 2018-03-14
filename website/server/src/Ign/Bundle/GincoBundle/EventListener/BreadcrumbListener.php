<?php
namespace Ign\Bundle\GincoBundle\EventListener;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;

/**
 * Class BreadcrumbListener
 * Creates the breadcrumb on each request
 *
 * @package Ign\Bundle\GincoBundle\EventListener
 */
class BreadcrumbListener implements EventSubscriberInterface {
	
	// The white october breadcrumbs service
	private $breadcrumbs;
	
	// The breadcrumbs config service
	private $breadcrumbsConfig;

	/**
	 * Constructor.
	 *
	 * @param mixed $breadcrumbs
	 * @param mixed $breadcrumbsConfig
	 */
	public function __construct($breadcrumbs, $breadcrumbsConfig) {
		$this->breadcrumbs = $breadcrumbs;
		$this->breadcrumbsConfig = $breadcrumbsConfig;
	}

    /**
     * @param GetResponseEvent $event
     */
    public function onKernelRequest(GetResponseEvent $event) {
        $request = $event->getRequest();

        $pathItems = $this->breadcrumbsConfig->getPath($request->get('_route'));
        if ($pathItems) {
            foreach ($pathItems as $path) {
                $this->breadcrumbs->addItem($path['label'], $this->breadcrumbsConfig->getURL($path));
            }
        }
    }

	public static function getSubscribedEvents() {
        return array(
            KernelEvents::REQUEST => array(
                array(
                    'onKernelRequest',
                    16
                )
            )
        );
    }
}
