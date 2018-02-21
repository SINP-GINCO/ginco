<?php
namespace Ign\Bundle\OGAMBundle\Services;

use Symfony\Component\Security\Core\Encoder\PasswordEncoderInterface;
use Symfony\Component\HttpFoundation\Session\Session;
use Monolog\Logger;

/**
 * Implement a password encoder to use with the challenge-response authentification.
 */
class ChallengeResponseEncoder implements PasswordEncoderInterface {

	private $session;

	public function __construct(Session $session) {
		$this->session = $session;
	}

	/**
	 * Encodes the raw password.
	 *
	 * @param string $raw
	 *        	The password to encode
	 * @param string $salt
	 *        	The salt
	 *        	
	 * @return string The encoded password
	 */
	public function encodePassword($raw, $salt) {
		
		// TODO : remplacer ça par un truc plus sécurisé (bcrypt) et utilisant le salt.
		return sha1($raw);
	}

	/**
	 * Checks a raw password against an encoded password.
	 *
	 * @param string $encoded
	 *        	An encoded password
	 * @param string $raw
	 *        	A raw password
	 * @param string $salt
	 *        	The salt
	 *        	
	 * @return bool true if the password is valid, false otherwise
	 */
	public function isPasswordValid($encoded, $raw, $salt) {
		
		// Check the password validity.
		
		// $encoded comes from the database
		// $salt should be stored in the database and linked to the user (but not used now)
		
		// Here $raw is in fact not what the user typed but and already-modified password corresponding to the response of the challenge.
		// The challenge has been stored in session
		//
		// $raw = sha1($challenge + sha1 ($password))
		$challenge = $this->session->get('challenge');
		
		// Check that the response match the challenge
		return sha1($challenge . $encoded) === $raw;
	}

	/**
	 * Generate a challenge.
	 *
	 * @return string The encoded password
	 */
	public function generateChallenge() {
		$challenge = md5(uniqid(rand(), true));
		
		return $challenge;
	}
}