<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * TableField
 *
 * @ORM\Table(name="metadata_work.field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\ConfigurateurBundle\Entity\FieldRepository")
 */
class Field {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Data", inversedBy="fields")
	 *      @ORM\JoinColumn(name="data", referencedColumnName="data")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $data;

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Format")
	 *      @ORM\JoinColumn(name="format", referencedColumnName="format")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $format;

	/**
	 * The type of the field (FILE, FORM or TABLE).
	 *
	 * @var string @ORM\Column(name="type", type="string", length=36, nullable=true)
	 */
	private $type;

	/**
	 * Set type
	 *
	 * @param string $type
	 * @return Field
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

	/**
	 * Set data
	 *
	 * @param string $data
	 * @return Field
	 */
	public function setData($data) {
		$this->data = $data;

		return $this;
	}

	/**
	 * Get data
	 *
	 * @return string
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set format
	 *
	 * @string $tableFormat
	 *
	 * @return Field
	 */
	public function setFormat($format) {
		$this->format = $format;

		return $this;
	}

	/**
	 * Get format
	 *
	 * @return \Ign\Bundle\ConfigurateurBundle\Entity\Format
	 */
	public function getFormat() {
		return $this->format;
	}
}
