<?php
namespace Ign\Bundle\OGAMBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * PredefinedRequest
 *
 * @ORM\Table(name="website.predefined_request")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Website\PredefinedRequestRepository")
 */
class PredefinedRequest {

	/**
	 *
	 * @var integer
	 * @ORM\Id
	 * @ORM\Column(name="request_id", type="integer", unique=true)
	 * @ORM\GeneratedValue
	 */
	private $requestId;

	/**
	 *
	 * @var string
	 * @ORM\Column(name="schema_code", type="string", length=36)
	 */
	private $schemaCode;

	/**
	 *
	 * @var Dataset
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset")
	 * @ORM\JoinColumns({@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id")})
	 */
	private $datasetId;

	/**
	 *
	 * @var string
	 * @ORM\Column(name="definition", type="string", length=500, nullable=true)
	 */
	private $definition;

	/**
	 *
	 * @var string
	 * @ORM\Column(name="label", type="string", length=50, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var \DateTime
	 * @ORM\Column(name="date", type="date")
	 */
	private $date;

	/**
	 *
	 * @var boolean
	 * @ORM\Column(name="is_public", type="boolean", nullable=false)
	 */
	private $isPublic;

	/**
	 *
	 * @var User
	 *      @ORM\ManyToOne(targetEntity="User")
	 *      @ORM\JoinColumns({@ORM\JoinColumn(name="user_login", referencedColumnName="user_login")})
	 */
	protected $userLogin;

	/**
	 * @ORM\OneToMany(targetEntity="PredefinedRequestGroupAsso", mappedBy="requestId")
	 */
	private $groups;

	/**
	 * The columns of the request
	 *
	 * @var PredefinedRequestColumn[]
	 */
	private $columns;

	/**
	 * The criteria of the request
	 *
	 * @var PredefinedRequestCriterion[]
	 */
	private $criteria;

	public function __construct() {
		$this->groups = new \Doctrine\Common\Collections\ArrayCollection();
	}

	/**
	 * Set request id
	 *
	 * @param integer $requestId
	 *
	 * @return PredefinedRequest
	 */
	public function setRequestId($requestId) {
		$this->requestId = $requestId;

		return $this;
	}

	/**
	 * Get request id
	 *
	 * @return integer
	 */
	public function getRequestId() {
		return $this->requestId;
	}

	/**
	 * Set schemaCode
	 *
	 * @param string $schemaCode
	 *
	 * @return PredefinedRequest
	 */
	public function setSchemaCode($schemaCode) {
		$this->schemaCode = $schemaCode;

		return $this;
	}

	/**
	 * Get schemaCode
	 *
	 * @return string
	 */
	public function getSchemaCode() {
		return $this->schemaCode;
	}

	/**
	 * Set datasetId
	 *
	 * @param string $datasetId
	 *
	 * @return PredefinedRequest
	 */
	public function setDatasetId($datasetId) {
		$this->datasetId = $datasetId;

		return $this;
	}

	/**
	 * Get datasetId
	 *
	 * @return string
	 */
	public function getDatasetId() {
		return $this->datasetId;
	}

	/**
	 * Set definition
	 *
	 * @param string $definition
	 *
	 * @return PredefinedRequest
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
	 * Set label
	 *
	 * @param string $label
	 *
	 * @return PredefinedRequest
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
	 * Set date
	 *
	 * @param \DateTime $date
	 *
	 * @return PredefinedRequest
	 */
	public function setDate($date) {
		$this->date = $date;

		return $this;
	}

	/**
	 * Get date
	 *
	 * @return \DateTime
	 */
	public function getDate() {
		return $this->date;
	}

	/**
	 * Set isPublic
	 *
	 * @param boolean $isPublic
	 *
	 * @return PredefinedRequest
	 */
	public function setIsPublic($isPublic) {
		$this->isPublic = $isPublic;

		return $this;
	}

	/**
	 * Get isPublic
	 *
	 * @return boolean
	 */
	public function getIsPublic() {
		return $this->isPublic;
	}

	/**
	 * Set userLogin
	 *
	 * @param User $userLogin
	 *
	 * @return PredefinedRequest
	 */
	public function setUserLogin($userLogin) {
		$this->userLogin = $userLogin;

		return $this;
	}

	/**
	 * Get userLogin
	 *
	 * @return User
	 */
	public function getUserLogin() {
		return $this->userLogin;
	}

	/**
	 * Get the groups
	 *
	 * @return PredefinedRequestGroup[]
	 */
	public function getGroups() {
		return $this->groups;
	}

	/**
	 * Set the groups
	 *
	 * @param PredefinedRequestGroup[] $groups
	 */
	public function setGroups($groups) {
		$this->groups = $groups;
		return $this;
	}

	/**
	 * Return the columns
	 *
	 * @return PredefinedRequestColumn[]
	 */
	public function getColumns() {
		return $this->columns;
	}

	/**
	 * Set the columns
	 *
	 * @param PredefinedRequestColumn[] $columns
	 */
	public function setColumns($columns) {
		$this->columns = $columns;
		return $this;
	}

	/**
	 * Get the criteria
	 *
	 * @return PredefinedRequestCriterion[]
	 */
	public function getCriteria() {
		return $this->criteria;
	}

	/**
	 * Set the criteria
	 *
	 * @param PredefinedRequestCriterion[] $criteria
	 */
	public function setCriteria($criteria) {
		$this->criteria = $criteria;
		return $this;
	}

	/**
	 * Check if a criterion is present
	 *
	 * @param string $criterionId
	 * @return boolean
	 */
	public function hasCriterion($criterionId) {
		if ($this->getCriterion($criterionId) !== null) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Check if a column is present
	 *
	 * @param string $columnId
	 * @return boolean
	 */
	public function hasColumn($columnId) {
		if ($this->getColumn($columnId) !== null) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Return a column
	 *
	 * @param string $columnId
	 * @return PredefinedRequestColumn|NULL
	 */
	public function getColumn($columnId) {
		for ($i = 0; $i < count($this->columns); $i ++) {
			if ($this->columns[$i]->getId() === $columnId) {
				return $this->columns[$i];
			}
		}
		return null;
	}

	/**
	 * Return a criterion
	 *
	 * @param string $criterionId
	 * @return PredefinedRequestCriterion|NULL
	 */
	public function getCriterion($criterionId) {
		for ($i = 0; $i < count($this->criteria); $i ++) {
			if ($this->criteria[$i]->getId() === $criterionId) {
				return $this->criteria[$i];
			}
		}
		return null;
	}
}
