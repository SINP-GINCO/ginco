<?php

namespace Ign\Bundle\GincoBundle\Exception;

/**
 * Class MetadataException
 * Exception occuring when the application can't download or read a metadata file
 * from the INPN website.
 *
 * @package Ign\Bundle\GincoBundle\Exception
 */
class MetadataException extends \Exception implements IgnGincoBundleExceptionInterface
{
}