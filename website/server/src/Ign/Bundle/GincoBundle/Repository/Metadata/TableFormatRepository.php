<?php
namespace Ign\Bundle\GincoBundle\Repository\Metadata;

use Doctrine\ORM\Query\ResultSetMappingBuilder;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\Standard;

/**
 * TableFormatRepository
 *
 * This class was generated by the Doctrine ORM. Add your own custom
 * repository methods below.
 */
class TableFormatRepository extends \Doctrine\ORM\EntityRepository {

	/**
	 * Get the information about a table format.
	 *
	 * @param String $schema
	 *        	the schema identifier
	 * @param String $format
	 *        	the format
	 * @param String $lang
	 *        	the lang
	 * @return Application_Object_Metadata_TableFormat
	 */
	public function getTableFormat($schema, $format, $lang) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata($this->_entityName, 't');
		
		// Get the fields specified by the format
		$sql = "SELECT format, schema_code, table_name, COALESCE(t.label, tf.label) as label, primary_key ";
		$sql .= " FROM table_format tf";
		$sql .= " LEFT JOIN translation t ON (lang = ? AND table_format = 'TABLE_FORMAT' AND row_pk = format)";
		$sql .= " WHERE schema_code = ? ";
		$sql .= " AND format = ? ";
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameters(array(
			$lang,
			$schema,
			$format
		));
		
		return $query->getResult()[0];
	}
	
	
	/**
	 * Get information about the first geometry table in table tree
	 * @param type $schema
	 * @param type $format
	 * @param type $lang
	 * @return type
	 */
	public function getParentGeometryTableFormat($schema, $format, $lang) {
		
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata($this->_entityName, 't');
		
		// Get the fields specified by the format
		
		$sql = "
			WITH RECURSIVE parent AS (
				SELECT tf.format, tf.schema_code, tf.table_name, COALESCE(t.label, tf.label) as label, tf.primary_key
				FROM table_format tf
				LEFT JOIN translation t ON (t.lang = :lang AND t.table_format = 'TABLE_FORMAT' AND t.row_pk = format)
				JOIN metadata.table_field tfi USING (format)
				JOIN metadata.DATA d USING (data)
				WHERE tf.schema_code = :schema
				AND tf.format = :format
				AND d.unit = 'GEOM'
				UNION
				SELECT tf.format, tf.schema_code, tf.table_name, COALESCE(t.label, tf.label) as label, tf.primary_key
				FROM table_format tf
				LEFT JOIN translation t ON (t.lang = :lang AND t.table_format = 'TABLE_FORMAT' AND t.row_pk = format)
				JOIN table_tree tt ON tf.format = tt.parent_table
				WHERE tf.format = :format
			) SELECT * FROM parent 
		";
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameters(array(
			'lang' => $lang,
			'schema' => $schema,
			'format' => $format
		));
		
		return $query->getResult()[0];
	}
	
	/**
	 * Get all table formats.
	 *
	 * @return Array[TableFormat]
	 */
	public function getAllTableFormats() {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata($this->_entityName, 't');
	
		$sql = "SELECT format, table_name, schema_code, primary_key, label, definition ";
		$sql .= " FROM metadata.table_format;";
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		
		return $query->getResult();
	}
	
	/**
	 * Get all table formats with a geometry column for a given model (if supplied, otherwise get all table formats with geometry).
	 * @return Array[TableFormat]
	 */
	public function getTableFormatsWithGeometry(Model $model = null) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata($this->_entityName, 't');
	
		$sql = "SELECT format, table_name, schema_code, primary_key, tf.label, tf.definition ";
		$sql .= " FROM metadata.table_format tf ";
		$sql .= "JOIN metadata.table_field tfi USING (format) " ;
		$sql .= "JOIN metadata.DATA d USING (data) ";
		
		if (!is_null($model)) {
			$sql .= "JOIN metadata.model_tables mt ON mt.table_id = tf.format ";
		}
		
		$sql .= "WHERE d.unit = 'GEOM' " ;
		
		if (!is_null($model)) {
			$sql .= "AND mt.model_id = :model" ;
		}
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		
		if (!is_null($model)) {
			$query->setParameter('model', $model->getId()) ;
		}
		
		return $query->getResult();		
	}
	
	
	/**
	 * Trouve toutes les tables qui ne sont ni enfant de la table en entrée, ni la table elle-meme.
	 * @param TableFormat $tableFormat
	 * @return TableFormat[]
	 */
	public function findNotChildTables(TableFormat $tableFormat) {
		
		$sql = "WITH RECURSIVE child_table AS (
					SELECT tf.* 
					FROM metadata.table_format tf 
					JOIN metadata.table_tree tt ON tt.child_table = tf.format
					WHERE tt.parent_table = :parentTable
					UNION
					SELECT tf.* 
					FROM metadata.table_format tf 
					JOIN metadata.table_tree tt ON tt.child_table = tf.format
					JOIN child_table ct ON tt.parent_table = ct.format
				)
				SELECT tf.* FROM metadata.table_format tf 
				LEFT JOIN child_table ct ON ct.format = tf.format
				WHERE ct.format IS NULL
				AND tf.format IS DISTINCT FROM :parentTable" ;
		
		$rsm = new ResultSetMappingBuilder($this->getEntityManager()) ;
		$rsm->addRootEntityFromClassMetadata($this->getClassName(), 'tf') ;
		$query = $this->getEntityManager()->createNativeQuery($sql, $rsm) ;
		$query->setParameter('parentTable', $tableFormat->getFormat()) ;
		
		return $query->getResult() ;
	}
	
	
	/**
	 * Recherche tous les table_format correspondant à un modèle publié dans un standard donné.
     * @param $standard Standard à considérer.
	 * @return TableFormat[]
	 */
	public function findPublishedTableFormats(Standard $standard) {
		
		return $this->createQueryBuilder('tf')
			->join('tf.models', 'm')
			->where('m.status = :status')
            ->andWhere('m.standard = :standard')
			->setParameter('status', Model::PUBLISHED)
            ->setParameter('standard', $standard->getName())
			->getQuery()
			->getResult()
		;
	}
	

	/**
	 * Retrouve la table parente (si existante) d'une table donnée.
	 * @param TableFormat $tableFormat
	 * @return TableFormat La table parente (ou null si non existante, false si un problème a été rencontré).
	 */
	public function findParent(TableFormat $tableFormat) {
		
		$tableTreeRepository = $this->getEntityManager()->getRepository('IgnGincoBundle:Metadata\TableTree') ;
		
		$tableTree = $tableTreeRepository->findOneBy(['childTable' => $tableFormat]) ;
		if (!$tableTree) {
			return false ;
		}		
		return $tableTree->getParentTable() ;
	}
}
