<?php
namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Entity\Website\Provider;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;


/**
 * Submission.
 *
 * @ORM\Table(name="raw_data.submission")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\RawData\SubmissionRepository")
 * @ORM\HasLifecycleCallbacks()
 */
class Submission {

	const STEP_INIT = 'INIT';

	const STEP_INSERTED = 'INSERT';

	const STEP_CHECKED = 'CHECK';

	const STEP_GEO_ASSO = 'GEO-ASSOCIATION';

	const STEP_VALIDATED = 'VALIDATE';

	const STEP_CANCELLED = 'CANCEL';

	const STATUS_OK = 'OK';

	const STATUS_RUNNING = 'RUNNING';

	const STATUS_WARNING = 'WARNING';

	const STATUS_ERROR = 'ERROR';

	const STATUS_CRASH = 'CRASH';

	/**
	 * The submission identifier.
	 *
	 * @var int 
         * 
         * @ORM\Column(name="submission_id", type="integer")
	 * @ORM\Id
	 * @ORM\GeneratedValue(strategy="AUTO")
	 * @ORM\SequenceGenerator(sequenceName="submission_id_seq")
	 */
	private $id;

	/**
	 * The submission step (INIT, INSERT, CHECK, VALIDATE, CANCEL).
	 *
	 * @var string
         * @ORM\Column(name="step", type="string", length=36, nullable=true)
	 */
	private $step='INIT';

	/**
	 * The submission status (OK, WARNING, ERROR, CRASH).
	 *
	 * @var string
         * @ORM\Column(name="status", type="string", length=36, nullable=true)
	 */
	private $status;

	/**
	 * The provider (country, organisation).
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\Provider")
	 * @ORM\JoinColumn(name="provider_id", referencedColumnName="id")
	 */
	private $provider;

	/**
	 * The dataset
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Metadata\Dataset")
	 * @ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id")
	 */
	private $dataset;

	/**
	 * The login of the user who has done the submission.
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\User")
	 * @ORM\JoinColumn(name="user_login", referencedColumnName="user_login")
	 */
	private $user;

	/**
	 *
	 * @var \DateTime
         * @ORM\Column(name="_creationdt", type="datetime", nullable=true)
	 */
	private $creationDate;

	/**
	 *
	 * @var \DateTime
         * @ORM\Column(name="_validationdt", type="datetime", nullable=true)
	 */
	private $validationDate;

	/**
	 * The files of the submission.
	 * @ORM\OneToMany(targetEntity="SubmissionFile", mappedBy="submission")
	 */
	private $files;

	/**
	 * The jdd of the submission (optionnal)
	 * @ORM\ManyToOne(targetEntity="Jdd", inversedBy="submissions")
	 * @ORM\JoinColumn(name="jdd_id", referencedColumnName="id", nullable=true)
	 */
	private $jdd;

