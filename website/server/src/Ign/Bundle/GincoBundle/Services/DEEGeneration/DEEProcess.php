<?php
namespace Ign\Bundle\GincoBundle\Services\DEEGeneration;

use Symfony\Bridge\Monolog\Logger;

use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\MailManager;
use Ign\Bundle\GincoBundle\Entity\Metadata\Standard;
use Ign\Bundle\GincoBundle\Services\DEEGeneration\DEEGeneratorOcctax ;
use Ign\Bundle\GincoBundle\Services\DEEGeneration\DEEGeneratorHabitat;


/**
 * Class DEEProcess
 * Responsible of the whole process of the DEE generation and sending:
 *
 * - create file name
 * - generate DEE gml file
 * - create zip archive
 * - send email to the user
 * - send email to the MNHN
 *
 * @package Ign\Bundle\GincoBundle\Services\DEEGeneration
 */
class DEEProcess {

	/**
	 *
	 * @var EntityManager
	 */
	protected $em;

	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 *
	 * @var DEEGeneratorOcctax
	 */
	protected $DEEGeneratorOcctax;
	
	/**
	 *
	 * @var DEEGeneratorHabitat
	 */
	protected $DEEGeneratorHabitat; 

	/**
	 *
	 * @var MailManager
	 */
	protected $mailManager;

