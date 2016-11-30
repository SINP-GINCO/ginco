<?php

require_once CUSTOM_APPLICATION_PATH . '/vendor/autoload.php';

/**
 * Class Application_Service_MailerService
 *
 * A mailer service based on SwiftMailer
 * Usage:
 *
 */
class Application_Service_MailerService
{
    const SMTP='smtp1.ign.fr';
    const SMTP_PORT=25;

    const FROM_EMAIL='noreply@ign.fr';

    protected $mailer;
    protected $logger;

    /**
     * Create a mailer element
     */
    public function __construct()
    {
        // Create the Transport
        $transport = Swift_SmtpTransport::newInstance(self::SMTP, self::SMTP_PORT);

        // Create the Mailer using your created Transport
        $this->mailer = Swift_Mailer::newInstance($transport);

        // Initialise the logger
        $this->logger = Zend_Registry::get("logger");
    }

    /**
     * Create and return a simple Swift Message
     * with "from" parameters set to default ones.
     *
     * @param $title
     * @return Swift_Mime_SimpleMessage
     */
    public function newMessage($title) {
        // Get sender name (the platform name)
        $config = Zend_Registry::get('configuration');
        $siteName = $config->getConfig('site_name', 'Plateforme GINCO');

        // Create a message
        $message = Swift_Message::newInstance($title)
            ->setFrom(array(self::FROM_EMAIL => $siteName))
        ;
        return $message;
    }

    /**
     * Send a SwiftMailer Message,
     * except if sending is disabled by configuration
     *
     * @param Swift_Mime_SimpleMessage $message
     */
    public function sendMessage(Swift_Mime_SimpleMessage $message) {
        // Get the "sendEmails" parameter
        $config = Zend_Registry::get('configuration');
        $sendEmail = $config->getConfig('sendEmail', true);

        if ($sendEmail == true ||$sendEmail == "true" || $sendEmail == 1 || $sendEmail == "1") {
            // Really send the message
            try {
                $this->mailer->send($message);
                $this->logger->debug("Email sent: \n" .
                    "To: " . $message->getTo() . "\n" .
                    "Title: " . $message->getSubject() . "\n" .
                    "Body: " . $message->getBody() ."\n"
                );
            }
            catch (Exception $e) {
                $this->logger->debug('Unable to send mail: ' .$e->getMessage());
            }
        } else {
            $this->logger->debug("Email delivery disabled by configuration");
        }
    }

}