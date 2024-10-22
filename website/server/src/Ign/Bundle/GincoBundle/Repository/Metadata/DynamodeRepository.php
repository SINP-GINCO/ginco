<?php
namespace Ign\Bundle\GincoBundle\Repository\Metadata;

use Ign\Bundle\GincoBundle\Entity\Metadata\Unit;
use Ign\Bundle\GincoBundle\Entity\Metadata\Mode;
use Doctrine\ORM\Query\ResultSetMappingBuilder;

/**
 * DynamodeRepository
 *
 * This class was generated by the Doctrine ORM. Add your own custom
 * repository methods below.
 */
class DynamodeRepository extends \Doctrine\ORM\EntityRepository {

	/**
	 * Returns the mode(s) corresponding to the unit (50 max).
	 *
	 * Note :
	 * Use that function only with units owning a short list of modes
	 * For units owning a long list of modes use the filtered functions (by code or query string)
	 *
	 * @param Unit $unit
	 *        	The unit
	 * @param String $locale
	 *        	The locale
	 *        	return Mode[] The unit mode(s)
	 */
	public function getModes(Unit $unit, $locale) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata(Mode::class, 'm');
		$params = [
			'unit' => $unit->getUnit(),
			'lang' => $locale
		];
		
		$sql = "SELECT '" . $unit->getUnit() . "' as unit, code, COALESCE(t.label, m.label) as label, COALESCE(t.definition, m.definition) as definition, position ";
		$sql .= " FROM ( " . $unit->getDynamode()->getSql() . " ) as m ";
		$sql .= " LEFT JOIN translation t ON (lang = :lang AND table_format = 'METADATA_DYNAMODE_TABLE' AND row_pk = :unit || ',' || m.code) ";
		$sql .= " ORDER BY position ";
		$sql .= " LIMIT 50 ";
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameters($params);
		
		return $query->getResult();
	}

	/**
	 * Returns the mode(s) corresponding to the code(s).
	 *
	 * @param Unit $unit
	 *        	The unit
	 * @param String|Array $code
	 *        	The filter code(s)
	 * @param String $locale
	 *        	The locale
	 * @return [Mode] The filtered mode(s)
	 */
	public function getModesFilteredByCode(Unit $unit, $code, $locale) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata(Mode::class, 'm');
		$params = [
			'lang' => $locale,
			'unit' => $unit->getUnit(),
			'code' => $code
		];
		
		$sql = "SELECT '" . $unit->getUnit() . "' as unit, code, COALESCE(t.label, m.label) as label, COALESCE(t.definition, m.definition) as definition, position ";
		$sql .= " FROM ( " . $unit->getDynamode()->getSql() . " ) as m ";
		$sql .= " LEFT JOIN translation t ON (lang = :lang AND table_format = 'DYNAMODE' AND row_pk = :unit || ',' || m.code) ";
		if (is_array($code)) {
			$sql .= " WHERE code IN ( :code )";
		} else {
			$sql .= " WHERE code = :code";
		}
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameters($params);
		
		return $query->getResult();
	}

	/**
	 * Returns the mode(s) whose label contains a portion of the search text
	 *
	 * @param Unit $unit
	 *        	The unit
	 * @param String $query
	 *        	The filter query string
	 * @param String $locale
	 *        	The locale
	 * @return [Mode] The filtered mode(s)
	 */
	public function getModesFilteredByLabel(Unit $unit, $query, $locale) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addRootEntityFromClassMetadata(Mode::class, 'm');
		$params = [
			'unit' => $unit->getUnit(),
			'lang' => $locale,
			'query' => $query . '%'
		];
		
		$sql = "SELECT '" . $unit->getUnit() . "' as unit, code, COALESCE(t.label, m.label) as label, COALESCE(t.definition, m.definition) as definition, position ";
		$sql .= " FROM ( " . $unit->getDynamode()->getSql() . " ) as m ";
		$sql .= " LEFT JOIN translation t ON (lang = :lang AND table_format = 'DYNAMODE' AND row_pk = :unit || ',' || m.code) ";
		$sql .= " WHERE COALESCE(t.label, m.label) ilike :query ";
		
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameters($params);
		
		return $query->getResult();
	}
}