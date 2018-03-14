<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * PredefinedRequestGroup
 *
 * @ORM\Table(name="website.predefined_request_group")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Website\PredefinedRequestGroupRepository")
 */
class PredefinedRequestGroup {

	/**
	 *
	 * @var integer
	 * @ORM\Id
	 * @ORM\Column(name="group_id", type="integer", unique=true)
	 * @ORM\GeneratedValue
	 */
	private $groupId;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=128, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=1024, nullable=true)
	 */
	private $definition;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 * @ORM\OneToMany(targetEntity="PredefinedRequestGroupAsso", mappedBy="groupId")
	 */
	private $requests;

	public function __construct() {
		$this->requests = new \Doctrine\Common\Collections\ArrayCollection();
	}

	/**
	 * Set groupId
	 *
	 * @param integer $groupId
	 *
	 * @return PredefinedRequestGroup
	 */
	public function setGroupId($groupId) {
		$this->groupId = $groupId;

		return $this;
	}

	/**
	 * Get groupId
	 *
	 * @return integer
	 */
	public function getGroupId() {
		return $this->groupId;
	}

	/**
	 * Set label
	 *
	 * @param string $label
	 *
	 * @return PredefinedRequestGroup
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
	 * @return PredefinedRequestGroup
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
	 * Set position
	 *
	 * @param integer $position
	 *
	 * @return PredefinedRequestGroup
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
}

