<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * Result
 *
 * @ORM\Table(name="mapping.results")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Mapping\ResultRepository")
 */
class Result {

	/**
	 * The foreign key id of the request.
	 *
	 * @var int @ORM\Column(name="id_request", type="integer", nullable=false)
	 *      @ORM\Id
	 */
	private $idRequest;

	/**
	 * The foreign key id of the observation (part of the primary key for an observation).
	 *
	 * @var int @ORM\Column(name="id_observation", type="string", nullable=false)
	 *      @ORM\Id
	 */
	private $idObservation;

	/**
	 * The foreign key id of the provider (part of the primary key for an observation).
	 *
	 * @var int @ORM\Column(name="id_provider", type="string", nullable=false)
	 *      @ORM\Id
	 */
	private $idProvider;

	/**
	 *
	 * @var string @ORM\Column(name="table_format", type="string", nullable=false)
	 */
	private $tableFormat;

	/**
	 * The value of hiding (filtering).
	 *
	 * @var string @ORM\Column(name="hiding_level", type="integer")
	 */
	private $hidingLevel;

	/**
	 * Get idRequest
	 *
	 * @return int
	 */
	public function getIdRequest() {
		return $this->idRequest;
	}

	/**
	 * Set idRequest
	 *
	 * @param string $idRequest
	 *
	 * @return Result
	 */
	public function setIdRequest($idRequest) {
		$this->idRequest = $idRequest;

		return $this;
	}

	/**
	 * Get idObservation
	 *
	 * @return string
	 */
	public function getIdObservation() {
		return $this->idObservation;
	}

	/**
	 * Set idObservation
	 *
	 * @param string $idObservation
	 *
	 * @return Result
	 */
	public function setIdObservation($idObservation) {
		$this->idObservation = $idObservation;

		return $this;
	}

	/**
	 * Get idProvider
	 *
	 * @return string
	 */
	public function getIdProvider() {
		return $this->idProvider;
	}

	/**
	 * Set idProvider
	 *
	 * @param
	 *        	string idProvider
	 *
	 * @return Result
	 */
	public function setIdProvider($idProvider) {
		$this->idProvider = $idProvider;

		return $this;
	}

	/**
	 * Get tableFormat
	 *
	 * @return string
	 */
	public function getTableFormat() {
		return $this->tableFormat;
	}

	/**
	 * Set tableFormat
	 *
	 * @param string $tableFormat
	 *
	 * @return Result
	 */
	public function setTableFormat($tableFormat) {
		$this->tableFormat = $tableFormat;

		return $this;
	}

	/**
	 * Get hiding_level
	 *
	 * @return string
	 */
	public function getHidingLevel() {
		return $this->hidingLevel;
	}

	/**
	 * Set hiding_level
	 *
	 * @param string $hidingLevel
	 *
	 * @return Result
	 */
	public function setHidingLevel($hidingLevel) {
		$this->hidingLevel = $hidingLevel;

		return $this;
	}
}

