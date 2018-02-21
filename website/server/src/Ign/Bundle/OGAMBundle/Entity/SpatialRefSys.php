<?php
namespace Ign\Bundle\OGAMBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Saptial Ref Systems
 *
 * @ORM\Table(name="public.spatial_ref_sys")
 * @ORM\Entity
 */
class SpatialRefSys {

	/**
	 *
	 * @var int @ORM\Column(name="srid", type="integer")
	 *      @ORM\Id
	 */
	private $srid;

	/**
	 * Set srid
	 *
	 * @param integer $srid        	
	 *
	 * @return integer
	 */
	public function setSrid($srid) {
		$this->srid = $srid;
		
		return $this;
	}

	/**
	 * Get srid
	 *
	 * @return integer
	 */
	public function getSrid() {
		return $this->srid;
	}
}

