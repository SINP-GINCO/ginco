<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;
use Ign\Bundle\ConfigurateurBundle\IgnConfigurateurBundle;

class TableTreeRepository extends EntityRepository {

	/**
	 * Get the list of child tables and childs of the childs...
	 *
	 * @param
	 *        	tableFormat the name of the table format
	 *        	
	 * @return Array of tableFormat
	 */
	public function findChildTablesByTableFormat($tableFormat, $conn) {
		$sql = 'WITH RECURSIVE table_tree (child_table)
				AS (SELECT child_table
					FROM metadata_work.table_tree
					WHERE parent_table = :tableFormat
					UNION ALL
					SELECT tt.child_table
					FROM metadata_work.table_tree tt
					INNER JOIN table_tree t
					ON t.child_table = tt.parent_table)
					SELECT child_table
					FROM table_tree
					LIMIT 50';
		
		$stmt = $conn->prepare($sql);
		$stmt->bindParam(':tableFormat', $tableFormat);
		$stmt->execute();
		$childTables = Array();
		while ($row = $stmt->fetch()) {
			$childTables[] = $row['child_table'];
		}
		
		return $childTables;
	}
}
