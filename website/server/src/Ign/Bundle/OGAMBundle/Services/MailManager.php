<?php

namespace Ign\Bundle\OGAMBundle\Services;

/**
 * Class MailManager
 * Sends email from twig templates.
 * The "from" email adress and names are parameters of the service.
 * Can send email with attachments passed as an arry of filepaths.
 *
 * @author SCandelier
 * @package Ign\Bundle\OGAMBundle\Services
 */
class MailManager
{
    /**
     * @var \Swift_Mailer the mailer service
     */
    protected $mailer;

    /**
     * @var \Twig_Environment
     */
    protected $twig;

    /**
     * @var
     */
    protected $logger;

    /**
     * @var string From email address
     */
    protected $fromEmail;

    /**
     * @var string From name
     */
    protected $fromName;

    /**
     * MailManager constructor.
     * @param \Swift_Mailer $mailer
     * @param \Twig_Environment $twig
     * @param  $logger
     * @param $fromEmail
     * @param $fromName
     */
    public function __construct(\Swift_Mailer $mailer, \Twig_Environment $twig, $logger, $fromEmail, $fromName)
    {
        $this->mailer = $mailer;
        $this->twig = $twig;
        $this->logger = $logger;
        $this->fromEmail = $fromEmail;
        $this->fromName = $fromName;
    }

    /**
     * Send email, using an email twig template
	 * The template must have the following bocks:
	 * - subject: the subject of the mail
	 * - body_html: the html part of the mail
	 * - body_text: the text part of the mail (can be empty)
     *
     * @param   string   $template      email template path & name (example: IgnOGAMBundle:Emails:contact.html.twig)
     * @param   mixed    $parameters    custom parameters for template
     * @param   mixed    $to            to email address or array of email addresses
     * @param   mixed    $attachments   local path or array of paths of files to attach to the message
     * @param   string   $from          from email address
     * @param   string   $fromName      from name
     *
     * @return  boolean                 send status
     */
    public function sendEmail($template, $parameters, $to, $attachments = null,  $from = null, $fromName = null)
    {
        $template = $this->twig->loadTemplate($template);

        $parameters = $parameters + array('site_name' => $this->fromName);

        $subject  = $template->renderBlock('subject', $parameters);
        $bodyHtml = $template->renderBlock('body_html', $parameters);
        $bodyText = $template->renderBlock('body_text', $parameters);

        $fromName = ($fromName) ? $fromName : $this->fromName;
        $from = ($from) ? $from : $this->fromEmail;

        $message = \Swift_Message::newInstance()
            ->setSubject($subject)
            ->setFrom($from, $fromName)
            ->setTo($to)
            ->setBody($bodyHtml, 'text/html')
            ->addPart($bodyText, 'text/plain')
        ;

        if ($attachments) {
            if (!is_array($attachments)) {
                $attachments = array($attachments);
            }
            foreach($attachments as $attachment) {
                if (!is_file($attachment)) {
                    throw new \Exception("File '$attachment' does not exist, could not attach it to email.");
                }
                $message->attach(\Swift_Attachment::fromPath($attachment));
            }
        }
        $response = $this->mailer->send($message);
        $this->logger->info("Email sent: " .
            "To: " . implode(',', array_keys($message->getTo())) . ", " .
            "Title: " . $message->getSubject() . ", " .
            ( $attachments ? "Attachments: " . implode(', ', $attachments) : "" )
        );
        return $response;
    }
}