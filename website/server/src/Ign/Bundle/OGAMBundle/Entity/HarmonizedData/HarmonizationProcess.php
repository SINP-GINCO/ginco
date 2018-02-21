<?php
namespace Ign\Bundle\OGAMBundle\Entity\HarmonizedData;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\Collection;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;

/**
 * HarmonizationProcess
 *
 * @ORM\Table(name="harmonized_data.harmonization_process")
 * @ORM\Entity
 */
class HarmonizationProcess {

	/**
	 *
	 * @var int @ORM\Id
	 *      @ORM\Column(name="harmonization_process_id", type="integer")
	 *      @ORM\GeneratedValue(strategy="AUTO")
	 */
	private $harmonizationId;

	/**
	 *
	 * @var string @ORM\Column(name="provider_id", type="string", length=36)
	 */
	private $providerId;

	/**
	 * The dataset
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset")
	 * @ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id")
	 */
	private $dataset;

	/**
	 *
	 * @var string @ORM\Column(name="harmonization_status", type="string", length=36, nullable=true)
	 */
	private $status;

	/**
	 *
	 * @var \DateTime @ORM\Column(name="_creationdt", type="datetime", nullable=true)
	 */
	private $date;

	/**
	 *
	 * @var Collection @ORM\ManyToMany(targetEntity="Ign\Bundle\OGAMBundle\Entity\RawData\Submission")
	 *      @ORM\JoinTable(name="harmonized_data.harmonization_process_submissions",
	 *      joinColumns={@ORM\JoinColumn(name="harmonization_process_id", referencedColumnName="harmonization_process_id")},
	 *      inverseJoinColumns={@ORM\JoinColumn(name="raw_data_submission_id", referencedColumnName="submission_id")})
	 */
	private $submissions;

	/**
	 * Set harmonizationId
	 *
	 * @param integer $harmonizationId        	
	 *
	 * @return HarmonizationProcess
	 */
	public function setHarmonizationId($harmonizationId) {
		$this->harmonizationId = $harmonizationId;
		
		return $this;
	}

	/**
	 * Get harmonizationId
	 *
	 * @return int
	 */
	public function getHarmonizationId() {
		return $this->harmonizationId;
	}

	/**
	 * Set providerId
	 *
	 * @param string $providerId        	
	 *
	 * @return HarmonizationProcess
	 */
	public function setProviderId($providerId) {
		$this->providerId = $providerId;
		
		return $this;
	}

	/**
	 * Get providerId
	 *
	 * @return string
	 */
	public function getProviderId() {
		return $this->providerId;
	}

	/**
	 * Set status
	 *
	 * @param string $status        	
	 *
	 * @return HarmonizationProcess
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
	 * Set date
	 *
	 * @param \DateTime $date        	
	 *
	 * @return HarmonizationProcess
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
	 * Constructor
	 */
	public function __construct() {
		$this->submissions = new \Doctrine\Common\Collections\ArrayCollection();
	}

	/**
	 * Add submission
	 *
	 * @param Submission $submission
	 *
	 * @return HarmonizationProcess
	 */
	public function addSubmission(Submission $submission) {
		$this->submissions[] = $submission;
		
		return $this;
	}

	/**
	 * Remove submission
	 *
	 * @param Submission $submission
	 */
	public function removeSubmission(Submission $submission) {
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
	 * Set dataset
	 *
	 * @param Dataset $dataset
	 *
	 * @return HarmonizationProcess
	 */
	public function setDataset(Dataset $dataset = null) {
		$this->dataset = $dataset;
		
		return $this;
	}

	public function getSubmissionStatus() {
		$submissionValid = function ($key, $object) {
			return $object->getStep() === Submission::STEP_VALIDATED;
		};
		
		if ($this->getSubmissions()->forAll($submissionValid)) {
			return 'VALIDATE';
		}
		return 'NOT_VALIDATE';
	}

	/**
	 * Get dataset
	 *
	 * @return Dataset
	 */
	public function getDataset() {
		return $this->dataset;
	}
}
