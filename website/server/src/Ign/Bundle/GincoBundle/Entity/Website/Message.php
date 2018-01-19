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
	const STATUS_NOTFOUND  = 'NOT FOUND'; // No message with this id
	const STATUS_PENDING   = 'PENDING'; // Queued, waiting to be consumed
	const STATUS_RUNNING   = 'RUNNING'; // Is being consumed
	const STATUS_COMPLETED = 'COMPLETED'; // Has been consumed and terminated normally
	const STATUS_TOCANCEL  = 'TO CANCEL'; // A 'cancel' signal has been sent, the consumer must handle it
	const STATUS_CANCELLED = 'CANCELLED'; // Has been cancelled, the consumer terminated and cancelled the task
	const STATUS_ERROR     = 'ERROR'; // task returned with an error

	const MAX_RETRY = 5; // Max number of times we allow the task to be retried

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
    private $status = 'PENDING';

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
	 *
	 * @var int
	 *   The number of times the message have been sent (can be requeued after temporary error)
	 *
	 * @ORM\Column(name="tries", type="integer")
	 */
	private $tries = 1;

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
	 * If MAX_RETRY is not readched,
	 * Increment tries and set status to PENDING in order to retry to send message.
	 * Else return false.
	 *
	 * @return bool
	 */
	public function retry() {
		if ($this->tries < Self::MAX_RETRY ) {
			$this->tries++;
			$this->status = Self::STATUS_PENDING;
			$this->progress = 0;
			return true;
		}
		return false;
	}

	/**
	 * @return int The number of tries already done
	 */
	public function getTries()
	{
		return $this->tries;
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

