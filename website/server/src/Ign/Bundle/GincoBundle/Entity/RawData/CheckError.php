<?php
namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;

/**
 * CheckError.
 *
 * @ORM\Table(name="raw_data.check_error")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\RawData\CheckErrorRepository")
 */
class CheckError {
    
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
        private $srcData;
        
        /**
         * @ORM\ManyToOne(targetEntity="\Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat")
         * @ORM\JoinColumn(name="src_format", referencedColumnName="format")
         * 
         * @var integer 
         */
        private $srcFormat;        

        /**
         * @ORM\ManyToOne(targetEntity="\Ign\Bundle\GincoBundle\Entity\Metadata\Check")
         * @ORM\JoinColumn(name="check_id", referencedColumnName="check_id")
         * @ORM\Id
         * 
         * @var integer 
         */
        private $checkError;

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
        private $errorMessage;
        
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
	 * @return Submission
	 */
	public function getSubmission() {
            return $this->submission;
	}
        
	/**
	 *
	 * @param Submission $submission
	 * @return $this
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
         * @return $this
         */
        function setLineNumber($lineNumber) {
            $this->lineNumber = $lineNumber;
            return $this;
        }

        /**
         * 
         * @return string
         */
        function getSrcData() {
            return $this->srcData;
        }

        /**
         * 
         * @param string $srcData
         * @return $this
         */
        function setSrcData($srcData) {
            $this->srcData = $srcData;
            return $this;
        }

        /**
         * 
         * @return \Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat
         */
        function getSrcFormat() {
            return $this->srcFormat;
        }

        /**
         * 
         * @param FileFormat $srcFormat
         * @return $this
         */
        function setSrcFormat(\Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat $srcFormat) {
            $this->srcFormat = $srcFormat;
            return $this;
        }
                
        /**
         * 
         * @return \Ign\Bundle\GincoBundle\Entity\Metadata\Check
         */
        function getCheckError() {
            return $this->checkError;
        }

        /**
         * 
         * @param CheckError $checkError
         * @return $this
         */
        function setCheckError(\Ign\Bundle\GincoBundle\Entity\Metadata\Check $checkError) {
            $this->checkError = $checkError;
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
         * @return $this
         */
        function setExpectedValue($expectedValue) {
            $this->expectedValue = $expectedValue;
            return $this;
        }
        
        /**
         * 
         * @return string
         */
        function getErrorMessage() {
            return $this->errorMessage;
        }

        /**
         * 
         * @param string $errorMessage
         * @return $this
         */
        function setErrorMessage($errorMessage) {
            $this->errorMessage = $errorMessage;
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
         * @return $this
         */
        function setCreationDate(\DateTime $creationDate) {
            $this->creationDate = $creationDate;
            return $this;
        }

}
