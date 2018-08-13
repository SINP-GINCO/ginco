<?php

namespace Ign\Bundle\GincoBundle\Security\Voter;

use Symfony\Component\Security\Core\Authorization\Voter\Voter;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;

use Ign\Bundle\GincoBundle\Entity\Website\User;

/**
 * Description of DataVoter
 *
 * @author rpas
 */
class DataVoter extends Voter {
	
	const EDIT_DATA = "EDIT_DATA" ;
	
	public function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(self::EDIT_DATA))) {
			return false ;
		}
		
		return true ;
	}
	
	
	public function voteOnAttribute($attribute, $subject, TokenInterface $token) {
		
		$user = $token->getUser() ;
		
		if (!$user instanceof User) {
			return false ;
		};
		
		if ($user->isAllowed("EDIT_DATA_OWN") || $user->isAllowed("EDIT_DATA_PROVIDER") || $user->isAllowed("EDIT_DATA_ALL")) {
			return true ;
		}
		
		return false ;
	}
}
