<?php

require_once __DIR__ . '/Job.php';

/**
 * Class Application_Service_JobManagerService
 *
 * A class to manage jobs that can be queued for execution.
 *
 * The list of jobs is in the website.job_queue table.
 * This class writes and reads in this table, and run jobs in the background,
 * using the Job class.
 *
 */
class Application_Service_JobManagerService
{
    const NOTFOUND='NOT FOUND';
    const PENDING='PENDING';
    const RUNNING='RUNNING';
    const COMPLETED='COMPLETED';
    const ERROR='ERROR';
    const ABORTED='ABORTED';

    protected $db = null;

    public function __construct()
    {
        // The database connection
        // todo: the class probably won't work if databases are on different servers
        $this->db = Zend_Registry::get('website_db');

        // Method to run jobs in the background
        Job::setMethod(Job::EXEC_WITH_AT);
        // Job::setMethod(Job::EXEC_AS_BG_PROCESS);
    }

    /**
     * Get the status of the job.
     * If testReallyRunning is false, the status is simply read from job_queue table.
     * If testReallyRunning is false, and if the status read from base is RUNNING,
     *  checks if the job is really running with its pid.
     *
     * @param $jobId
     * @param bool $testReallyRunning
     * @return string
     */
    public function getStatus( $jobId, $testReallyRunning = true ) {

        $stmt = $this->db->prepare(
            "SELECT status, pid FROM job_queue WHERE id = ?"
        );
        $stmt->execute(array($jobId));

        $result = $stmt->fetch();
        $status = ($result) ? $result['status'] : self::NOTFOUND;

        // If RUNNING, check if the process is effectively running
        if ($testReallyRunning && $status == self::RUNNING) {
            $pid = $result['pid'];
            if (!$this->isReallyRunning($jobId,$pid)) {
                $status = self::ABORTED;
            }
        }
        return $status;
    }

    /**
     * Checks if a job is really running as a background progress (with its pid)
     *
     * @param $jobId
     * @param $pid
     * @return bool
     */
    protected function isReallyRunning( $jobId, $pid) {

        if ($this->getStatus($jobId, false) != self::RUNNING) {
            return false;
        }

        if (Job::isRunning($pid)) {
            return true;
        }
        else {
            $stmt = $this->db->prepare(
                "UPDATE job_queue
                     SET status = ?, pid = ?
                     WHERE id = ?;"
            );
            $stmt->execute(array(
                self::ABORTED,
                null,
                $jobId
            ));
            return false;
        }
    }

    /**
     * Get the progress percentage of a job (progress / estimated_length)
     *
     * @param $jobId
     * @return int
     */
    public function getProgressPercentage( $jobId ) {

        $stmt = $this->db->prepare(
            "SELECT 100*(progress*1.0/length) AS percentage FROM job_queue WHERE id = ?"
        );
        $stmt->execute(array($jobId));

        $percentage = ($result =$stmt->fetchColumn()) ? $result : 0;
        return $percentage;
    }

    /**
     * Update the "progress" field of a job
     *
     * @param $jobId
     * @param $progress
     * @return bool
     */
    public function setProgress($jobId, $progress) {
        if ($this->getStatus($jobId) != self::RUNNING) {
            // The task with this id is not RUNNING
            return false;
        }
        // Write progress in db
        $stmt = $this->db->prepare(
            "UPDATE job_queue
             SET progress = ?
             WHERE id = ?;"
        );
        $stmt->execute(array(
            (int) $progress,
            $jobId
        ));
        return true;
    }


    /**
     * Add a job in the job_queue table.
     * The status of the new job is PENDING, its progress 0.
     *
     * @param string $type
     * @param int $length
     * @return int The new line id in job_queue
     */
    public function addJob( $command, $type = null, $length = 100 )
    {
        $stmt = $this->db->prepare(
            "INSERT INTO website.job_queue(command, type, status, length, progress)
             VALUES (?, ?, ?, ?, ?)
             RETURNING id;"
        );
        $stmt->execute(array(
            $command,
            $type,
            self::PENDING,
            $length,
            0
        ));
        $id = $stmt->fetchColumn();
        return $id;
    }

