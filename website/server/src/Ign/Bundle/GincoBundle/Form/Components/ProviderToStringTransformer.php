<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Ign\Bundle\GincoBundle\Entity\Website\Provider;
use Ign\Bundle\GincoBundle\Services\INPNProviderService;
use Doctrine\Common\Persistence\ObjectManager;
use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;

class ProviderToStringTransformer implements DataTransformerInterface {

	private $objectManager;

	private $inpnProviderService;

	public function __construct(ObjectManager $objectManager, INPNProviderService $inpnProviderService) {
		$this->objectManager = $objectManager;
		$this->inpnProviderService = $inpnProviderService;
	}

	/**
	 * Transforms an object (provider) to a string (label (id)).
	 *
	 * @param Provider|null $provider        	
	 * @return string
	 */
	public function transform($provider) {
		if (null === $provider) {
			return '';
		}
		
		$labelAndId = $provider->getLabel() . " (" . $provider->getId() . ")";
		
		return $labelAndId;
	}

	/**
	 * Transforms a string (label (id)) to an object (provider).
	 *
	 * @param string $labelAndId        	
	 * @return Provider $provider
	 * @throws TransformationFailedException if object (provider) is not found.
	 */
	public function reverseTransform($labelAndId) {
		
		// Test and extract the id of INPN provider - in parenthesis
		$re = '/\((\d+)\)/';
		preg_match($re, $labelAndId, $matches);
		
		// Test the selection if you have the id in ()
		if (count($matches) != 0) {
			$providerId = $matches[1];
			$providerService = $this->inpnProviderService;
			$provider = $providerService->updateOrCreateLocalProvider($providerId);
		} else {
			throw new TransformationFailedException(sprintf('A provider with label (id) "%s" does not exist in INPN', $labelAndId));
		}
		
		return $provider;
	}
}