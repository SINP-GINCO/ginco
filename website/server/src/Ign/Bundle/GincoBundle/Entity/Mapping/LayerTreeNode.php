<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * LayerTreeNode
 *
 * @ORM\Table(name="mapping.layer_tree_node")
 * @ORM\Entity
 */
class LayerTreeNode implements \JsonSerializable {

	/**
	 *
	 * @var int @ORM\Id
	 *      @ORM\Column(name="node_id", type="integer", unique=true)
	 */
	private $nodeId;

	/**
	 *
	 * @var string @ORM\Column(name="parent_node_id", type="string", length=50)
	 */
	private $parentNodeId;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=30)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=100)
	 */
	private $definition;

	/**
	 *
	 * @var bool @ORM\Column(name="is_layer", type="boolean")
	 */
	private $isLayer;

	/**
	 *
	 * @var bool @ORM\Column(name="is_checked", type="boolean")
	 */
	private $isChecked;

	/**
	 *
	 * @var bool @ORM\Column(name="is_hidden", type="boolean")
	 */
	private $isHidden;

	/**
	 *
	 * @var bool @ORM\Column(name="is_disabled", type="boolean")
	 */
	private $isDisabled;

	/**
	 *
	 * @var bool @ORM\Column(name="is_expanded", type="boolean")
	 */
	private $isExpanded;

	/**
	 *
	 * @var layer @ORM\ManyToOne(targetEntity="Layer")
	 *      @ORM\JoinColumn(name="layer_name", referencedColumnName="name")
	 */
	private $layer;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer")
	 */
	private $position;

	/**
	 *
	 * @var string @ORM\Column(name="checked_group", type="string", length=36, nullable=true)
	 */
	private $checkedGroup;

	/**
	 * Get id
	 *
	 * @return int
	 */
	public function getId() {
		return $this->nodeId;
	}

	/**
	 * Set nodeId
	 *
	 * @param integer $nodeId        	
	 *
	 * @return LayerTreeNode
	 */
	public function setNodeId($nodeId) {
		$this->nodeId = $nodeId;
		
		return $this;
	}

	/**
	 * Get nodeId
	 *
	 * @return int
	 */
	public function getNodeId() {
		return $this->nodeId;
	}

	/**
	 * Set parentNodeId
	 *
	 * @param string $parentNodeId        	
	 *
	 * @return LayerTreeNode
	 */
	public function setParentNodeId($parentNodeId) {
		$this->parentNodeId = $parentNodeId;
		
		return $this;
	}

	/**
	 * Get parentNodeId
	 *
	 * @return string
	 */
	public function getParentNodeId() {
		return $this->parentNodeId;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return LayerTreeNode
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
	 * @return LayerTreeNode
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

	/**
	 * Set isLayer
	 *
	 * @param boolean $isLayer        	
	 *
	 * @return LayerTreeNode
	 */
	public function setIsLayer($isLayer) {
		$this->isLayer = $isLayer;
		
		return $this;
	}

	/**
	 * Get isLayer
	 *
	 * @return bool
	 */
	public function getIsLayer() {
		return $this->isLayer;
	}

	/**
	 * Set isChecked
	 *
	 * @param boolean $isChecked        	
	 *
	 * @return LayerTreeNode
	 */
	public function setIsChecked($isChecked) {
		$this->isChecked = $isChecked;
		
		return $this;
	}

	/**
	 * Get isChecked
	 *
	 * @return bool
	 */
	public function getIsChecked() {
		return $this->isChecked;
	}

	/**
	 * Set isHidden
	 *
	 * @param boolean $isHidden        	
	 *
	 * @return LayerTreeNode
	 */
	public function setIsHidden($isHidden) {
		$this->isHidden = $isHidden;
		
		return $this;
	}

	/**
	 * Get isHidden
	 *
	 * @return bool
	 */
	public function getIsHidden() {
		return $this->isHidden;
	}

	/**
	 * Set isDisabled
	 *
	 * @param boolean $isDisabled        	
	 *
	 * @return LayerTreeNode
	 */
	public function setIsDisabled($isDisabled) {
		$this->isDisabled = $isDisabled;
		
		return $this;
	}

	/**
	 * Get isDisabled
	 *
	 * @return bool
	 */
	public function getIsDisabled() {
		return $this->isDisabled;
	}

	/**
	 * Set isExpanded
	 *
	 * @param boolean $isExpanded        	
	 *
	 * @return LayerTreeNode
	 */
	public function setIsExpanded($isExpanded) {
		$this->isExpanded = $isExpanded;
		
		return $this;
	}

	/**
	 * Get isExpanded
	 *
	 * @return bool
	 */
	public function getIsExpanded() {
		return $this->isExpanded;
	}

	/**
	 * Set layer
	 *
	 * @param string $layer        	
	 *
	 * @return LayerTreeNode
	 */
	public function setLayer($layer) {
		$this->layer = $layer;
		
		return $this;
	}

	/**
	 * Get layer
	 *
	 * @return string
	 */
	public function getLayer() {
		return $this->layer;
	}

	/**
	 * Set position
	 *
	 * @param integer $position        	
	 *
	 * @return LayerTreeNode
	 */
	public function setPosition($position) {
		$this->position = $position;
		
		return $this;
	}

	/**
	 * Get position
	 *
	 * @return int
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 * Set checkedGroup
	 *
	 * @param string $checkedGroup        	
	 *
	 * @return LayerTreeNode
	 */
	public function setCheckedGroup($checkedGroup) {
		$this->checkedGroup = $checkedGroup;
		
		return $this;
	}

	/**
	 * Get checkedGroup
	 *
	 * @return string
	 */
	public function getCheckedGroup() {
		return $this->checkedGroup;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string: JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->getId(),
			'nodeId' => $this->nodeId,
			'parentNodeId' => $this->parentNodeId,
			'label' => $this->label,
			'definition' => $this->definition,
			'isLayer' => $this->isLayer,
			'isChecked' => $this->isChecked,
			'isHidden' => $this->isHidden,
			'isDisabled' => $this->isDisabled,
			'isExpanded' => $this->isExpanded,
			'layerName' => $this->layer->getLayerName(),
			'position' => $this->position,
			'checkedGroup' => $this->checkedGroup
		];
	}
}