	/**
	 * Constructor.
	 */
	public function __construct() {
		$this->files = new \Doctrine\Common\Collections\ArrayCollection();
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
	 * Set step
	 *
	 * @param string $step
	 *
	 * @return Submission
	 */
	public function setStep($step) {
		$this->step = $step;

		return $this;
	}

	/**
	 * Get step
	 *
	 * @return string
	 */
	public function getStep() {
		return $this->step;
	}

	/**
	 * True if Submission is in an INIT step.
	 *
	 * @return bool
	 */
	public function isInit() {
		return $this->step == self::STEP_INIT;
	}

	/**
	 * True if Submission is in an active step (ie not CANCEL)
	 *
	 * @return bool
	 */
	public function isActive() {
		return $this->step != self::STEP_CANCELLED;
	}

	/**
	 * True if Submission step is VALIDATED
	 *
	 * @return bool
	 */
	public function isSuccessful() {
		$isSuccessful = (($this->step == self::STEP_CHECKED || $this->step == self::STEP_INSERTED) && $this->status == self::STATUS_OK);
		return $isSuccessful;
	}
	
	/**
	 * True if Submission step is VALIDATED
	 *
	 * @return bool
	 */
	public function isValidated() {
		return $this->step == self::STEP_VALIDATED;
	}

	/**
	 * True if Submission step is CANCEL and status is RUNNING
	 *
	 * @return bool
	 */
	public function isCancelledRunning() {
		return $this->step == self::STEP_CANCELLED && $this->status == self::STATUS_RUNNING;
	}
        

	/**
	 * 
	 *
	 * @return bool
	 */
	public function isInError() {
		return $this->status == self::STATUS_ERROR;
	}

	/**
	 * Set status
	 *
	 * @param string $status
	 *
	 * @return Submission
	 */
	public function setStatus($status) {
		$this->status = $status;

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
	 * @ORM\PrePersist()
	 */
	public function onPersist()
	{
		$now = new \DateTime();
		$this->setCreationDate($now);
		$this->setValidationDate($now);
	}

	/**
	 * Set creationDate
	 *
	 * @param \DateTime $creationDate
	 *
	 * @return Submission
	 */
	public function setCreationDate($creationDate) {
		$this->creationDate = $creationDate;

		return $this;
	}

	/**
	 * Get creationDate
	 *
	 * @return \DateTime
	 */
	public function getCreationDate() {
		return $this->creationDate;
	}

	/**
	 * Set validationDate
	 *
	 * @param \DateTime $validationDate
	 *
	 * @return Submission
	 */
	public function setValidationDate($validationDate) {
		$this->validationDate = $validationDate;

		return $this;
	}

	/**
	 * Get validationDate
	 *
	 * @return \DateTime
	 */
	public function getValidationDate() {
		return $this->validationDate;
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
	 * Set dataset
	 *
	 * @param Dataset $dataset
	 *
	 * @return Submission
	 */
	public function setDataset(Dataset $dataset = null) {
		$this->dataset = $dataset;

		return $this;
	}

	/**
	 * Get dataset, or NULL if dataset has been deleted
	 *
	 * @return Dataset
	 */
	public function getDataset() {
		if ($this->dataset != null) {
			try {
				$label = $this->dataset->getLabel();
			} catch (\Doctrine\ORM\EntityNotFoundException $e) {
				return null;
			}
		}
		return $this->dataset;
	}

	/**
	 * Add file
	 *
	 * @param SubmissionFile $file
	 *
	 * @return Submission
	 */
	public function addFile(SubmissionFile $file) {
		$this->files[] = $file;

		return $this;
	}

	/**
	 * Remove file
	 *
	 * @param SubmissionFile $file
	 */
	public function removeFile(SubmissionFile $file) {
		$this->files->removeElement($file);
	}

	/**
	 * Get files
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getFiles() {
		return $this->files;
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
     * Set jdd
     *
     * @param \Ign\Bundle\GincoBundle\Entity\RawData\Jdd $jdd
     *
     * @return Submission
     */
    public function setJdd(\Ign\Bundle\GincoBundle\Entity\RawData\Jdd $jdd = null)
    {
        $this->jdd = $jdd;

        return $this;
    }

    /**
     * Get jdd
     *
     * @return \Ign\Bundle\GincoBundle\Entity\RawData\Jdd
     */
    public function getJdd()
    {
        return $this->jdd;
    }
	
	
	/**
	 * Check if submission is validable.
	 * @return boolean
	 */
	public function isValidable() {
		
		$insertedOk = $this->getStep() == Submission::STEP_INSERTED && $this->getStatus() == Submission::STATUS_OK;
		$checkedOk = $this->getStep() == Submission::STEP_CHECKED && $this->getStatus() == Submission::STATUS_OK;
		$warning = $this->getStatus() == Submission::STATUS_WARNING;
		
		return ($insertedOk || $checkedOk || $warning) ;
	}
	
	
	public function isInvalidable() {
		
		$validateOk = $this->getStep() == Submission::STEP_VALIDATED && $this->getStatus() == Submission::STATUS_OK;
		$warning = $this->getStatus() == Submission::STATUS_WARNING;
		
		return ($validateOk || $warning) ;
	}
}
