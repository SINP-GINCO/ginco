<?php

require_once __DIR__ . '/Job.php';

/**
 * Class Application_Service_JobManagerService
 *
 * todo: comment this class !!!!!!
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


    public function getProgressPercentage( $jobId ) {

        $stmt = $this->db->prepare(
            "SELECT 100*(progress*1.0/length) AS percentage FROM job_queue WHERE id = ?"
        );
        $stmt->execute(array($jobId));

        $percentage = ($result =$stmt->fetchColumn()) ? $result : 0;
        return $percentage;
    }


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