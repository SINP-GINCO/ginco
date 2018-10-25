<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Doctrine\DBAL\Exception\UniqueConstraintViolationException;
use Ign\Bundle\GincoBundle\Entity\Website\PredefinedRequest;
use Ign\Bundle\GincoBundle\Entity\Website\PredefinedRequestColumn;
use Ign\Bundle\GincoBundle\Entity\Website\PredefinedRequestCriterion;
use Ign\Bundle\GincoBundle\Entity\Website\PredefinedRequestGroup;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\BadCredentialsException;

/**
 * @Route("/query")
 */
class PredefinedRequestController extends GincoController {

	/**
	 * @Route("/ajaxgetpredefinedrequestlist", name="query_get_predefined_request_list")
	 */
	public function ajaxgetpredefinedrequestlistAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetpredefinedrequestlist');
		
		$sort = $request->query->get('sort');
		$dir = $request->query->getAlpha('dir');
		
		// Get the predefined values for the forms
		$schema = $this->get('ginco.schema_listener')->getSchema();
		$locale = $this->get('ginco.locale_listener')->getLocale();
		$predefinedRequestRepository = $this->get('doctrine')->getRepository(PredefinedRequest::class);
		$predefinedRequestList = $predefinedRequestRepository->getPredefinedRequestList($schema, $dir, $sort, $locale, $this->getUser());
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetpredefinedrequestlist.json.twig', array(
			'data' => $predefinedRequestList,
			'user' => $this->getUser()
		), $response);
	}

	/**
	 * @Route("/ajaxgetpredefinedrequestcriteria", name="query_get_predefined_request_criteria")
	 */
	public function ajaxgetpredefinedrequestcriteriaAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetpredefinedrequestcriteria');
		
		$requestName = $request->query->get('request_name');
		$predefinedRequestCriterionRepository = $this->get('doctrine')->getRepository(PredefinedRequestCriterion::class);
		$locale = $this->get('ginco.locale_listener')->getLocale();
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetpredefinedrequestcriteria.html.twig', array(
			'data' => $predefinedRequestCriterionRepository->getPredefinedRequestCriteria($requestName, $locale)
		), $response);
	}

	/**
	 * @Route("/ajaxgeteditablepredefinedrequestlist")
	 */
	public function ajaxgeteditablepredefinedrequestlistAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgeteditablepredefinedrequestlist');
		
		$sort = $request->query->get('sort');
		$dir = $request->query->getAlpha('dir');
		
		// Get the predefined values for the forms
		$schema = $this->get('ginco.schema_listener')->getSchema();
		$locale = $this->get('ginco.locale_listener')->getLocale();
		$predefinedRequestRepository = $this->get('doctrine')->getRepository(PredefinedRequest::class);
		$predefinedRequestList = $predefinedRequestRepository->getEditablePredefinedRequestList($schema, $dir, $sort, $locale, $this->getUser());
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetpredefinedrequestlist.json.twig', array(
			'data' => $predefinedRequestList,
			'user' => $this->getUser()
		), $response);
	}

	/**
	 * @Route("/ajaxgetpredefinedgrouplist")
	 */
	public function ajaxgetpredefinedgrouplistAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetpredefinedgrouplist');
		
		// Get the predefined values for the forms
		$schema = $this->get('ginco.schema_listener')->getSchema();
		$locale = $this->get('ginco.locale_listener')->getLocale();
		$predefinedRequestGroupRepository = $this->get('doctrine')->getRepository(PredefinedRequestGroup::class);
		$predefinedRequestGroupList = $predefinedRequestGroupRepository->getPredefinedRequestGroupList();
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetpredefinedrequestgrouplist.json.twig', array(
			'data' => $predefinedRequestGroupList
		), $response);
	}

	/**
	 * @Route("/predefinedrequest")
	 * @Method("POST")
	 */
	public function createPredefinedrequestAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('createPredefinedrequestAction');
		
		try {
			// Set the function variables
			$r = $request->request;
			$em = $this->getDoctrine()->getManager();
			
			// Check the right
			if ($r->getBoolean('isPublic') === true) {
				if (!$this->getUser()->isAllowed('MANAGE_PUBLIC_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			} elseif ($r->getBoolean('isPublic') === false) {
				if (!$this->getUser()->isAllowed('MANAGE_OWNED_PRIVATE_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			} else {
				throw new \InvalidArgumentException('Invalid arguments.');
			}
			
			// Create the predefined request
			$pr = new PredefinedRequest();
			
			// Edit and add the new data
			$this->get('ginco.query_service')->updatePredefinedRequest($pr, $r->get('datasetId'), $r->get('label'), $r->get('definition'), $r->getBoolean('isPublic'), $this->getUser());
			$this->get('ginco.query_service')->createPRGroupAssociation($pr, $r->getInt('groupId'));
			$this->get('ginco.query_service')->createPRCriteriaAndColumns($pr, $r);
			$em->flush();
			
			return new JsonResponse([
				'success' => true,
				'requestId' => $pr->getRequestId()
			]);
		} catch (UniqueConstraintViolationException $e) {
			$logger->error('Error while creating predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("request.label.existing")
			]);
		} catch (\Exception $e) {
			dump($e);
			$logger->error('Error while creating predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			]);
		}
	}

	/**
	 * @Route("/predefinedrequest/{id}", requirements={"id" = "\d+"}, defaults={"id" = null})
	 * @Method("GET")
	 */
	public function getPredefinedRequestAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('getPredefinedRequestAction');
		
		try {
			// Set the function variables
			$requestId = $request->attributes->getInt('id');
			$r = $request->request;
			$em = $this->getDoctrine()->getManager();
			
			// Get the predefined request information
			$predefinedRequestRepo = $em->getRepository(PredefinedRequest::class);
			$pr = $predefinedRequestRepo->find($requestId);
			$locale = $this->get('ginco.locale_listener')->getLocale();
			$predefinedRequestCriterionRepository = $this->get('doctrine')->getRepository(PredefinedRequestCriterion::class);
			$requestCriteria = $predefinedRequestCriterionRepository->getPredefinedRequestCriteria($requestId, $locale);
			$predefinedRequestColumnRepository = $this->get('doctrine')->getRepository(PredefinedRequestColumn::class);
			$requestColumns = $predefinedRequestColumnRepository->getPredefinedRequestColumns($requestId, $locale);
			
			// Check the right
			if ($pr->getIsPublic() === true) {
				if (!$this->getUser()->isAllowed('MANAGE_PUBLIC_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			} elseif ($pr->getIsPublic() === false) {
				if (!$this->getUser()->isAllowed('MANAGE_OWNED_PRIVATE_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
				if ($this->getUser()->getLogin() !== $pr->getUserLogin()->getLogin()) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			}
			
			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('IgnGincoBundle:Query:getpredefinedrequest.html.twig', array(
				'request' => $pr,
				'criteria' => $requestCriteria,
				'columns' => $requestColumns
			), $response);
		} catch (\Exception $e) {
			$logger->error('Error while requesting predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			]);
		}
	}

	/**
	 * @Route("/predefinedrequest/{id}", requirements={"id" = "\d+"}, defaults={"id" = null})
	 * @Method("PUT")
	 */
	public function editPredefinedrequestAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('editPredefinedrequestAction');
		
		try {
			// Set the function variables
			$requestId = $request->attributes->getInt('id');
			$r = $request->request;
			$em = $this->getDoctrine()->getManager();
			
			// Get the predefined request
			$predefinedRequestRepo = $em->getRepository(PredefinedRequest::class);
			$pr = $predefinedRequestRepo->find($requestId);
			
			// Check the right
			if ($pr->getIsPublic() === true) {
				if (!$this->getUser()->isAllowed('MANAGE_PUBLIC_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			} elseif ($pr->getIsPublic() === false) {
				if (!$this->getUser()->isAllowed('MANAGE_OWNED_PRIVATE_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
				if ($this->getUser()->getLogin() !== $pr->getUserLogin()->getLogin()) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			}
			
			// Delete the old data
			$this->get('ginco.query_service')->deletePRGroupAssociations($pr);
			$this->get('ginco.query_service')->deletePRCriteria($pr);
			$this->get('ginco.query_service')->deletePRColumns($pr);
			$em->flush();
			
			// Edit and add the new data
			$this->get('ginco.query_service')->updatePredefinedRequest($pr, $r->get('datasetId'), $r->get('label'), $r->get('definition'), $r->getBoolean('isPublic'), $this->getUser());
			$this->get('ginco.query_service')->createPRGroupAssociation($pr, $r->getInt('groupId'));
			$this->get('ginco.query_service')->createPRCriteriaAndColumns($pr, $r);
			$em->flush();
			
			return new JsonResponse([
				'success' => true,
				'requestId' => $pr->getRequestId()
			]);
		} catch (UniqueConstraintViolationException $e) {
			$logger->error('Error while creating predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("request.label.existing")
			]);
		} catch (\Exception $e) {
			$logger->error('Error while updating predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			]);
		}
	}

	/**
	 * @Route("/predefinedrequest/{id}", requirements={"id" = "\d+"}, defaults={"id" = null})
	 * @Method("DELETE")
	 */
	public function deletePredefinedrequestAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('deletePredefinedrequestAction');
		
		try {
			// Set the function variables
			$requestId = $request->attributes->getInt('id');
			$em = $this->getDoctrine()->getManager();
			
			// Get the predefined request
			$predefinedRequestRepo = $em->getRepository(PredefinedRequest::class);
			$pr = $predefinedRequestRepo->find($requestId);
			
			// Check the right
			if ($pr->getIsPublic() === true) {
				if (!$this->getUser()->isAllowed('MANAGE_PUBLIC_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			} elseif ($pr->getIsPublic() === false) {
				if (!$this->getUser()->isAllowed('MANAGE_OWNED_PRIVATE_REQUEST')) {
					throw new BadCredentialsException('Invalid credentials.');
				}
				if ($this->getUser()->getLogin() !== $pr->getUserLogin()->getLogin()) {
					throw new BadCredentialsException('Invalid credentials.');
				}
			}
			
			// Delete the old data
			$this->get('ginco.query_service')->deletePRGroupAssociations($pr);
			$this->get('ginco.query_service')->deletePRCriteria($pr);
			$this->get('ginco.query_service')->deletePRColumns($pr);
			$em->remove($pr);
			$em->flush();
			
			return new JsonResponse([
				'success' => true
			]);
		} catch (\Exception $e) {
			$logger->error('Error while deleting predefined request : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			]);
		}
	}
}
