<?php

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
 * Represent an export file (export DEE in a gml format).
 *
 * @package Application_Object
 * @subpackage RawData
 */
class Application_Object_Website_ExportFile {

    /**
     * The id.
     *
     * @var int
     */
    var $id;

    /**
     * The job Id (in table job_queue).
     *
     * @var int
     */
    var $jobId;

    /**
     * The login of the user who created the export file
     *
     * @var String
     */
    var $userLogin;

    /**
     * The resulting file name.
     *
     * @var String
     */
    var $fileName;

    /**
     * The file size in bytes.
     *
     * @var int
     */
    var $fileSize;

   /**
     * Timestamp of end of creation of the file
     *
     * @var int
     */
    var $createdAt;
}