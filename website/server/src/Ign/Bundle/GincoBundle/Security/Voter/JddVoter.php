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
	
	const LIST_JDD = 'LIST_JDD' ;
	const VIEW_JDD = 'VIEW_JDD' ;
	const CREATE_JDD = 'CREATE_JDD' ;
	const DELETE_JDD = 'DELETE_JDD' ;
	const VALIDATE_JDD = 'VALIDATE_JDD' ;
	const GENERATE_DEE = 'GENERATE_DEE' ;
	const CREATE_SUBMISION = 'CREATE_SUBMISSION' ;
	
	protected function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(
			self::LIST_JDD, 
			self::VIEW_JDD,
			self::CREATE_JDD,
			self::DELETE_JDD,
			self::VALIDATE_JDD, 
			self::GENERATE_DEE, 
			self::CREATE_SUBMISION
		))) {
			return false ;
		}
		
		if (!$subject instanceof Jdd && !is_null($subject)) {
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
			
			case self::LIST_JDD:
				return $this->canList($user) ;
			
			case self::VIEW_JDD:
				return $this->canView($jdd, $user) ;
				
			case self::CREATE_JDD:
				return $this->canCreate($user) ;
				
			case self::VALIDATE_JDD:
				return $this->canValidate($jdd, $user) ;
				
			case self::DELETE_JDD:
				return $this->canDelete($jdd, $user) ;
				
			case self::GENERATE_DEE:
				return $this->canGenerateDEE($jdd, $user) ;
				
			case self::CREATE_SUBMISION:
				return $this->canCreateSubmission($jdd, $user) ;
		}
	}

	
	public function canList(User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL') || $user->isAllowed('MANAGE_JDD_SUBMISSION_PROVIDER') || $user->isAllowed('MANAGE_JDD_SUBMISSION_OWN')) {
			return true ;
		}
		return false ;
	}
	
	public function canCreate(User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL') || $user->isAllowed('MANAGE_JDD_SUBMISSION_OWN')) {
			return true ;
		}
		return false ;
	}
	
	
	public function canView(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
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
	
	
	private function canDelete(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('DELETE_JDD_SUBMISSION_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
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
	

	private function canCreateSubmission(Jdd $jdd, User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_PROVIDER') && $jdd->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_OWN') && $jdd->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
	}
	
	
}
