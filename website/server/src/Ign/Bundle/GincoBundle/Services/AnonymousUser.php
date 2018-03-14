<?php

namespace Ign\Bundle\GincoBundle\Services;

/**
 * Class AnonymousUser
 * Get the 'visiteur' User used when no user is connected (Symfony 'anonymous' user)
 *
 * @author SCandelier
 * @package Ign\Bundle\GincoBundle\Services
 */
class AnonymousUser
{
	/**
	 * @var Doctrine The entity Manager
	 */
	protected $em;
	/**
	 * @var String the name of the anonymous ('Grand Public') user
	 */
	protected $nameAnonymous;

	/**
	 * AnonymousUser constructor.
	 * @param $em Entity Manager
	 */
    public function __construct($em, $nameAnonymous)
    {
    	$this->em = $em;
		$this->nameAnonymous = $nameAnonymous;
    }

	/**
	 * Return specific user 'visiteur'
	 *
	 * @return mixed
	 */
    public function getUser() {
		return  $this->em
			->getRepository('IgnGincoBundle:Website\User')
			->findOneByUsername($this->nameAnonymous);
	}
}