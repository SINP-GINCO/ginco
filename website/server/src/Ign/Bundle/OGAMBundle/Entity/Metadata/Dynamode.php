<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Metadata.dynamode
 *
 * @ORM\Table(name="metadata.dynamode")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Metadata\DynamodeRepository")
 */
class Dynamode {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="unit", type="string", length=36, unique=false)
	 */
	private $unit;

	/**
	 *
	 * @var string @ORM\Column(name="sql", type="text", nullable=false)
	 */
	private $sql;

	/**
	 * Get unit
	 *
	 * @return string
	 */
	public function getUnit() {
		return $this->unit;
	}

	/**
	 * Set sql
	 *
	 * @param string $sql        	
	 * @return Dynamode
	 */
	public function setSql($sql) {
		$this->sql = $sql;
		
		return $this;
	}

	/**
	 * Get sql
	 *
	 * @return string
	 */
	public function getSql() {
		return $this->sql;
	}
}