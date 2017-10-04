<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Symfony\Component\Form\DataTransformerInterface;

class LinkToJsonTransformer implements DataTransformerInterface
{
	public function __construct()
	{
	}

	/**
	* Transforms a JSON string, structure: into two fields anchor and href
	*
	*/
	public function transform($data)
	{
		return json_decode($data, true);
	}

	/**
	* Transforms the two firlds anchor and href into a json string
	*/
	public function reverseTransform($data)
	{
		return json_encode($data);
	}
}