<?php
namespace Ign\Bundle\GincoBundle\Repository\Database;

use Ign\Bundle\GincoBundle\Entity\System\Table;
use Ign\Bundle\GincoBundle\Entity\System\Field;
use Ign\Bundle\GincoBundle\Entity\System\ForeignKey;
use Ign\Bundle\GincoBundle\Repository\GenericRepository;

/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * Model used to access the system tables of PostgreSQL.
 *
 * @package Application_Model
 * @subpackage Database
 */
class PostgresqlRepository extends GenericRepository {

	/**
	 * List the tables.
	 *
	 * @return The list of tables
	 * @throws an exception if the request is not found
	 */
	public function getTables() {
		$tables = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT     UPPER(table_name) AS table, ";
		$req .= "           UPPER(table_schema) AS schema, ";
		$req .= "           UPPER(constraint_name) as primary_key, ";
		$req .= "           array_to_string(array_agg(UPPER(c.column_name)),',') as pk_columns ";
		$req .= " FROM information_schema.tables ";
		$req .= " LEFT JOIN information_schema.table_constraints USING (table_catalog, table_schema, table_name) ";
		$req .= " LEFT JOIN information_schema.constraint_column_usage AS c USING (table_catalog, table_schema, table_name, constraint_name)  ";
		$req .= " WHERE table_type = 'BASE TABLE' ";
		$req .= " AND table_schema NOT IN ('pg_catalog', 'information_schema') ";
		$req .= " AND constraint_type = 'PRIMARY KEY' ";
		$req .= " GROUP BY table_name, table_schema, constraint_name ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			
			$table = new Table();
			
			$table->tableName = $result['table'];
			$table->schemaName = $result['schema'];
			$table->setPrimaryKeys($result['pk_columns']);
			
			$tables[$table->schemaName . '_' . $table->tableName] = $table;
		}
		
		return $tables;
	}

	/**
	 * List the data columns.
	 *
	 * @return The list of data
	 * @throws an exception if the request is not found
	 */
	public function getFields() {
		$fields = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT 	UPPER(column_name) AS column, ";
		$req .= "           UPPER(table_schema) AS schema, ";
		$req .= "           UPPER(table_name) AS table, ";
		$req .= "           UPPER(data_type) AS type ";
		$req .= " FROM information_schema.columns ";
		$req .= " INNER JOIN information_schema.tables USING (table_catalog, table_schema, table_name) ";
		$req .= " WHERE table_type = 'BASE TABLE' ";
		$req .= " AND table_schema NOT IN ('pg_catalog', 'information_schema') ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			
			$field = new Field();
			
			$field->columnName = $result['column'];
			$field->tableName = $result['table'];
			$field->schemaName = $result['schema'];
			$field->type = $result['type'];
			
			$fields[$field->schemaName . '_' . $field->tableName . '_' . $field->columnName] = $field;
		}
		
		return $fields;
	}

	/**
	 * List the foreign keys in the database.
	 *
	 * @return The list of data
	 * @throws an exception if the request is not found
	 */
	public function getForeignKeys() {
		$keys = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT UPPER(tc.table_name) as table, UPPER(ccu.table_name) as source_table, array_to_string(array_agg(UPPER(kcu.column_name)),',') as keys ";
		$req .= " FROM information_schema.table_constraints tc ";
		$req .= " LEFT JOIN information_schema.key_column_usage kcu USING (constraint_catalog, constraint_schema, constraint_name) ";
		$req .= " LEFT JOIN information_schema.referential_constraints rc USING (constraint_catalog, constraint_schema, constraint_name) ";
		$req .= " LEFT JOIN information_schema.constraint_column_usage ccu USING (constraint_catalog, constraint_schema, constraint_name, column_name) ";
		$req .= " WHERE constraint_type = 'FOREIGN KEY' ";
		$req .= " AND tc.table_schema NOT IN ('pg_catalog', 'information_schema') ";
		$req .= " GROUP BY tc.table_name, ccu.table_name ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			
			$key = new ForeignKey();
			
			$key->table = $result['table'];
			$key->sourceTable = $result['source_table'];
			$key->setForeignKeys($result['keys']);
			
			$keys[$key->table . '__' . $key->sourceTable] = $key;
		}
		
		return $keys;
	}

	/**
	 * List the schemas.
	 *
	 * @return Array[String] The list of schemas
	 * @throws an exception if the request is not found
	 */
	public function getSchemas() {
		$schemas = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT DISTINCT UPPER(table_schema) as table_schema ";
		$req .= " FROM  information_schema.tables ";
		$req .= " WHERE table_schema NOT IN ('pg_catalog', 'information_schema') ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			$schemas[] = $result['table_schema'];
		}
		
		return $schemas;
	}
}
