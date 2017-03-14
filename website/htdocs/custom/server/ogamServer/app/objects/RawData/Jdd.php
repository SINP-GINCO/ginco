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
 * Represents a jdd (dataset representation for Ginco project).
 *
 * @package Application_Object
 * @subpackage RawData
 */
class Application_Object_RawData_Jdd {

	/**
	 * The technical id.
	 *
	 * @var int
	 */
	var $id;

	/**
	 * The jdd metadata id (uuid checked and present on the national platform).
	 *
	 * @var String
	 */
	var $jddMetadataId;

	/**
	 * Title of the jdd, from the metadata
	 *
	 * @var String
	 */
	var $title;

	/**
	 * The status (can be empty, active or supressed) of the jdd
	 *
	 * @var String
	 */
	var $status;

	/**
	 * The model id (linked to the jdd, foreign key).
	 *
	 * @var String
	 */
	var $modelId;

	/**
	 * Timestamp of the creation of the jdd.
	 *
	 * @var Date
	 */
	var $createdAt;

	/**
	 * Timestamp of the last edition of the DSR.
	 *
	 * @var Date
	 */
	var $dsrUpdatedAt;

	/**
	 * The submission Id.
	 *
	 * @var int
	 */
	var $submissionId;

	/**
	 * The id of the export file.
	 *
	 * @var String
	 */
	var $exportFileId;
}