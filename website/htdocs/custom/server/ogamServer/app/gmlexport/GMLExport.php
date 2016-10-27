<?php

require_once CUSTOM_APPLICATION_PATH . '/gmlexport/vendor/autoload.php';
require_once CUSTOM_APPLICATION_PATH . '/gmlexport/DEEModel.php';
require_once CUSTOM_APPLICATION_PATH . '/services/JobManagerService.php';

class GMLExport
{
    protected $twig;
    protected $dee;
    protected $gmlId;

    public function __construct()
    {

        // Instantiate DEEModel
        $this->dee = new DEEModel();

        // Instantiate twig
        $loader = new Twig_Loader_Filesystem(CUSTOM_APPLICATION_PATH . '/gmlexport/templates');
        $this->twig = new Twig_Environment($loader, array(
            // 'cache' => CUSTOM_APPLICATION_PATH . '/gmlexport/templates/cache',
            'cache' => false,
            'debug' => true,
        ));
        $this->twig->addExtension(new Twig_Extension_Debug());

        // gmlId is generated as a sequence of integer
        $this->gmlId = 1;

    }

    /**
     * Generate the gml for the DEE
     * and write it to a stream ($out): file or php standard output.
     *
     * @param $observations
     * @param $out: stream ($out= fopen($filename,'w') or $out = fopen('php://output', 'w') )
     * @param int|null $jobId : job id in the job_queue table. If not null, the function will write its progress in the job_queue table.
     * @param array $params : associative id of parameters
     */
    public function generateGML($observations, $out, $jobId = null, $params = null)
    {
        // Job Manager
        if ($jobId) {
            $jobManager = new Application_Service_JobManagerService();
        }

        // Generate Group of observations (identified by "identifiantregroupementpermanent")
        $groups = $this->dee->groupObservations($observations);

        // (Re)start gmlId for each file
        $this->gmlId = 1;

        // Header and root opening tag
        fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->generateHeader()));

        // Write groups
        foreach ($groups as $group) {
            fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->generateRegroupement($group['attributes'])));
        }

        // Write Observations
        foreach ($observations as $index => $observation) {
            $observation = $this->dee->formatDates($observation);
            $observation = $this->dee->transformCodes($observation);
            $observation = $this->dee->fillValues($observation, array(
                'orgtransformation' => (isset($params['site_name']) ? $params['site_name'] : 'Plateforme GINCO-SINP')
            ));
            $observation = $this->dee->specialCharsXML($observation);
            $observation = $this->dee->structureObservation($observation);

            fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->generateObservation($observation)));

            // todo: setProgress every 100 or 1000 lines
            if ($jobId) {
                $jobManager->setProgress($jobId, $index+1);
                // uncomment to see process runnning.. slowly
                // sleep(1);
            }

        }

        // root closing tag
        fwrite($out, $this->generateEnd());
    }

    protected function generateHeader()
    {
        $part = $this->twig->render('header.xml');
        return $part;
    }

    protected function generateEnd()
    {
        $part = $this->twig->render('end.xml');
        return $part;
    }

    protected function generateRegroupement($group)
    {
        $part = $this->twig->render('regroupement.xml.twig', array('regroupement' => $group));
        return $part;
    }

    protected function generateObservation($observation)
    {
        $part = $this->twig->render('sujet_observation.xml.twig', array('observation' => $observation));
        return $part;
    }

    /**
     * Replaces all occurences of the string $needle
     * by a sequence of integers starting at $this->gmlId
     * Ex : "#NEEDLE#, #NEEDLE# and #NEEDLE#" => "1, 2 and 3"
     * http://codepad.org/BjVwEy8u
     *
     * @param str $needle
     * @param str $str
     * @return str
     */
    protected function strReplaceBySequence($needle, $str)
    {

        while (($pos = strpos($str, $needle)) !== false) {
            $str = substr_replace($str, $this->gmlId, $pos, strlen($needle));
            $this->gmlId++;
        }

        return $str;
    }

}