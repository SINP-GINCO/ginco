<?php
namespace Ign\Bundle\OGAMBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * ResultLocation
 *
 * @ORM\Table(name="mapping.result_location")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Mapping\ResultLocationRepository")
 */
class ResultLocation {

	/**
	 *
	 * @var int @ORM\Column(name="id", type="integer")
	 *      @ORM\Id
	 *      @ORM\GeneratedValue(strategy="AUTO")
	 */
	private $id;

	/**
	 *
	 * @var string @ORM\Column(name="session_id", type="string", length=50)
	 */
	private $sessionId;

	/**
	 *
	 * @var string @ORM\Column(name="pk", type="string", length=100)
	 */
	private $pk;

	/**
	 *
	 * @var string @ORM\Column(name="format", type="string", length=36)
	 */
	private $format;

	/**
	 *
	 * @var string @ORM\Column(name="the_geom", type="text")
	 */
	private $theGeom;

	/**
	 *
	 * @var \Date @ORM\Column(name="_creationdt", type="date", nullable=true)
	 */
	private $creationdt;

	/**
	 * Get id
	 *
	 * @return int
	 */
	public function getId() {
		return $this->id;
	}

	/**
	 * Set sessionId
	 *
	 * @param string $sessionId        	
	 *
	 * @return ResultLocation
	 */
	public function setSessionId($sessionId) {
		$this->sessionId = $sessionId;
		
		return $this;
	}

	/**
	 * Get sessionId
	 *
	 * @return string
	 */
	public function getSessionId() {
		return $this->sessionId;
	}

	/**
	 * Set pk
	 *
	 * @param string $pk        	
	 *
	 * @return ResultLocation
	 */
	public function setPk($pk) {
		$this->pk = $pk;
		
		return $this;
	}

	/**
	 * Get pk
	 *
	 * @return string
	 */
	public function getPk() {
		return $this->pk;
	}

	/**
	 * Set format
	 *
	 * @param string $format        	
	 *
	 * @return ResultLocation
	 */
	public function setFormat($format) {
		$this->format = $format;
		
		return $this;
	}

	/**
	 * Get format
	 *
	 * @return string
	 */
	public function getFormat() {
		return $this->format;
	}

	/**
	 * Set theGeom
	 *
	 * @param string $theGeom        	
	 *
	 * @return ResultLocation
	 */
	public function setTheGeom($theGeom) {
		$this->theGeom = $theGeom;
		
		return $this;
	}

	/**
	 * Get theGeom
	 *
	 * @return string
	 */
	public function getTheGeom() {
		return $this->theGeom;
	}

	/**
	 * Set creationdt
	 *
	 * @param \Date $creationdt        	
	 *
	 * @return ResultLocation
	 */
	public function setCreationdt($creationdt) {
		$this->creationdt = $creationdt;
		
		return $this;
	}

	/**
	 * Get creationdt
	 *
	 * @return \Date
	 */
	public function getCreationdt() {
		return $this->creationdt;
	}
}

