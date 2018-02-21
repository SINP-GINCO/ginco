<?php
namespace Ign\Bundle\OGAMBundle\EventListener;

use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class SchemaListener implements EventSubscriberInterface {

	private $defaultSchema;

	protected $schema;

	public function __construct($defaultSchema = 'RAW_DATA') {
		$this->defaultSchema = $defaultSchema;
	}

	public function onKernelRequest(GetResponseEvent $event) {
		$request = $event->getRequest();
		
		// Detect the "SCHEMA" parameter in URL
		$schema = $request->query->get('SCHEMA');
		if (!empty($schema)) {
			// Set the detected "SCHEMA" parameter
			$request->getSession()->set('_schema', $schema);
			$this->schema = $schema;
		} else {
			// If no explicit schema has been set on this request
			if ($request->hasPreviousSession()) {
				// Use the "SCHEMA" parameter from the previous session
				$this->schema = $request->getSession()->get('_schema', $this->defaultSchema);
			} else {
				$this->schema = $this->defaultSchema;
			}
		}
	}

	public static function getSubscribedEvents() {
		return array(
			// must be registered after the default Locale listener
			KernelEvents::REQUEST => array(
				array(
					'onKernelRequest',
					17
				)
			)
		);
	}

	public function getSchema() {
		return $this->schema;
	}
}