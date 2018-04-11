<?php
namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;

/**
 * SubmissionFile.
 *
 * @ORM\Table(name="raw_data.check_error")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\RawData\ErrorRepository")
 */
class Error {
    
        /**
         * @ORM\Column(name="check_error_id")
         * @ORM\Id
         * 
         * @var integer 
         */    
        private $id;

	/**
	 * @ORM\ManyToOne(targetEntity="Submission")
	 * @ORM\JoinColumn(name="submission_id", referencedColumnName="submission_id")
	 * @ORM\Id
	 */
	private $submission;
        
        /**
         * @ORM\Column(name="line_number")
         * 
         * @var integer 
         */
        private $lineNumber;
        
        /**
         * @ORM\Column(name="src_data")
         * 
         * @var string 
         */        
        private $field;

        /**
         * @ORM\ManyToOne(targetEntity="\Ign\Bundle\GincoBundle\Entity\Metadata\Check")
         * @ORM\JoinColumn(name="check_id", referencedColumnName="check_id")
         * @ORM\Id
         * 
         * @var integer 
         */
        private $error;

        /**
         * @ORM\Column(name="found_value")
         * 
         * @var string 
         */
        private $foundValue;

        /**
         * @ORM\Column(name="expected_value")
         * 
         * @var string 
         */
        private $expectedValue;

        /**
         * @ORM\Column(name="error_message")
         * 
         * @var string 
         */
        private $comment;
        
        /**
	 * @ORM\Column(name="_creationdt", type="date")
         * 
	 * @var \DateTime 
	 */
	private $creationDate;
        
        /**
         * 
         * @return integer
         */
        function getId() {
            return $this->id;
        }

        /**
         * 
         * @param integer $id
         * @return Error
         */
        function setId($id) {
            $this->id = $id;
            return $this;
        }
       
        /**
	 *
	 * @return Submission
	 */
	public function getSubmission() {
            return $this->submission;
	}
        
	/**
	 *
	 * @param Submission $submission
	 * @return Error
	 */
	public function setSubmission(Submission $submission) {
            $this->submission = $submission;		
            return $this;
	}

        /**
         * 
         * @return integer
         */
        function getLineNumber() {
            return $this->lineNumber;
        }

        /**
         * 
         * @param integer $lineNumber
         * @return Error
         */
        function setLineNumber($lineNumber) {
            $this->lineNumber = $lineNumber;
            return $this;
        }

        /**
         * 
         * @return string
         */
        function getField() {
            return $this->field;
        }

        /**
         * 
         * @param string $field
         * @return Error
         */
        function setField($field) {
            $this->field = $field;
            return $this;
        }

                
        /**
         * 
         * @return integer
         */
        function getError() {
            return $this->error;
        }

        /**
         * 
         * @param integer $error
         * @return Error
         */
        function setError($error) {
            $this->error = $error;
            return $this;
        }

        /**
         * 
         * @return \DateTime
         */
        function getCreationDate() {
            return $this->creationDate;
        }

        /**
         * 
         * @param \DateTime $creationDate
         * @return Error
         */
        function setCreationDate(\DateTime $creationDate) {
            $this->creationDate = $creationDate;
            return $this;
        }

        /**
         * 
         * @return string
         */
        function getFoundValue() {
            return $this->foundValue;
        }

        /**
         * 
         * @param string $foundValue
         * @return $this
         */
        function setFoundValue($foundValue) {
            $this->foundValue = $foundValue;
            return $this;
        }

        /**
         * 
         * @return string
         */
        function getExpectedValue() {
            return $this->expectedValue;
        }

        /**
         * 
         * @param string $expectedValue
         * @return Error
         */
        function setExpectedValue($expectedValue) {
            $this->expectedValue = $expectedValue;
            return $this;
        }

        /**
         * 
         * @return string
         */
        function getComment() {
            return $this->comment;
        }

        /**
         * 
         * @param string $comment
         * @return Error
         */
        function setComment($comment) {
            $this->comment = $comment;
            return $this;
        }

}
