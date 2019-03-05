<?php
namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Entity\Website\Provider;

/**
 * Jdd (ie dataset = set of submissions of datas)
 *
 * @ORM\Table(name="raw_data.jdd")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\RawData\JddRepository")
 * @ORM\HasLifecycleCallbacks()
 */
class Jdd {

	const STATUS_ACTIVE = 'active';

	const STATUS_DELETED = 'deleted';
	
	const STATUS_VALIDATED = "validated" ;

	/**
	 * The technical identifier.
	 *
	 * @var int @ORM\Column(name="id", type="integer")
	 *      @ORM\Id
	 *      @ORM\GeneratedValue(strategy="AUTO")
	 */
	private $id;

	/**
	 * The jdd status (active or deleted) - kind of soft-delete.
	 *
	 * @var string @ORM\Column(name="status", type="string", length=10, nullable=true)
	 */
	private $status = 'active';

	/**
	 * The provider (country, organisation).
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\Provider")
	 * @ORM\JoinColumn(name="provider_id", referencedColumnName="id")
	 */
	private $provider;

	/**
	 * The login of the user who has created the jdd.
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\User")
	 * @ORM\JoinColumn(name="user_login", referencedColumnName="user_login")
	 */
	private $user;

	/**
	 * The data model associated with the jdd
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Metadata\Model")
	 * @ORM\JoinColumn(name="model_id", referencedColumnName="id")
	 */
	private $model;

	/**
	 * The submission(s) in this jdd
	 *
	 * @ORM\OneToMany(targetEntity="Submission", mappedBy="jdd")
	 * @ORM\OrderBy({"id" = "ASC"})
	 */
	private $submissions;

	/**
	 * The key/value Fields attached to the jdd (metadata fields)
	 *
	 * @ORM\OneToMany(targetEntity="JddField", mappedBy="jdd", cascade={"persist", "remove"}, orphanRemoval=true)
	 */
	private $fields;

	/**
	 *
	 * @var \DateTime @ORM\Column(name="created_at", type="datetime", nullable=true)
	 */
	private $createdAt;

	/**
	 * The most recent datetime where the raw datas in the jdd was updated
	 * submission added, deleted.
	 * Data edited.
	 *
	 * @var \DateTime @ORM\Column(name="data_updated_at", type="datetime", nullable=true)
	 */
	private $dataUpdatedAt;
	
	/**
	 *
	 * @var ArrayCollection
	 * 
	 * @ORM\OneToMany(targetEntity="DEE", mappedBy="jdd")
	 */
	private $dees ;
	

	/**
	 * Constructor.
	 */
	public function __construct() {
		$this->submissions = new ArrayCollection();
		$this->fields = new ArrayCollection();
		$this->dees = new ArrayCollection() ;
	}

	/**
	 * Get id
	 *
	 * @return int
	 */
	public function getId() {
		return $this->id;
	}

	/**
	 * Set status
	 *
	 * @param string $status
	 *
	 * @return Jdd
	 */
	public function setStatus($status) {
		$this->status = $status;

		return $this;
	}

	/**
	 * "Delete", is set status 'deleted'
	 *
	 * @return Jdd
	 */
	public function Delete() {
		$this->setStatus(self::STATUS_DELETED);
		$this->setModel(null);

		return $this;
	}

	/**
	 * Get status
	 *
	 * @return string
	 */
	public function getStatus() {
		return $this->status;
	}

	/**
	 * True if jdd is not in status 'DELETED'
	 *
	 * @return bool
	 */
	public function isActive() {
		return $this->status != self::STATUS_DELETED;
	}

	/**
	 * True if the jdd is not already deleted, and has no active submissions
	 * todo: test if the jdd has active dee
	 */
	public function isDeletable() {
		if (!$this->isActive())
			return false;

		if (!$this->getActiveSubmissions()->isEmpty())
			return false;

			// todo: test if the jdd has active dee

		return true;
	}

	/**
	 * Set provider
	 *
	 * @param Provider $provider
	 *
	 * @return Submission
	 */
	public function setProvider(Provider $provider = null) {
		$this->provider = $provider;

		return $this;
	}

	/**
	 * Get provider
	 *
	 * @return Provider
	 */
	public function getProvider() {
		return $this->provider;
	}

	/**
	 * Set user
	 *
	 * @param User $user
	 *
	 * @return Submission
	 */
	public function setUser(User $user = null) {
		$this->user = $user;

		return $this;
	}

	/**
	 * Get user
	 *
	 * @return User
	 */
	public function getUser() {
		return $this->user;
	}

	/**
	 * Set model
	 *
	 * @param \Ign\Bundle\GincoBundle\Entity\Metadata\Model $model
	 *
	 * @return Jdd
	 */
	public function setModel(\Ign\Bundle\GincoBundle\Entity\Metadata\Model $model = null) {
		$this->model = $model;

		return $this;
	}

	/**
	 * Get model
	 *
	 * @return \Ign\Bundle\GincoBundle\Entity\Metadata\Model
	 */
	public function getModel() {
		return $this->model;
	}

	/**
	 * Add submission
	 *
	 * @param \Ign\Bundle\GincoBundle\Entity\RawData\Submission $submission
	 *
	 * @return Jdd
	 */
	public function addSubmission(\Ign\Bundle\GincoBundle\Entity\RawData\Submission $submission) {
		$this->submissions[] = $submission;

		return $this;
	}

	/**
	 * Remove submission
	 *
	 * @param \Ign\Bundle\GincoBundle\Entity\RawData\Submission $submission
	 */
	public function removeSubmission(\Ign\Bundle\GincoBundle\Entity\RawData\Submission $submission) {
		$this->submissions->removeElement($submission);
	}

