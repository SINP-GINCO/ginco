<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * @Route("/geo-association")
 */
class GeoAssociationController extends GincoController  {

	/**
	 * Create or update geo association for a submission
	 * This route is not in security.yml as java calls it
	 *
	 * @Route("/compute", name="compute")
	 */
	public function computeGeoAssociationAction(Request $request) {
		$this->get('logger')->debug('computeGeoAssociationAction');
		
		// Get the submission Id
		$submissionId = $request->query->getInt("submissionId");
		
		$submission = $this->getDoctrine()
			->getManager('website')
			->getRepository('IgnGincoBundle:RawData\Submission')
			->find($submissionId);
		$this->get('logger')->debug('submission: ' . $submissionId);
		
		$entity = null;
		$providerId = null;
		$jdd = null;
		
		$this->get('ginco.geo_association_service')->computeGeoAssociation($providerId, $submission, $jdd, $entity);
		
		return new response();
	}
	
	/**
	 * Update geo association for a jdd
	 *
	 * @Route("/update-jdd", name="update-jdd")
	 */
	public function updateJddGeoAssociationAction(Request $request) {
		$this->get('logger')->debug('createGeoAssociationAction');
	
		// Get the submission Id
		$jddId = $request->query->getInt("jddId");
	
		$submission = null;
		$entity = null;
		$providerId = null;
		
		$jdd = $this->getDoctrine()
			->getManager('website')
			->getRepository('IgnGincoBundle:RawData\Jdd')
			->find($jddId);
	
		$this->get('ginco.geo_association_service')->computeGeoAssociation($providerId, $submission, $jdd, $entity);
	
		return new response();
	}
	
	/**
	 * Update geo association for an entity (commune or departement)
	 *
	 * @Route("/update-entity", name="update-entity")
	 */
	public function updateEntityGeoAssociationAction(Request $request) {
		$this->get('logger')->debug('createGeoAssociationAction');
	
		// Get the submission Id
		$entity = $request->query->get("entity");
	
		$submission = null;
		$providerId = null;
		$jdd = null;
	
		$this->get('ginco.geo_association_service')->computeGeoAssociation($providerId, $submission, $jdd, $entity);
	
		return new response();
	}
}
