<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * Request
 *
 * @ORM\Table(name="mapping.requests")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Mapping\RequestRepository")
 */
class Request {

	/**
	 * The id of the request.
	 *
	 * @var int @ORM\Column(name="id", type="integer", nullable=false)
	 *      @ORM\Id
	 */
	private $id;

	/**
	 * The session id
	 *
	 * @var int @ORM\Column(name="session_id", type="string", nullable=false)
	 */
	private $sessionId;

	/**
	 * The creation date
	 *
	 * @var int @ORM\Column(name="_creationdt", type="date")
	 */
	private $creationDate;

	/**
	 * Get id
	 *
	 * @return int
	 */
	public function getId() {
		return $this->id;
	}

	/**
	 * Set id
	 *
	 * @param string $id
	 *
	 * @return Request
	 */
	public function setIdRequest($id) {
		$this->id = $id;

		return $this;
	}

	/**
	 * Get session id
	 *
	 * @return string
	 */
	public function getSessionId() {
		return $this->sessionId;
	}

	/**
	 * Set session id
	 *
	 * @param string $sessionId
	 *
	 * @return Request
	 */
	public function setSessionId($sessionId) {
		$this->sessionId = $sessionId;

		return $this;
	}

	/**
	 * Get idProvider
	 *
	 * @return string
	 */
	public function getIdProvider() {
		return $this->creationDate;
	}

	/**
	 * Set creationDate
	 *
	 * @param
	 *        	date creationDate
	 *
	 * @return Request
	 */
	public function setCreationDate($creationDate) {
		$this->creationDate = $creationDate;

		return $this;
	}
}

