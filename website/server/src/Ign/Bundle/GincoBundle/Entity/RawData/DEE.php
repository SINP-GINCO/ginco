<?php

namespace Ign\Bundle\GincoBundle\Entity\RawData;

use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\Website\User;

/**
 * DEE
 *
 * @ORM\Table(name="raw_data.dee")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\RawData\DEERepository")
 * @ORM\HasLifecycleCallbacks()
 */
class DEE
{
	const STATUS_NO_DEE = 'NO DEE';
	const STATUS_GENERATING = 'GENERATING';
	const STATUS_OK = 'OK';
	const STATUS_DELETED = 'DELETED';

    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var Jdd
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\RawData\Jdd", inversedBy="dees")
	 * @ORM\JoinColumn(name="jdd_id", referencedColumnName="id")
	 */
    private $jdd;

	/**
	 * The user who has generated the DEE.
	 *
	 * @var User
	 *
	 * @ORM\ManyToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\User")
	 * @ORM\JoinColumn(name="user_login", referencedColumnName="user_login")
	 */
	private $user;

    /**
     * @var string
     *
     * @ORM\Column(name="filePath", type="string", length=500, nullable=true)
     */
    private $filePath;

    /**
     * @var string
     *
     * @ORM\Column(name="status", type="string", length=20)
     */
    private $status = self::STATUS_GENERATING;

    /**
     * @var int
     *
     * @ORM\Column(name="version", type="integer")
     */
    private $version;

    /**
     * @var string
     *
     * @ORM\Column(name="comment", type="text", nullable=true)
     */
    private $comment;

	/**
	 * @var Message
	 *
	 * @ORM\OneToOne(targetEntity="Ign\Bundle\GincoBundle\Entity\Website\Message")
	 * @ORM\JoinColumn(name="message_id", referencedColumnName="id")
	 */
	private $message;

    /**
	 * An array of the submissions ids integrated in the DEE
	 *
     * @var array
     *
     * @ORM\Column(name="submissions", type="simple_array", nullable=true)
     */
    private $submissions ;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="createdAt", type="datetime")
     */
    private $createdAt;



    /**
     * Get id
     *
     * @return integer
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set filePath
     *
     * @param string $filePath
     *
     * @return DEE
     */
    public function setFilePath($filePath)
    {
        $this->filePath = $filePath;

        return $this;
    }

    /**
     * Get filePath
     *
     * @return string
     */
    public function getFilePath()
    {
        return $this->filePath;
    }

    /**
     * Set status
     *
     * @param string $status
     *
     * @return DEE
     */
    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }

    /**
     * Get status
     *
     * @return string
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Set version
     *
     * @param integer $version
     *
     * @return DEE
     */
    public function setVersion($version)
    {
        $this->version = $version;

        return $this;
    }

    /**
     * Get version
     *
     * @return integer
     */
    public function getVersion()
    {
        return $this->version;
    }

    /**
     * Set comment
     *
     * @param string $comment
     *
     * @return DEE
     */
    public function setComment($comment)
    {
        $this->comment = $comment;

        return $this;
    }

    /**
     * Get comment
     *
     * @return string
     */
    public function getComment()
    {
        return $this->comment;
    }

    /**
     * Set submissions
     *
     * @param array $submissions
     *
     * @return DEE
     */
    public function setSubmissions($submissions)
    {
        $this->submissions = $submissions;

        return $this;
    }

    /**
     * Get submissions
     *
     * @return array
     */
    public function getSubmissions()
    {
        return $this->submissions;
    }

	/**
	 * @ORM\PrePersist()
	 */
	public function setCreatedAtNow()
	{
		$this->createdAt = new \DateTime();
	}

	/**
	 * Get createdAt
	 *
	 * @return \DateTime
	 */
	public function getCreatedAt()
	{
		return $this->createdAt;
	}

    /**
     * Set jdd
     *
     * @param \Ign\Bundle\GincoBundle\Entity\RawData\Jdd $jdd
     *
     * @return DEE
     */
    public function setJdd(\Ign\Bundle\GincoBundle\Entity\RawData\Jdd $jdd = null)
    {
        $this->jdd = $jdd;

        return $this;
    }

    /**
     * Get jdd
     *
     * @return \Ign\Bundle\GincoBundle\Entity\RawData\Jdd
     */
    public function getJdd()
    {
        return $this->jdd;
    }

    /**
     * Set user
     *
     * @param \Ign\Bundle\GincoBundle\Entity\Website\User $user
     *
     * @return DEE
     */
    public function setUser(\Ign\Bundle\GincoBundle\Entity\Website\User $user = null)
    {
        $this->user = $user;

        return $this;
    }

    /**
     * Get user
     *
     * @return \Ign\Bundle\GincoBundle\Entity\Website\User
     */
    public function getUser()
    {
        return $this->user;
    }

    /**
     * Set message
     *
     * @param \Ign\Bundle\GincoBundle\Entity\Website\Message $message
     *
     * @return DEE
     */
    public function setMessage(\Ign\Bundle\GincoBundle\Entity\Website\Message $message = null)
    {
        $this->message = $message;

        return $this;
    }

    /**
     * Get message
     *
     * @return \Ign\Bundle\GincoBundle\Entity\Website\Message
     */
    public function getMessage()
    {
        return $this->message;
    }
}
