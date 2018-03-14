<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Metadata\FormField;

/**
 * PredefinedRequestCriteria
 *
 * @ORM\Table(name="website.predefined_request_criterion")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Website\PredefinedRequestCriterionRepository")
 */
class PredefinedRequestCriterion {

	/**
	 *
	 * @var PredefinedRequest 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="PredefinedRequest")
	 * @ORM\JoinColumn(name="request_id", referencedColumnName="request_id")
	 */
	private $requestId;

	/**
	 *
	 * @var Format 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Metadata\Format")
	 * @ORM\JoinColumns({@ORM\JoinColumn(name="format", referencedColumnName="format")})
	 */
	private $format;

	/**
	 *
	 * @var Data 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Metadata\Data")
	 * @ORM\JoinColumns({@ORM\JoinColumn(name="data", referencedColumnName="data")})
	 */
	private $data;

	/**
	 *
	 * @var string @ORM\Column(name="value", type="string")
	 */
	private $value;

	/**
	 *
	 * @var FormField @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Metadata\FormField")
	 *      @ORM\JoinColumns({@ORM\JoinColumn(name="data", referencedColumnName="data"),@ORM\JoinColumn(name="format", referencedColumnName="format")})
	 */
	private $formField;

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->format->getFormat() . '__' . $this->data->getData();
	}

	/**
	 * Set requestId
	 *
	 * @param integer $requestId
	 *
	 * @return PredefinedRequestCriterion
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
	 * Set format
	 *
	 * @param string $format
	 *
	 * @return PredefinedRequestCriterion
	 */
	public function setFormat($format) {
		$this->format = $format;

		return $this;
	}

	/**
	 * Get format
	 *
	 * @return string
	 */
	public function getFormat() {
		return $this->format;
	}

	/**
	 * Set data
	 *
	 * @param string $data
	 *
	 * @return PredefinedRequestCriterion
	 */
	public function setData($data) {
		$this->data = $data;

		return $this;
	}

	/**
	 * Get data
	 *
	 * @return string
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set value
	 *
	 * @param string $value
	 *
	 * @return PredefinedRequestCriterion
	 */
	public function setValue($value) {
		$this->value = $value;

		return $this;
	}

	/**
	 * Get value
	 *
	 * @return string
	 */
	public function getValue() {
		return $this->value;
	}

	/**
	 *
	 * @return FormField
	 */
	public function getFormField() {
		return $this->formField;
	}

	/**
	 *
	 * @param FormField $formField
	 */
	public function setFormField(FormField $formField) {
		$this->formField = $formField;
		return $this;
	}
}

