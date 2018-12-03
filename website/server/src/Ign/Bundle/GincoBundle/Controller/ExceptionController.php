<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Log\DebugLoggerInterface;
use Symfony\Component\Debug\Exception\FlattenException;

class ExceptionController extends \Symfony\Bundle\TwigBundle\Controller\ExceptionController {

	/**
	 * Converts an Exception to a Response.
	 *
	 * A "showException" request parameter can be used to force display of an error page (when set to false) or
	 * the exception page (when true). If it is not present, the "debug" value passed into the constructor will
	 * be used.
	 *
	 * @param Request $request
	 *        	The request
	 * @param FlattenException $exception
	 *        	A FlattenException instance
	 * @param DebugLoggerInterface $logger
	 *        	A DebugLoggerInterface instance
	 *
	 * @return Response
	 *
	 * @throws \InvalidArgumentException When the exception template does not exist
	 */
	public function showAction(Request $request, FlattenException $exception, DebugLoggerInterface $logger = null) {
		$currentContent = $this->getAndCleanOutputBuffering($request->headers->get('X-Php-Ob-Level', -1));
		$showException = $request->attributes->get('showException', $this->debug); // As opposed to an additional parameter, this maintains BC

		$code = $exception->getStatusCode();
		$request->setRequestFormat($this->getDefaultFormat($request));

		return new Response($this->twig->render((string) $this->findTemplate($request, $request->getRequestFormat(), $code, $showException), array(
			'status_code' => $code,
			'status_text' => isset(Response::$statusTexts[$code]) ? Response::$statusTexts[$code] : '',
			'exception' => $exception,
			'logger' => $logger,
			'currentContent' => $currentContent
		)));
	}

	/**
	 * return a default format for response
	 * json if isXmlHttpRequest
	 *
	 * @param Request $request
	 * @return string
	 */
	protected function getDefaultFormat(Request $request) {
		if ($request->isXmlHttpRequest()) {
			return 'json';
		}
		return $request->getRequestFormat();
	}
}