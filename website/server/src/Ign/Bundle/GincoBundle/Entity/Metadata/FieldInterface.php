<?php

namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Ign\Bundle\GincoBundle\Entity\Metadata\Data;

/**
 *
 * @author rpas
 */
interface FieldInterface {
	
	public function getFormat() ;
	
	public function setFormat($format) ;
		
	public function getData() ;
	
	public function setData(Data $data) ;
}
