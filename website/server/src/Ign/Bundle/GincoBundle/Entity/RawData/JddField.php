<?php

namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;

/**
 * JddField
 *
 * @ORM\Table(name="raw_data.jdd_field")
 * @ORM\Entity
 */
class JddField
{
	// Possible types for values
	const TYPE_STRING = 'string';
	const TYPE_TEXT = 'text';
	const TYPE_INTEGER = 'integer';
	const TYPE_FLOAT = 'float';

    /**
     * @var int
     *
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\RawData\Jdd")
	 * @ORM\JoinColumn(name="jdd_id", referencedColumnName="id")
     */
    private $jdd;

    /**
     * @var string
     *
	 * @ORM\Id
     * @ORM\Column(name="key", type="string", length=255)
     */
    private $key;

    /**
     * @var string
     *
     * @ORM\Column(name="type", type="string", length=20)
     */
    private $type;

    /**
     * @var string
     *
     * @ORM\Column(name="value_string", type="string", length=255, nullable=true)
     */
    private $valueString;

    /**
     * @var string
     *
     * @ORM\Column(name="value_text", type="text", nullable=true)
     */
    private $valueText;

    /**
     * @var int
     *
     * @ORM\Column(name="value_integer", type="integer", nullable=true)
     */
    private $valueInteger;

	/**
     * @var string
     *
     * @ORM\Column(name="value_float", type="float", precision=10, scale=0, nullable=true)
     */
    private $valueFloat;

	public function __construct($key, $value, $type=null)
	{
		$this->setKey($key);
		$this->setValue($value, $type);
	}

	/**
     * Set jddId
     *
     * @param integer $jddId
     *
     * @return JddField
     */
    public function setJdd($jdd)
    {
        $this->jdd = $jdd;

        return $this;
    }

    /**
     * Get jddId
     *
     * @return int
     */
    public function getJdd()
    {
        return $this->jdd;
    }

    /**
     * Set key
     *
     * @param string $key
     *
     * @return JddField
     */
    public function setKey($key)
    {
        $this->key = $key;

        return $this;
    }

    /**
     * Get key
     *
     * @return string
     */
    public function getKey()
    {
        return $this->key;
    }

    /**
     * Get type
     *
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }

	/**
	 * Get value (depending on type)
	 *
	 * @return int|null|string
	 */
    public function getValue() {
    	switch ($this->type) {
			case self::TYPE_STRING:
				return $this->valueString;
			case self::TYPE_TEXT:
				return $this->valueText;
			case self::TYPE_INTEGER:
				return $this->valueInteger;
			case self::TYPE_FLOAT:
				return $this->valueFloat;
			default:
				return null;
		}
	}

	/**
	 * Set the vaule, store it in function of type if given,
	 * finds most appropriate if not
	 *
	 * @param $value
	 * @param null $type
	 * @return $this
	 */
	public function setValue($value, $type=null) {
		// first delete all old values
		$this->valueInteger = null;
		$this->valueFloat = null;
		$this->valueString = null;
		$this->valueText = null;

		switch ($type) {
			case self::TYPE_INTEGER:
				$this->valueInteger = intval($value);
				$this->type = $type;
				break;
			case self::TYPE_FLOAT:
				$this->valueFloat = floatval($value);
				$this->type = $type;
				break;
			case self::TYPE_TEXT:
				$this->valueText = (string) $value;
				$this->type = $type;
				break;
			case self::TYPE_STRING:
				$this->valueString = substr((string) $value, 0, 255);
				$this->type = $type;
				break;
			default:
				// Find the most appropriate type
				if (is_numeric($value)) {
					if (intval($value) == $value) {
						$this->valueInteger = intval($value);
						$this->type = self::TYPE_INTEGER;
					}
					else {
						$this->valueFloat = floatval($value);
						$this->type = self::TYPE_FLOAT;
					}
				}
				else {
					$strValue = (string) $value;
					if ($strValue && strlen($strValue) <= 255) {
						$this->valueString = $value;
						$this->type = self::TYPE_STRING;
					}
					else if ($strValue) {
						$this->valueText = $value;
						$this->type = self::TYPE_TEXT;
					}
					else {
						$this->valueString = null;
						$this->type = self::TYPE_STRING;
					}
				}
		}
		return $this;
	}
}