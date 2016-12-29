<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Doctrine\ORM\Mapping as ORM;

/**
 * Format
 *
 * @ORM\Table(name="metadata_work.format")
 * @ORM\Entity
 */
class Format {

	/**
	 *
	 * @var string @ORM\Column(name="format", type="string", length=36,unique=true ,nullable=false)
	 *      @ORM\Id
	 */
	private $format;

	/**
	 *
	 * @var string @ORM\Column(name="type",type="string", length=36, nullable=false)
	 */
	private $type;

	/**
	 * Set format
	 *
	 * @param string $format
	 * @return Format
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
	 * Set type
	 *
	 * @param string $type
	 * @return Format
	 */
	public function setType($type) {
		$this->type = $type;

		return $this;
	}

	/**
	 * Get type
	 *
	 * @return string
	 */
	public function getType() {
		return $this->type;
	}
}
