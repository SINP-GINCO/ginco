<?php

namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * FieldMapping
 *
 * @ORM\Table(name="metadata_work.field_mapping")
 * @ORM\Entity
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMConfigurateurBundle\Entity\FieldMappingRepository")
 * @UniqueEntity(fields = {"dstData", "dstFormat", "srcFormat"}, message = "fieldMapping.unique")
 */
class FieldMapping
{
    /**
     * @var string
     *
     * @ORM\Column(name="src_data", type="string", length=36, nullable=false)
     * @ORM\Id
     * @Assert\NotBlank(message="fieldMapping.srcData.notBlank")
     */
    private $srcData;

    /**
     * @var string
     *
     * @ORM\Column(name="src_format", type="string", length=256, nullable=false)
     * @ORM\Id
     *
     */
    private $srcFormat;

    /**
     * @var string
     *
     * @ORM\Column(name="dst_data", type="string", length=36, nullable=false)
     * @ORM\Id
     * @Assert\NotBlank(message="fieldMapping.dstData.notBlank")
     */
    private $dstData;

    /**
     * @var string
     *
     * @ORM\Column(name="dst_format", type="string", length=256, nullable=false)
     * @ORM\Id
     * @Assert\NotBlank(message="fieldMapping.dstFormat.notBlank")
     */
    private $dstFormat;

    /**
     *  The type of the mapping (FILE, FORM or HARMONIZED).
     * @var string
     *
     * @ORM\Column(name="mapping_type", type="string", length=36, nullable=false)
     */
    private $mappingType;

    
    /**
     * Set SrcData
     *
     * @param string $srcData
     * @return FieldMapping
     */
    public function setSrcData($srcData)
    {
    	$this->srcData = $srcData;
    
    	return $this;
    }
    
    /**
     * Get srcData
     *
     * @return string
     */
    public function getSrcData()
    {
    	return $this->srcData;
    }
    
    /**
     * Set srcFormat
     *
     * @param string $srcFormat
     * @return FieldMapping
     */
    public function setSrcFormat($srcFormat)
    {
    	$this->srcFormat = $srcFormat;
    
    	return $this;
    }
    
    /**
     * Get srcFormat
     *
     * @return string
     */
    public function getSrcFormat()
    {
    	return $this->srcFormat;
    }
    
    /**
     * Set dstData
     *
     * @param string $dstData
     * @return FieldMapping
     */
    public function setDstData($dstData)
    {
    	$this->dstData = $dstData;
    
    	return $this;
    }
    
    /**
     * Get dstData
     *
     * @return string
     */
    public function getDstData()
    {
    	return $this->dstData;
    }
    
    /**
     * Set dstFormat
     *
     * @param string $dstFormat
     * @return FieldMapping
     */
    public function setDstFormat($dstFormat)
    {
    	$this->dstFormat = $dstFormat;
    
    	return $this;
    }
    
    /**
     * Get dstFormat
     *
     * @return string
     */
    public function getDstFormat()
    {
    	return $this->dstFormat;
    }
    
    /**
     * Set mappingType
     *
     * @param string $mappingType
     * @return FieldMapping
     */
    public function setMappingType($mappingType)
    {
    	$this->mappingType = $mappingType;
    
    	return $this;
    }
    
    /**
     * Get mappingType
     *
     * @return string
     */
    public function getMappingType()
    {
    	return $this->mappingType;
    }
    

}
