<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Translation
 *
 * @ORM\Table(name="metadata.translation")
 * @ORM\Entity
 */
class Translation {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="table_format", type="string", length=36)
	 */
	private $tableFormat;

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="row_pk", type="string", length=255)
	 */
	private $rowPk;

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="lang", type="string", length=36)
	 */
	private $lang;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 */
	private $definition;

	/**
	 * Set tableFormat
	 *
	 * @param string $tableFormat        	
	 *
	 * @return Translation
	 */
	public function setTableFormat($tableFormat) {
		$this->tableFormat = $tableFormat;
		
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
	 * Set rowPk
	 *
	 * @param string $rowPk        	
	 *
	 * @return Translation
	 */
	public function setRowPk($rowPk) {
		$this->rowPk = $rowPk;
		
		return $this;
	}

	/**
	 * Get rowPk
	 *
	 * @return string
	 */
	public function getRowPk() {
		return $this->rowPk;
	}

	/**
	 * Set lang
	 *
	 * @param string $lang        	
	 *
	 * @return Translation
	 */
	public function setLang($lang) {
		$this->lang = $lang;
		
		return $this;
	}

	/**
	 * Get lang
	 *
	 * @return string
	 */
	public function getLang() {
		return $this->lang;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return Translation
	 */
	public function setLabel($label) {
		$this->label = $label;
		
		return $this;
	}

	/**
	 * Get label
	 *
	 * @return string
	 */
	public function getLabel() {
		return $this->label;
	}

	/**
	 * Set definition
	 *
	 * @param string $definition        	
	 *
	 * @return Translation
	 */
	public function setDefinition($definition) {
		$this->definition = $definition;
		
		return $this;
	}

	/**
	 * Get definition
	 *
	 * @return string
	 */
	public function getDefinition() {
		return $this->definition;
	}
}

