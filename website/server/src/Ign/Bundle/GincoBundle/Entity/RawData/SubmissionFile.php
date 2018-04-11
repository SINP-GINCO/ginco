<?php
namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;

/**
 * SubmissionFile.
 *
 * @ORM\Table(name="raw_data.submission_file")
 * @ORM\Entity
 */
class SubmissionFile {

	/**
	 * @ORM\ManyToOne(targetEntity="Submission", inversedBy="files")
	 * @ORM\JoinColumn(name="submission_id", referencedColumnName="submission_id")
	 * @ORM\Id
	 */
	private $submission;

	/**
	 * The type of the file (reference a DATASET_FILES.FORMAT).
	 * 
	 * @var string
         * @ORM\ManyToOne(targetEntity="\Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat")
         * @ORM\JoinColumn(name="file_type", referencedColumnName="format")     
         * @ORM\Id
	 */
	private $fileType;

	/**
	 * The name of the file.
	 * 
	 * @var string @ORM\Column(name="file_name", type="string", length=4000)
	 */
	private $fileName;

	/**
	 * The number of lines in the file.
	 * 
	 * @var int @ORM\Column(name="nb_line", type="integer", nullable=true)
	 */
	private $nbLines;

	/**
	 * Set fileType
	 *
	 * @param \Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat $fileType        	
	 *
	 * @return SubmissionFile
	 */
	public function setFileType(\Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat $fileType) {
		$this->fileType = $fileType;
		
		return $this;
	}

	/**
	 * Get fileType
	 *
	 * @return string
	 */
	public function getFileType() {
		return $this->fileType;
	}

	/**
	 * Set fileName
	 *
	 * @param string $fileName        	
	 *
	 * @return SubmissionFile
	 */
	public function setFileName($fileName) {
		$this->fileName = $fileName;
		
		return $this;
	}

	/**
	 * Get fileName
	 *
	 * @return string
	 */
	public function getFileName() {
		return $this->fileName;
	}

        /**
         * gets basename of file 
         * e.g. "file.csv" for "/var/data/sinp/data/file.csv" 
         * 
         * @return string
         */
        public function getBasename(){
            return ltrim(strrchr($this->fileName,'/'),'/');
        }

	/**
	 * Set nbLines
	 *
	 * @param integer $nbLines        	
	 *
	 * @return SubmissionFile
	 */
	public function setNbLines($nbLines) {
		$this->nbLines = $nbLines;
		
		return $this;
	}

	/**
	 * Get nbLines
	 *
	 * @return int
	 */
	public function getNbLines() {
		return $this->nbLines;
	}

	/**
	 * Set submission
	 *
	 * @param Submission $submission
	 *
	 * @return SubmissionFile
	 */
	public function setSubmission(Submission $submission) {
		$this->submission = $submission;
		
		return $this;
	}

	/**
	 * Get submission
	 *
	 * @return Submission
	 */
	public function getSubmission() {
		return $this->submission;
	}
}
