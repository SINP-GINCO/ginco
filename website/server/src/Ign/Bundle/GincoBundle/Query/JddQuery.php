<?php

namespace Ign\Bundle\GincoBundle\Query;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Entity\Website\Provider;

/**
 * Description of JddQuery
 *
 * @author rpas
 */
class JddQuery {
	
	const DEFAULT_LIMIT = 10 ;
	
	/**
	 *
	 * @var int
	 */
	protected $limit ; 
	
	/**
	 *
	 * @var int
	 */
	protected $offset ;
	
	/**
	 *
	 * @var int
	 */
	protected $page ;


	/**
	 *
	 * @var User
	 */
	protected $user ;

	/**
	 *
	 * @var Provider ;
	 */
	protected $provider ;
	
	/**
	 *
	 * @var string
	 */
	protected $search ;



	public function __construct($page = 1, $limit = self::DEFAULT_LIMIT) {
		
		$this->page = max($page, 1) ;
		$this->limit = $limit ;
		$this->offset = max($limit*($page-1), 0) ;
	}
	
	/**
	 * 
	 * @return User
	 */
	public function getUser() {
		return $this->user ;
	}
	
	/**
	 * 
	 * @param User $user
	 * @return $this
	 */
	public function setUser(User $user) {
		$this->user = $user ;
		return $this ;
	}
	
	/**
	 * 
	 * @return Provider
	 */
	public function getProvider() {
		return $this->provider ;
	}
	
	/**
	 * 
	 * @param Provider $provider
	 * @return $this
	 */
	public function setProvider(Provider $provider) {
		$this->provider = $provider ;
		return $this ;
	}
	
	/**
	 * 
	 * @return int
	 */
	public function getLimit() {
		return $this->limit ;
	}
	
	/**
	 * 
	 * @return int
	 */
	public function getOffset() {
		return $this->offset ;
	}
	
	/**
	 * 
	 * @return int
	 */
	public function getPage() {
		return $this->page ;
	}
	
	/**
	 * 
	 * @return string
	 */
	public function getSearch() {
		return $this->search ;
	}
	
	/**
	 * 
	 * @param string $search
	 * @return $this
	 */
	public function setSearch($search) {
		$this->search = $search ;
		return $this ;
	}
}
