<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Metadata.dynamode
 *
 * @ORM\Table(name="metadata_work.dynamode")
 * @ORM\Entity
 */
class Dynamode {

	/**
	 *
	 * @var string @ORM\Column(name="unit", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 *      @ORM\GeneratedValue(strategy="SEQUENCE")
	 *      @ORM\SequenceGenerator(sequenceName="metadata.dynamode_unit_seq", allocationSize=1, initialValue=1)
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
