<?php

namespace Ign\Bundle\GincoBundle\Security\Voter ;

use Symfony\Component\Security\Core\Authorization\Voter\Voter;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\Website\User;

/**
 * Permissions sur les JDD.
 *
 * @author rpas
 */
class JddVoter extends Voter {
	
	const VALIDATE_JDD = 'VALIDATE_JDD' ;
	const GENERATE_DEE = 'GENERATE_DEE' ;
	
	protected function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(self::VALIDATE_JDD, self::GENERATE_DEE))) {
			return false ;
		}
		
		if (!$subject instanceof Jdd) {
			return false ;
		}
		
		return true ;
	}
	
	
	protected function voteOnAttribute($attribute, $subject, TokenInterface $token) {
		
		$user = $token->getUser() ;
		
		if (!$user instanceof User) {
			return false ;
		}
		
		/** @var $jdd Jdd */
		$jdd = $subject ;
		
		switch ($attribute) {
			
			case self::VALIDATE_JDD:
				return $this->canValidate($jdd, $user) ;
				
			case self::GENERATE_DEE:
				return $this->canGenerateDEE($jdd, $user) ;
		}
	}

	
	private function canValidate(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('VALIDATE_JDD_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_JDD_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_JDD_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
	}
	
	
	private function canGenerateDEE(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('GENERATE_DEE_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('GENERATE_DEE_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('GENERATE_DEE_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
	}

}
