<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Data
 *
 * @ORM\Table(name="metadata.model_tables")
 * @ORM\Entity
 */
class ModelTables {


	/**
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="TableFormat", inversedBy="format")
	 * @ORM\JoinColumn(name="table_id", referencedColumnName="format")
	 */
	private $table;

	/**
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Model", inversedBy="id")
	 * @ORM\JoinColumn(name="model_id", referencedColumnName="id")
	 */
	private $model;


	/**
	 * Get table
	 *
	 * @return TableFormat
	 */
	public function getTable() {
		return $this->table;
	}

	/**
	 * Set table
	 *
	 * @param TableFormat $table
	 * @return ModelTables
	 */
	public function setTable($table) {
		$this->table = $table;

		return $this;
	}

	/**
	 * Get model
	 *
	 * @return Model
	 */
	public function getModel() {
		return $this->model;
	}

	/**
	 * Set model
	 *
	 * @param Model $model
	 * @return ModelTables
	 */
	public function setModel($model) {
		$this->model = $model;

		return $this;
	}
}
