<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * PredefinedRequestGroupAsso
 *
 * @ORM\Table(name="website.predefined_request_group_asso")
 * @ORM\Entity
 */
class PredefinedRequestGroupAsso {

	/**
	 *
	 * @var integer @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="PredefinedRequestGroup", inversedBy="requests")
	 *      @ORM\JoinColumn(name="group_id", referencedColumnName="group_id")
	 */
	private $groupId;

	/**
	 *
	 * @var integer @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="PredefinedRequest", inversedBy="groups")
	 *      @ORM\JoinColumn(name="request_id", referencedColumnName="request_id")
	 */
	private $requestId;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 * Set groupId
	 *
	 * @param integer $groupId
	 *
	 * @return PredefinedRequestGroupAsso
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
	 * Set requestId
	 *
	 * @param integer $requestId
	 *
	 * @return PredefinedRequestGroupAsso
	 */
	public function setRequestId($requestId) {
		$this->requestId = $requestId;

		return $this;
	}

	/**
	 * Get requestId
	 *
	 * @return integer
	 */
	public function getRequestId() {
		return $this->requestId;
	}

	/**
	 * Set position
	 *
	 * @param integer $position
	 *
	 * @return PredefinedRequestGroupAsso
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

