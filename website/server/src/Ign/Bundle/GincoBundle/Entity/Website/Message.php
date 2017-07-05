<?php

namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * Message
 *
 * @ORM\Table(name="website.messages")
 * @ORM\Entity
 * @ORM\HasLifecycleCallbacks()
 */
class Message
{
    /**
     * @var integer
	 *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string
	 * Type of action to run
     *
     * @ORM\Column(name="action", type="string", length=50)
     */
    private $action;

    /**
     * @var string
     * Parameters of the action, encoded as a json string
	 *
     * @ORM\Column(name="parameters", type="json_array", nullable=true)
     */
    private $parameters;

    /**
     * @var string
     *
     * @ORM\Column(name="status", type="string", length=20)
     */
    private $status = 'QUEUED';

    /**
     * @var int
     *
     * @ORM\Column(name="length", type="integer", nullable=true)
     */
    private $length = 0;

    /**
     * @var int
     *
     * @ORM\Column(name="progress", type="integer", nullable=true)
     */
    private $progress = 0;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="created_at", type="datetime")
     */
    private $createdAt;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="updated_at", type="datetime")
     */
    private $updatedAt;


    /**
     * Get id
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set action
     *
     * @param string $action
     *
     * @return Message
     */
    public function setAction($action)
    {
        $this->action = $action;

        return $this;
    }

    /**
     * Get action
     *
     * @return string
     */
    public function getAction()
    {
        return $this->action;
    }

    /**
     * Set parameters
     *
     * @param string $parameters
     *
     * @return Message
     */
    public function setParameters($parameters)
    {
        $this->parameters = $parameters;

        return $this;
    }

    /**
     * Get parameters
     *
     * @return string
     */
    public function getParameters()
    {
        return $this->parameters;
    }

    /**
     * Set status
     *
     * @param string $status
     *
     * @return Message
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
     * Set length
     *
     * @param integer $length
     *
     * @return Message
     */
    public function setLength($length)
    {
        $this->length = $length;

        return $this;
    }

    /**
     * Get length
     *
     * @return int
     */
    public function getLength()
    {
        return $this->length;
    }

    /**
     * Set progress
     *
     * @param integer $progress
     *
     * @return Message
     */
    public function setProgress($progress)
    {
        $this->progress = $progress;

        return $this;
    }

    /**
     * Get absolute progress
     *
     * @return int
     */
    public function getProgress()
    {
        return $this->progress;
    }

	/**
	 * Get progress as a percentage
	 *
	 * @return float|int
	 */
    public function getProgressPercentage()
	{
		return intval($this->length) > 0 ? $this->progress*100.0/$this->length : 0;
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
	 * @ORM\PrePersist()
	 * @ORM\PreUpdate()
	 */
    public function setUpdatedAtNow()
    {
		$this->updatedAt = new \DateTime();
    }

    /**
     * Get updated
     *
     * @return \DateTime
     */
    public function getUpdatedAt()
    {
        return $this->updatedAt;
    }
}

