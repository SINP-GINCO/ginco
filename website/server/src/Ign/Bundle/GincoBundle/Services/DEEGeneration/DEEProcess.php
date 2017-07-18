<?php
namespace Ign\Bundle\GincoBundle\Services\DEEGeneration;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;
use Ign\Bundle\OGAMBundle\Services\MailManager;
use Symfony\Bridge\Monolog\Logger;

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
	 * @var EntityManager
	 */
	protected $em;
	
	/**
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 * @var DEEGenerator
	 */
	protected $DEEGenerator;

	/**
	 * @var MailManager
	 */
	protected $mailManager;

	/**
	 * @var Logger
	 */
	protected $logger;

	/**
	 * DEEProcess constructor.
	 * @param $em
	 * @param $configuration
	 * @param $mailManager
	 * @param $logger
	 */
	public function __construct($em, $configuration, $DEEGenerator, $mailManager, $logger) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->DEEGenerator = $DEEGenerator;
		$this->mailManager = $mailManager;
		$this->logger = $logger;
	}

	/**
	 * Create an entry in the DEE table
	 * The new DEE still needs to be generated in a file
	 *
	 * @param Jdd $jdd
	 * @param User $user
	 * @param $comment
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


	public function generateAndSendDEE($DEEId, $messageId = null) {

		$this->logger->info("GenerateAndSendDEE: " . implode(',', func_get_args()));

		// Get all objects and variables
		$DEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneById($DEEId);

		if ($DEE) {
			$jdd = $DEE->getJdd();

			// RabbitMQ Message if given
			$message = ($messageId) ? $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId) : null;

			// Filepath of the DEE gml file
			$DEEfilePath = $this->generateFilePath($DEE);

			// Generate the DEE gml file
			$this->DEEGenerator->generateDeeGml($DEE, $DEEfilePath, $message);

			// Generate the DEE archive and set the download path of the DEE
			$archiveFileSystemPath = $this->createDEEArchive($DEE, $DEEfilePath);
			$archiveDownloadPath =  '/dee/' . pathinfo($archiveFileSystemPath, PATHINFO_BASENAME);
			$DEE->setFilePath($archiveDownloadPath);

			// Report message status if not null
			if ($message) {
				$message->setStatus(Message::STATUS_COMPLETED);
			}

			// Set final statuses on DEE
			$DEE->setStatus(DEE::STATUS_OK);
			$this->em->flush();

			// Send mail notifications to MNHN and user
			$this->sendDEENotificationMail($DEE);
		}
	}


	/**
	 * Create the filepath of the DEE gml file
	 *
	 * @param Jdd $jdd
	 * @return string
	 */
    public function generateFilePath(DEE $DEE) {
        $regionCode = $this->configuration->getConfig('regionCode','REGION');
        $date = $DEE->getCreatedAt()->format('Y-m-d_H-i-s');
		$jdd = $DEE->getJdd();

		$uuid = $jdd->getField('metadataId', $jdd->getId());

        $fileNameWithoutExtension = $regionCode . '_' . $date . '_' . $uuid ;

        $filePath = $this->configuration->getConfig('deePrivateDirectory') . '/' . $fileNameWithoutExtension . '/';
        $filename = $fileNameWithoutExtension . '.xml';

        return $filePath . $filename ;
    }


	/**
	 * Create a gzipped archive containing:
	 * - the dee gml file
	 * - informations on the jdd and the dee generation
	 * And put the archive in the "deePublicDirectory" from conf (in the public directory).
	 *
	 * @param $jddId
	 * @param $fileName string file of the DEE
	 * @param $comment
	 * @return string
	 */
	public function createDEEArchive(DEE $DEE, $fileName)
	{
		// Get fileName without extension
		$filePath = pathinfo($fileName, PATHINFO_DIRNAME);
		$fileNameWithoutExtension = pathinfo($fileName, PATHINFO_FILENAME);

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
		}
		catch (\Exception $e) {
			throw new DEEException("Could not wite to $descriptionFile: " . $e->getMessage());
		}

		// Create an archive of the whole directory
		$parentDir = dirname($filePath); // deePrivateDirectory
		$archiveName = $deePublicDir . '/' . $fileNameWithoutExtension . '.zip';
		try {
			chdir($parentDir);
			system("zip -r $archiveName $fileNameWithoutExtension");
		}
		catch (\Exception $e) {
			throw new DEEException("Could not create archive $archiveName:" . $e->getMessage());
		}
		// Delete the other files
		unlink($descriptionFile);

		return $archiveName;
	}


	/**
	 * Send two notification emails after creation of the DEE archive:
	 *  - one to the MNHN
	 *  - one to the user who created the DEE (except if the DEE is being deleted)
	 *
	 * @param DEE $DEE the DEE object
	 */
	public function sendDEENotificationMail(DEE $DEE) {

		$jdd = $DEE->getJdd();
		$user = $DEE->getUser();

		// DEE action : create or update
		if ($DEE->getStatus() == DEE::STATUS_DELETED) {
			$action = 'Suppression';
		} else if ($DEE->getVersion() == 1) {
			$action = 'Création';
		} else {
			$previousDEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneBy(array(
					'jdd' => $jdd,
					'version' => $DEE->getVersion() - 1
				)
			);
			$action = ($previousDEE->getStatus() == DEE::STATUS_DELETED) ? 'Création' : 'Mise à jour';
		}


		// Parameters for email notifications
		$parameters = array(
			'action' => $action,
			'region' => $this->configuration->getConfig('regionCode','REGION'),
			'metadata_uuid' => $jdd->getField('metadataId'),
			'jdd_title' => $jdd->getField('title'),
			'user' => $user,
			'provider' => $jdd->getProvider(),
			'message' => $DEE->getComment(),
			'created' => $DEE->getCreatedAt(),
		);

		if ($action != 'Suppression') {

			// Submission and submission files in the jdd
			$submissionFilesNames = array();
			$submissionRepo = $this->em->getRepository('OGAMBundle:RawData\Submission');

			$submissionIds = $DEE->getSubmissions();

			foreach ($submissionIds as $submissionId) {
				$submission = $submissionRepo->findOneById($submissionId);
				foreach	( $submission->getFiles() as $file ) {
					$submissionFilesNames[] = $file->getFileName();
				}
			}
			$fileNames = array_map("basename",$submissionFilesNames);

			// Checksum of the DEE archive
			$deePublicDir = $this->configuration->getConfig('deePublicDirectory');
			$fileName = pathinfo($DEE->getFilePath(), PATHINFO_BASENAME);
			$checksum = md5_file($deePublicDir . '/' . $fileName);

			$parameters += array(
				'filename' => implode(', ',$fileNames),
				'download_url' => $this->configuration->getConfig('site_url') . $DEE->getFilePath(),
				'checksum' => $checksum,
			);
		}

		// Send mail notification to MNHN
		$this->mailManager->sendEmail(
			'IgnGincoBundle:Emails:DEE-notification-to-MNHN.html.twig',
			$parameters,
			$this->configuration->getConfig('deeNotificationMail','sinp-dev@ign.fr')
		);

		// Send mail notification to user
		if ($action != 'Suppression') {
			$this->mailManager->sendEmail(
				'IgnGincoBundle:Emails:DEE-notification-to-user.html.twig',
				$parameters,
				$user->getEmail()
			);
		}
	}

}