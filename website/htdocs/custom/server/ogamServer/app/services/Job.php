<?php
/**
 * @name  Job
 * @desc  Exec and manage linux jobs in the background
 *
 * Two methods:
 *
 * $method=EXEC_AS_BG_PROCESS
 *      Exec jobs as background processes.
 *
 * $method=EXEC_WITH_AT
 *      Exec jobs with the at command (http://www.linux-france.org/article/man-fr/man1/at-1.html)
 *      Resists to an apache restart.
 *
 */
class Job {

    const EXEC_AS_BG_PROCESS=1;
    const EXEC_WITH_AT=2;

    protected static $method = self::EXEC_AS_BG_PROCESS;


    public static function getMethod() {
        return self::$method;
    }

    public static function setMethod($method) {
        self::$method = $method;
    }

    /**
     * Run Application in background
     *
     * @param     string $command : linux command
     * @return    $pid: process id of the background process or of the atd daemon parent of the process
     */
    public static function exec($command){

        switch (self::$method) {

            case self::EXEC_AS_BG_PROCESS:
                $pid = shell_exec("$command & echo $!");
                break;

            case self::EXEC_WITH_AT:
                shell_exec('echo "' . addslashes($command) . '" |at now');
                // The pid of the command launched by the shell, launched by the atd daemon
                // (child of child of newest atd daemon)
                $pid = shell_exec('ATDPID=`pgrep --newest atd` && SHPID=`pgrep -P $ATDPID` && pgrep -P $SHPID');
                break;
        }
        return $pid;
    }


    /**
     * Check if the Application is running
     *
     * @param     integer $pid
     * @return    bool
     */
    public static function isRunning($pid){
        exec("ps $pid", $processState);
        return(count($processState) >= 2);
    }

    /**
     * Kill by PID
     *
     * @param  integer $PID
     * @param  boolean $SIGKILL : use a sigkill signal instead of sigterm
     * @return bool
     */
    public static function kill($pid, $SIGKILL=false){
        if (self::isRunning($pid)) {
            if ($SIGKILL) {
                exec("kill -KILL $pid");
            } else {
                exec("kill $pid");
            }
        }
    }
}