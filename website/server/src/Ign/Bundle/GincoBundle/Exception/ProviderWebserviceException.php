<?php

namespace Ign\Bundle\GincoBundle\Exception;

/**
 * Class UserUpdaterException
 * Exception occuring when the application can't access or read the
 * INPN authentication webservice.
 *
 * @package Ign\Bundle\GincoBundle\Exception
 */
class ProviderWebserviceException extends \Exception implements IgnGincoBundleExceptionInterface
{
}