<?php
namespace Ign\Bundle\GincoBundle\Tests;

/**
 * @author Gautam Pastakia
 *
 */
interface GincoBaseInterface {

	/**
	 * This function execute SQL scripts needed for specific test.
	 *
	 * @param $adminConn connection
	 *        	to postgres
	 */
	static function executeScripts($adminConn);
}