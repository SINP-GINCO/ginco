<?php

namespace Ign\Bundle\GincoBundle\Query;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat ;

/**
 * Construit une requete SQL pour requeter une table du modèle.
 *
 * @author rpas
 */
class TableFormatQueryBuilder {
 
	
	/**
	 *
	 * @var TableFormat
	 */
	protected $tableFormat ;
	
	
	/**
	 * Alias for table.
	 * @var string
	 */
	protected $alias ;
	
	
	/**
	 * Select clause
	 * @var array
	 */
	protected $select ;
	
	
	/**
	 * Select distinct
	 * @var boolean ;
	 */
	protected $distinct ;
	
	
	/**
	 * 
	 * @var boolean
	 */
	protected $count ;
	
	
	/**
	 * Jointures
	 * @var array 
	 */
	protected $joins ;


	/**
	 * WHERE clauses
	 * @var array
	 */
	protected $where ;
	
	/**
	 * Limit 
	 * @var integer
	 */
	protected $limit ;
	
	/**
	 * Offset
	 * @var integer ;
	 */
	protected $offset ;
	
	/**
	 * Order by clause
	 * @var array
	 */
	protected $orderBy ;
	
	/**
	 * Stocke les valeurs SQL paramétrées.
	 * @var array
	 */
	protected $parameters ;
	
	
	public function __construct(TableFormat $tableFormat, $alias) {
		
		$this->tableFormat = $tableFormat ;	
		$this->alias = $alias ;
		
		$this->select = array() ;
		$this->joins = array() ;
		$this->where = array() ;
		$this->limit = null ;
		$this->offset = null ;
		$this->orderBy = array() ;
		$this->count = false ;
		$this->distinct = false ;
	}
	
	
	/**
	 * Définit les colonnes à sélectionner.
	 * @param type $columns
	 */
	public function select($columns = array()) {
		
		$this->select = $columns ;
		return $this ;
	}
	
	/**
	 * Select DISTINCT.
	 * @return $this
	 */
	public function distinct() {
		
		$this->distinct =  true ;
		return $this ;
	}
	
	
	/**
	 * Définit l'option permettant de faire un count à la place d'un select simple.
	 */
	public function count() {
		
		$this->count = true ;
		return $this ;
	}
	
	/**
	 * Indique si la requête est de type COUNT.
	 * @return boolean
	 */
	public function isCount() {
		return $this->count ;
	}
	
	/**
	 * Ajoute une jointure à la requête
	 * @param string $tableName
	 * @param string $alias
	 * @param string $on
	 * @return $this
	 */
	public function join($tableName, $alias, $on) {
		
		$this->joins[] = array(
			'tableName' => $tableName,
			'alias' => $alias,
			'on' => $on
		);
		return $this ;
	}
	
	/**
	 * Ajoute une clause where à la requete.
	 */
	public function where($where) {
		
		$this->where[] = $where ;
		return $this ;
	}
	
	/**
	 * Ajoute une clause WHERE AND.
	 * @param string $column Nom de la colonne sur laquelle porte la condition
	 * @param mixed $value Valeur souhaitée pour la colonne
	 * @return $this
	 */
	public function andWhere($where) {
		
		$this->where[] = $where ;
		return $this ;
	}
	
	
	/**
	 * Set SQL parameter for prepared statement.
	 * @param string $parameter
	 * @param mixed $value
	 * @return $this
	 */
	public function setParameter($parameter, $value) {
		
		$this->parameters[$parameter] = $value ;
		return $this ;
	}
	
	/**
	 * Get SQL parameters
	 * @return type
	 */
	public function getParemeters() {
		return $this->parameters ;
	}	
	
	/**
	 * Definit la limite.
	 * @param integer $limit
	 * @return $this
	 */
	public function limit($limit) {
		
		$this->limit = $limit ;
		return $this ;
	}
	
	
	/**
	 * Définit un offset
	 * @param integer $offset
	 * @return $this
	 */
	public function offset($offset) {
		
		$this->offset = $offset ;
		return $this ;
	}
	
	/**
	 * Définit l'ordre des résultats.
	 * @param array $order Tableau des conditions ORDER BY sous la forme ['colonne1' => 'ASC', 'colonne2' => 'DESC']
	 * @return $this
	 */
	public function orderBy($column, $order = 'ASC') {
		
		$this->orderBy[] = array(
			'column' => $column,
			'order' => $order
		);
		return $this ;
	}
	
	
	/**
	 * Construit la requete SQL paramétrée.
	 * @return string
	 */
	public function getSQL() {
		
		$self = $this ;
		
		$sql = "SELECT " . $this->selectStatement() ;
	
		$sql .= " FROM " . $this->tableFormat->getTableName() . " $this->alias " ;
		
		if (!empty($this->joins)) {
			
			foreach ($this->joins as $join) {
				
				$sql .= "JOIN {$join['tableName']} {$join['alias']} ON {$join['on']} " ;
			}
		}
		
		if (!empty($this->where)) {
			$sql .= "WHERE " ;
			$sql .= implode('AND ', $this->where) ;
		}
		
		if (!empty($this->limit)) {
			$sql .= " LIMIT $this->limit " ;
		}
		
		if (!empty($this->offset)) {
			$sql .= " OFFSET $this->offset " ;
		}
		
		if (!empty($this->orderBy)) {	
			$sql .= " ORDER BY " . implode(", ", array_map(function ($c) { return "{$c['column']} {$c['order']}" ; }, $this->orderBy) ) ;
		}
		
		return $sql ;
	}

	
	/**
	 * Crée la partie SELECT de la requête SQL.
	 * @return type
	 */
	private function selectStatement() {
	
		$statement = "" ;
		
		if (empty($this->select)) {
			$statement .= "*" ;
		} else {
			$statement .= implode(", ", $this->select) ;
		}
		
		if ($this->distinct) {
			$statement = "DISTINCT $statement" ;
		}
		
		if ($this->count) {
			$statement = "count($statement)" ;
		}
		
		return $statement ;
	}
}
