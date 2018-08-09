<?php

namespace Ign\Bundle\GincoBundle\Security\Voter;

use Symfony\Component\Security\Core\Authorization\Voter\Voter;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;

use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Ign\Bundle\GincoBundle\Entity\Website\User;

/**
 * Description of SubmissionVoter
 *
 * @author rpas
 */
class SubmissionVoter extends Voter {
	
	const VALIDATE_SUBMISSION = 'VALIDATE_SUBMISSION' ;
	
	
	protected function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(self::VALIDATE_SUBMISSION))) {
			return false ;
		}
		
		if (!$subject instanceof Submission) {
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
			
			case self::VALIDATE_SUBMISSION:
				return $this->canValidate($jdd, $user) ;
		}
	}

	
	private function canValidate(Submission $submission, User $user) {
		
		if ($user->isAllowed('VALIDATE_SUBMISSION_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_SUBMISSION_PROVIDER') && $submission->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('VALIDATE_SUBMISSION_OWN') && $submission->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
	}
}