	/**
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 * DEEProcess constructor.
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$mailManager
	 * @param
	 *        	$logger
	 */
	public function __construct($em, $configuration, $DEEGeneratorOcctax, $DEEGeneratorHabitat, $mailManager, $logger) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->DEEGeneratorOcctax = $DEEGeneratorOcctax;
		$this->DEEGeneratorHabitat = $DEEGeneratorHabitat;
		$this->mailManager = $mailManager;
		$this->logger = $logger;
	}

	/**
	 * Create an entry in the DEE table
	 * The new DEE still needs to be generated in a file
	 *
	 * @param Jdd $jdd        	
	 * @param User $user        	
	 * @param
	 *        	$comment
	 * @return DEE
	 */
	public function createDEELine(Jdd $jdd, User $user, $comment) {
		
		// Get last version of DEE attached to the jdd
		$deeRepo = $this->em->getRepository('IgnGincoBundle:RawData\DEE');
		$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
		$lastVersion = ($lastDEE) ? $lastDEE->getVersion() : 0;
		
		// Create a new DEE version and attach it to the jdd
		$newDEE = new DEE();
		$newDEE->setJdd($jdd)
			->setVersion($lastVersion + 1)
			->setComment($comment)
			->setUser($user);
		
		// Set submissions ids (validated submissions)
		$submissionIds = array();
		foreach ($jdd->getValidatedSubmissions() as $submission) {
			$submissionIds[] = $submission->getId();
		}
		$newDEE->setSubmissions($submissionIds);
		
		// Persist in db and return the DEE object
		$this->em->persist($newDEE);
		$this->em->flush();
		
		return $newDEE;
	}

	/**
	 * Remove a DEE line from db and generated files if needed
	 * (case where DEE generation is cancelled)
	 *
	 * @param DEE $DEE        	
	 */
	public function deleteDEELineAndFiles($DEEId, $fileName = null) {
		$this->logger->info("deleteDEELineAndFiles: " . implode(',', func_get_args()));
		$DEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneById($DEEId);
		
		// Delete GML archive
		if ($DEE->getFilepath()) {
			$archive = $this->configuration->getConfig('deePublicDirectory') . '/' . pathinfo($DEE->getFilepath(), PATHINFO_BASENAME);
			unlink($archive);
		}
		
		// Delete intermediate files
		if ($fileName) {
			$dir = dirname($fileName);
			if (is_dir($dir)) {
				array_map('unlink', glob("$dir/*"));
				rmdir($dir);
			}
		}
		
		if ($DEE) {
			$this->em->remove($DEE);
			$this->em->flush();
		}
	}

	/**
	 * Refresh message from db and test if status is TO_CANCEL
	 *
	 * @param
	 *        	$message
	 * @return bool
	 */
	protected function messageToCancel($message) {
		if ($message) {
			$this->em->refresh($message);
			if ($message->getStatus() == Message::STATUS_TOCANCEL) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Whole process for generating the DEE and sending notifications to MNHN and INPN
	 *
	 * @param
	 *        	$DEEId
	 * @param null $messageId        	
	 */
	public function generateAndSendDEE($DEEId, $messageId = null, $notifyUser = true) {
		$this->logger->info("GenerateAndSendDEE: " . implode(',', func_get_args()));
		
		// Get all objects and variables
		$DEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneById($DEEId);
		
		$DEEGenerator = null ;
		$standardType = $DEE->getJdd()->getModel()->getStandard()->getName() ;
		if (Standard::STANDARD_OCCTAX == $standardType) {
			$DEEGenerator = $this->DEEGeneratorOcctax ;
		} else if (Standard::STANDARD_HABITAT == $standardType) {
			$DEEGenerator = $this->DEEGeneratorHabitat ;
		}
		
		if ($DEE) {
			// RabbitMQ Message if given
			$message = ($messageId) ? $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId) : null;
			
			// Filepath of the DEE gml file
			$DEEfilePath = $this->generateFilePath($standardType, $DEE);
			
			if (!$this->messageToCancel($message)) {
				// Generate the DEE gml file
				$DEEGenerator->generateDee($DEE, $DEEfilePath, $message);
			}
			
			if (!$this->messageToCancel($message)) {
				// Generate the DEE archive and set the download path of the DEE
				$archiveFileSystemPath = $this->createDEEArchive($DEE, $DEEfilePath);
				$archiveDownloadPath = '/dee/' . pathinfo($archiveFileSystemPath, PATHINFO_BASENAME);
				$DEE->setFilePath($archiveDownloadPath);
			}

			if (!$this->messageToCancel($message)) {

				// Send mail notifications to MNHN and user
				$this->sendDEENotificationMail($DEE, $notifyUser);
				echo "MNHN and User notification (sent to " . $DEE->getUser()->getEmail() . ")...\n";
				// Set final statuses on DEE (only after mail notification cause this is part of the process:
				// if MNHN is not notified, it is like the DEE is not generated)
				$DEE->setStatus(DEE::STATUS_OK);
				$this->em->flush();
			}

			// Cancel message and delete DEE if needed
			if ($this->messageToCancel($message)) {
				$this->deleteDEELineAndFiles($DEE->getId(), $DEEfilePath);
				
				$message->setStatus(Message::STATUS_CANCELLED);
				$this->em->flush();
				echo "Message cancelled... DEE deleted.\n";
			}
		}
	}

	
	/**
	 * Create the file path for DEE file
	 * @param DEE $dee
	 * @return string
	 */
	public function generateFilePath($standardType, DEE $dee) {
		
		if (Standard::STANDARD_OCCTAX == $standardType) {
			return $this->generateFilePathOcctax($dee) ;
		} else if (Standard::STANDARD_HABITAT == $standardType) {
			return $this->generateFilePathHabitat($dee) ;
		}
	}
	
	
	/**
	 * Create the filepath of the DEE gml file
	 *
	 * @param Jdd $jdd        	
	 * @return string
	 */
	private function generateFilePathOcctax(DEE $DEE) {
		$regionCode = $this->configuration->getConfig('regionCode', 'REGION');
		$date = $DEE->getCreatedAt()->format('Y-m-d_H-i-s');
		$jdd = $DEE->getJdd();
		
		$uuid = $jdd->getField('metadataId', $jdd->getId());
		
		$fileNameWithoutExtension = $regionCode . '_' . $date . '_' . $uuid;
		
		$filePath = $this->configuration->getConfig('deePrivateDirectory') . '/' . $fileNameWithoutExtension ;
		
		return $filePath;
	}
	
	/**
	 * Create the file path of DEE for standard habitat
	 * @param DEE $dee
	 * @return string
	 */
	private function generateFilePathHabitat(DEE $dee) {
		
		$now = (new \DateTime())->format("d-m-Y") ;
		$metadataId = $dee->getJdd()->getField('metadataId') ;
		$directory = $this->configuration->getConfig('deePrivateDirectory') ;
		$fileNameWithoutExtension = "SOH1-0_{$now}_{$metadataId}" ;
		return  $directory . DIRECTORY_SEPARATOR . $fileNameWithoutExtension ;
	}

	/**
	 * Create a gzipped archive containing:
	 * - the dee gml file
	 * - informations on the jdd and the dee generation
	 * And put the archive in the "deePublicDirectory" from conf (in the public directory).
	 *
	 * @param
	 *        	$jddId
	 * @param $fileName string
	 *        	file of the DEE
	 * @param
	 *        	$comment
	 * @return string
	 */
	public function createDEEArchive(DEE $DEE, $filePath) {
		// Get fileName without extension
		$fileNameWithoutExtension = basename($filePath) ;
		
		// Public directory to store the archive
		$deePublicDir = $this->configuration->getConfig('deePublicDirectory');
		
		// JDD metadata id
		$jdd = $DEE->getJdd();
		$uuid = $jdd->getField('metadataId', '');
		
		$descriptionFile = $filePath . '/descriptif.txt';
		try {
			$out = fopen($descriptionFile, 'w');
			fwrite($out, "Export DEE pour le jeu de données $uuid \n \n");
			// Todo: rajouter les dates, la version, et l'action (creation, update, delete)
			fwrite($out, "Raisons amenant à une génération ou regénération de la DEE :\n " . stripslashes($DEE->getComment()));
			fclose($out);
		} catch (\Exception $e) {
			throw new DEEException("Could not wite to $descriptionFile: " . $e->getMessage());
		}
		
		// Create an archive of the whole directory
		$parentDir = dirname($filePath); // deePrivateDirectory
		$archiveName = $deePublicDir . '/' . $fileNameWithoutExtension . '.zip';
		try {
			chdir($parentDir);
			system("zip -r $archiveName $fileNameWithoutExtension");
		} catch (\Exception $e) {
			throw new DEEException("Could not create archive $archiveName:" . $e->getMessage());
		}
		// Delete the other files
		unlink($descriptionFile);
		
		// Delete filePath (in deePrivateDirectory)
		$this->rrmdir($filePath);
		
		return $archiveName;
	}

	/**
	 * Deletes a directory.
	 * @param type $src
	 */
	private function rrmdir($src) {
		$dir = opendir($src);
		while(false !== ( $file = readdir($dir)) ) {
			if (( $file != '.' ) && ( $file != '..' )) {
				$full = $src . '/' . $file;
				if ( is_dir($full) ) {
					rrmdir($full);
				}
				else {
					unlink($full);
				}
			}
		}
		closedir($dir);
		rmdir($src);
	}
	
	
	/**
	 * Send two notification emails after creation of the DEE archive:
	 * - one to the MNHN
	 * - one to the user who created the DEE (except if the DEE is being deleted)
	 *
	 * @param DEE $DEE
	 *        	the DEE object
	 */
	public function sendDEENotificationMail(DEE $DEE, $notifyUser = true) {
		$jdd = $DEE->getJdd();
		$user = $DEE->getUser();
		
		// DEE action : create or update
		if ($DEE->getStatus() == DEE::STATUS_DELETED) {
			$action = 'DEE.suppression';
		} else if ($DEE->getVersion() == 1) {
			$action = 'DEE.creation';
		} else {
			$previousDEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneBy(array(
				'jdd' => $jdd,
				'version' => $DEE->getVersion() - 1
			));
			$action = ($previousDEE->getStatus() == DEE::STATUS_DELETED) ? 'DEE.creation' : 'DEE.update';
		}
		
		// Parameters for email notifications
		$parameters = array(
			'action' => $action,
			'region' => $this->configuration->getConfig('regionCode', 'REGION'),
			'metadata_uuid' => $jdd->getField('metadataId'),
			'jdd_title' => $jdd->getField('title'),
			'user' => $user,
			'provider' => $jdd->getProvider(),
			'message' => $DEE->getComment(),
			'created' => $DEE->getCreatedAt()
		);
		
		if ($action != 'DEE.suppression') {
			
			// Submission and submission files in the jdd
			$submissionFilesNames = array();
			$submissionRepo = $this->em->getRepository('IgnGincoBundle:RawData\Submission');
			
			$submissionIds = $DEE->getSubmissions();
			
			foreach ($submissionIds as $submissionId) {
				$submission = $submissionRepo->findOneById($submissionId);
				foreach ($submission->getFiles() as $file) {
					$submissionFilesNames[] = $file->getFileName();
				}
			}
			$fileNames = array_map("basename", $submissionFilesNames);
			
			// Checksum of the DEE archive
			$deePublicDir = $this->configuration->getConfig('deePublicDirectory');
			$fileName = pathinfo($DEE->getFilePath(), PATHINFO_BASENAME);
			$checksum = md5_file($deePublicDir . '/' . $fileName);
			
			$parameters += array(
				'filename' => implode(', ', $fileNames),
				'download_url' => $this->configuration->getConfig('site_url') . $DEE->getFilePath(),
				'checksum' => $checksum
			);
		}
		
		// Send mail notification to MNHN
		$this->mailManager->sendEmail('IgnGincoBundle:Emails:DEE-notification-to-MNHN.html.twig', $parameters, $this->configuration->getConfig('deeNotificationMail', 'sinp-dev@ign.fr'));

		// Send mail notification to user
		if ($action != 'DEE.suppression' && $notifyUser && !empty($user->getEmail())) {
			$this->mailManager->sendEmail('IgnGincoBundle:Emails:DEE-notification-to-user.html.twig', $parameters, $user->getEmail());
		}
	}
}