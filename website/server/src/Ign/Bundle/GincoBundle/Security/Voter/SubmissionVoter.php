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
	
	const VIEW_REPORT = 'VIEW_REPORT' ;
	const VALIDATE_SUBMISSION = 'VALIDATE_SUBMISSION' ;
	const DELETE_SUBMISSION = 'DELETE_SUBMISSION' ;
	
	
	protected function supports($attribute, $subject) {
		
		if (!in_array($attribute, array(self::VIEW_REPORT, self::VALIDATE_SUBMISSION, self::DELETE_SUBMISSION))) {
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
		
		/** @var $submission Submission */
		$submission = $subject ;
		
		switch ($attribute) {
			
			case self::VIEW_REPORT:
				return $this->canViewReport($submission, $user) ;
			
			case self::VALIDATE_SUBMISSION:
				return $this->canValidate($submission, $user) ;
				
			case self::DELETE_SUBMISSION:
				return $this->canDelete($submission, $user) ;
		}
	}

	
	private function canViewReport(Submission $submission, User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL')) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_PROVIDER') && $submission->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_OWN') && $submission->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
		return false ;
		
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
	
	
	private function canDelete(Submission $submission, User $user) {
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_ALL')) {
			return true ;
		}
		
		// C'est normal que ce soit DELETE, MANAGE_..._PROVIDER ne sert qu'à voir, pas à supprimer.
		if ($user->isAllowed('DELETE_JDD_SUBMISSION_PROVIDER') && $submission->getProvider()->getId() == $user->getProvider()->getId() && $user->hasProvider()) {
			return true ;
		}
		
		if ($user->isAllowed('MANAGE_JDD_SUBMISSION_OWN') && $submission->getUser()->getLogin() == $user->getLogin()) {
			return true ;
		}
		
	}
}
