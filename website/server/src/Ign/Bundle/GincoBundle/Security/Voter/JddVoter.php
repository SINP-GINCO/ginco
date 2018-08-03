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
	
	
	protected function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(self::VALIDATE_JDD))) {
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
		}
	}

	
	private function canValidate(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('VALIDATE_JDD_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_JDD_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId()) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_JDD_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
	}

}