	/**
	 * Get submissions
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getSubmissions() {
		return $this->submissions;
	}

	/**
	 * Get active submissions
	 * ie Submissions not in 'CANCEL' step
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getActiveSubmissions() {
		$isActive = function (Submission $submission) {
			return $submission->isActive() && !$submission->isInit() || $submission->isCancelledRunning();
		};
		return $this->getSubmissions()->filter($isActive);
	}
	
	/**
	 * Test if this JDD has active submissions.
	 * @return bool
	 */
	public function hasActiveSubmissions() {
		return !$this->getActiveSubmissions()->isEmpty() ;
	}
	
	/**
	 * Get running submissions
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getRunningSubmissions() {
		$isRunning = function (Submission $submission) {
			return $submission->isRunning() ;
		};
		return $this->getSubmissions()->filter($isRunning) ;
	}
	
	/**
	 * True if this JDD has running submissions.
	 * @return bool
	 */
	public function hasRunningSubmissions() {
		return !$this->getRunningSubmissions()->isEmpty() ;
	}
	
	/**
	 * Get successful submissions
	 * ie Submissions in 'INSERT' or 'CHECK' step and 'OK' status
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getSuccessfulSubmissions() {
		$isSuccessful = function (Submission $submission) {
			return $submission->isSuccessful();
		};
		return $this->getSubmissions()->filter($isSuccessful);
	}

	/**
	 * Get validated submissions
	 * ie Submissions in VALIDATED step
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getValidatedSubmissions() {
		$isValidated = function (Submission $submission) {
			return $submission->isValidated();
		};
		return $this->getSubmissions()->filter($isValidated);
	}
	
	/**
	 * Get the last validated submission.
	 * @return Submission
	 */
	public function getLastValidatedSubmission() {
		$validatedSubmissions = $this->getValidatedSubmissions() ;
		$iterator = $validatedSubmissions->getIterator() ;
		$iterator->uasort(function ($a, $b) {
			return $a->getValidationDate() < $b->getValidationDate() ? -1 : 1 ;
		});
		$sorted = new ArrayCollection(iterator_to_array($iterator)) ;
		return $sorted->last() ;
	}

	/**
	 * @ORM\PrePersist()
	 */
	public function setCreatedAtNow() {
		$this->createdAt = new \DateTime();
	}

	/**
	 * Get createdAt
	 *
	 * @return \DateTime
	 */
	public function getCreatedAt() {
		return $this->createdAt;
	}

	/**
	 * Set dataUpdatedAt
	 *
	 * @param \DateTime $dataUpdatedAt
	 *
	 * @return Jdd
	 */
	public function setDataUpdatedAt($dataUpdatedAt) {
		$this->dataUpdatedAt = $dataUpdatedAt;

		return $this;
	}

	/**
	 * Get dataUpdatedAt
	 *
	 * @return \DateTime
	 */
	public function getDataUpdatedAt() {
		return $this->dataUpdatedAt;
	}
	
	/**
	 * Get DEEs associated to this JDD
	 * @return DEE[]
	 */
	public function getDees() {
		return $this->dees ;
	}
	
	
	/*
	 * ====================================================================
	 * /* Functions for manipulating JddFields,
	 * /* ie a key/value store attached to the jdd
	 * /* ====================================================================
	 *
	 * /**
	 * Get fields
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getFields() {
		return $this->fields;
	}

	/**
	 * Get all the fields as a key/value array
	 *
	 * @return array
	 */
	public function getFieldsAsKeyValueArray() {
		$getKey = function (JddField $jddField) {
			return $jddField->getKey();
		};
		$keys = $this->getFields()
			->map($getKey)
			->toArray();

		$getValue = function (JddField $jddField) {
			return $jddField->getValue();
		};
		$values = $this->getFields()
			->map($getValue)
			->toArray();

		return array_combine($keys, $values);
	}

	/**
	 * Get all fields keys
	 *
	 * @return array
	 */
	public function getFieldsKeys() {
		return array_keys($this->getFieldsAsKeyValueArray());
	}

	/**
	 * Test if the jdd has a field named 'key'
	 *
	 * @param
	 *        	$key
	 * @return bool
	 */
	public function hasField($key) {
		return array_key_exists($key, $this->getFieldsAsKeyValueArray());
	}

	/**
	 * Get the value of the field named 'key'
	 *
	 * @param
	 *        	$key
	 * @param null $default
	 * @return mixed|null
	 */
	public function getField($key, $default = null) {
		$fields = $this->getFieldsAsKeyValueArray();
		return (array_key_exists($key, $fields)) ? $fields[$key] : $default;
	}

	/**
	 * Set the value of an existing field, or creates a new field
	 *
	 * @param
	 *        	$key
	 * @param
	 *        	$value
	 * @param null $type
	 * @return $this
	 */
	public function setField($key, $value, $type = null) {
		// If key already exists, change value in the JddField object
		if ($this->hasField($key)) {
			$jddFields = $this->getFields()->toArray();
			foreach ($jddFields as $field) {
				if ($field->getKey() == $key) {
					$field->setValue($value, $type);
					break;
				}
			}
		} 		// If key doesn't exists, create a new JddField object and attach it to the jdd
		else {
			$field = new JddField($key, $value, $type);
			$field->setJdd($this);
			$this->fields->add($field);
		}
		return $this;
	}

	/**
	 * Remove a field by its key
	 *
	 * @param
	 *        	$key
	 */
	public function removeField($key) {
		if ($this->hasField($key)) {
			$jddFields = $this->getFields()->toArray();
			foreach ($jddFields as $field) {
				if ($field->getKey() == $key) {
					$this->fields->removeElement($field);
					break;
				}
			}
		}
	}
	
	
	
}