    /**
     * Lauch the job (with the Job class)
     * Update its status to RUNNING.
     *
     * @param $jobId
     * @return bool
     */
    public function runJob( $jobId )
    {
        // The task must exist and have PENDING status.
        // We get the length in seconds to launch the task
        $stmt = $this->db->prepare(
            "SELECT command, status, length FROM job_queue WHERE id = ?"
        );
        $stmt->execute(array($jobId));
        $task = $stmt->fetch();
        if (!$task) {
            return false;
        }

        if ($task['status'] != self::PENDING) {
            return false;
        }
        // Add job_id as a "-j" argument to the command / no space after j, optional arg
        $command = $task['command'] . ' -j' . $jobId;
        $length = $task['length'];

        // Launch task in background
        $pid = Job::exec($command);

        // Write it in db
        $stmt2 = $this->db->prepare(
            "UPDATE job_queue
             SET status = ?, pid = ?
             WHERE id = ?;"
        );
        $stmt2->execute(array(
            self::RUNNING,
            $pid,
            $jobId
        ));
        return true;
    }

    /**
     * Cancel a job.
     * Kill the process if running, and delete the line from job_queue.
     *
     * @param $jobId
     * @return bool
     */
    public function cancelJob( $jobId )
    {
        $status = $this->getStatus($jobId);
        if ( $status == self::NOTFOUND) {
            // No task with this id already exists in db
            return false;
        }

        // If task is RUNNING, we kill the process
        if ($status == self::RUNNING ) {
            $stmt = $this->db->prepare(
                "SELECT pid FROM job_queue WHERE id = ?"
            );
            $stmt->execute(array($jobId));
            $pid = $stmt->fetchColumn();

            // Kill the process
            Job::kill($pid);
        }

        // delete from db
        $stmt = $this->db->prepare(
            "DELETE FROM job_queue
             WHERE id=?;"
        );
        $stmt->execute(array(
            $jobId
        ));
        return true;
    }

    /**
     * Update the status of a job to COMPLETED
     *
     * @param $jobId
     * @return bool
     */
    public function setJobCompleted( $jobId ) {
        $stmt = $this->db->prepare(
            "UPDATE job_queue
             SET status = ?, pid = ?
             WHERE id = ?;"
        );
        $stmt->execute(array(
            self::COMPLETED,
            null,
            $jobId
        ));
        return true;
    }

    /**
     * Returns the next job to run (with status PENDING).
     * Order is given by the created_at field. (FIFO order).
     *
     * @param null $type
     * @return null
     */
    public function nextPendingJob($type = null) {
        if ($type) {
            $stmt = $this->db->prepare(
                "SELECT id FROM job_queue WHERE status = ? AND type = ? ORDER BY created_at ASC LIMIT 1"
            );
            $stmt->execute(array(
                self::PENDING,
                $type
            ));
        }
        else {
            $stmt = $this->db->prepare(
                "SELECT id FROM job_queue WHERE status = ? ORDER BY created_at ASC LIMIT 1"
            );
            $stmt->execute(array(
                self::PENDING
            ));
        }
        $next = ($stmt->fetchColumn()) ?: null;
        return $next;
    }

    /**
     * Return the number of jobs with status RUNNING
     *
     * @param null $type
     * @return int
     */
    public function numberOfRunningJobs($type = null) {
        if ($type) {
            $stmt = $this->db->prepare(
                "SELECT id, pid FROM job_queue WHERE status= ? AND type = ?"
            );
            $stmt->execute(array(
                self::RUNNING,
                $type
            ));
        }
        else {
            $stmt = $this->db->prepare(
                "SELECT id, pid FROM job_queue WHERE status= ?"
            );
            $stmt->execute(array(
                self::RUNNING
            ));
        }

        $running = 0;
        while ($result = $stmt->fetch()) {
            $pid = $result['pid'];
            $jobId = $result['id'];
            if ($this->isReallyRunning($jobId,$pid)) {
                $running++;
            }
        }
        return $running;
    }

}