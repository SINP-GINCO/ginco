<?php
namespace Ign\Bundle\OGAMBundle\Repository\Database;

use Ign\Bundle\OGAMBundle\Entity\System\Table;
use Ign\Bundle\OGAMBundle\Entity\System\Field;
use Ign\Bundle\OGAMBundle\Entity\System\ForeignKey;
use Ign\Bundle\OGAMBundle\Repository\GenericRepository;

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
 * Model used to access the Metadata tables in order to compare with the real tables.
 *
 * @package Application_Model
 * @subpackage Database
 */
class MetadataRepository extends GenericRepository {

	/**
	 * List the available tables.
	 *
	 * @return The list of tables
	 * @throws an exception if the request is not found
	 */
	public function getTables() {
		$tables = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT * ";
		$req .= " FROM table_format t ";
		$req .= " INNER JOIN table_schema s USING (schema_code) ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			
			$table = new Table();
			
			$table->tableName = $result['table_name'];
			$table->schemaName = $result['schema_name'];
			$table->setPrimaryKeys($result['primary_key']);
			
			$tables[$table->schemaName . '_' . $table->tableName] = $table;
		}
		
		return $tables;
	}

	/**
	 * List the available tables.
	 *
	 * @return The list of tables
	 * @throws an exception if the request is not found
	 */
	public function getFields() {
		$fields = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT * ";
		$req .= " FROM table_field f ";
		$req .= " INNER JOIN table_format t USING (format)";
		$req .= " INNER JOIN table_schema s USING (schema_code) ";
		$req .= " INNER JOIN data USING (data) ";
		$req .= " INNER JOIN unit USING (unit) ";
		
		$query = $conn->prepare($req);
		$query->execute(array());
		
		$results = $query->fetchAll();
		foreach ($results as $result) {
			
			$field = new Field();
			
			$field->columnName = $result['column_name'];
			$field->tableName = $result['table_name'];
			$field->schemaName = $result['schema_name'];
			$field->type = $result['type'];
			
			$fields[$field->schemaName . '_' . $field->tableName . '_' . $field->columnName] = $field;
		}
		
		return $fields;
	}

	/**
	 * List the available tables.
	 *
	 * @return The list of tables
	 * @throws an exception if the request is not found
	 */
	public function getForeignKeys() {
		$keys = array();
		
		$conn = $this->getConnection();
		
		// Get the request
		$req = " SELECT UPPER(t.table_name) as table, UPPER(st.table_name) as source_table, UPPER(join_key) as keys ";
		$req .= " FROM table_tree ";
		$req .= " INNER JOIN table_format t on (child_table = t.format)";
		$req .= " INNER JOIN table_format st on (parent_table = st.format)";
		$req .= " WHERE parent_table != '*' ";
		
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
}
