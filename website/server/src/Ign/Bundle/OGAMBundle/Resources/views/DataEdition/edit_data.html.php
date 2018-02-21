<?php
/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */


/**
 * View for the creation of a new data.
 * @package views
 */
?>
[
<?php
$patch = array(
    'xclass' => 'OgamDesktop.view.edition.Panel'
);

// Unique identifier of the data
$patch['dataId'] = $dataId;
// mode
$patch['mode'] = $mode;

// message
if (! empty($message)) {
    $patch['message'] = $message;
}

// parentsLinks
if (! empty($ancestors)) {
    $parentsLinks = array();
    foreach (array_reverse($ancestors) as $ancestor) {
        $parentsLinks[] = $view['dataEditionEdit']->getEditLink($ancestor);
    }
    $patch['parentsLinks'] = $parentsLinks;
}

// dataTitle
$patch['dataTitle'] = $view->escape($tableFormat->getLabel());

// disableDeleteButton
$childCount = 0;
foreach ($children as $childTable) {
    $childCount += count($childTable);
}

$patch['disableDeleteButton'] = ($childCount > 0);

// childrenConfigOptions
$childrenConfigOptions = array();
foreach ($childrenTableLabels as $childFormat => $childTableLabel) {
    $configOptions = array();
    // $configOptions['buttonAlign'] = 'center';
    $configOptions['title'] = $view->escape($childTableLabel);
    
    // Add the edit links for each child of the current item
    $childrenLinks = array();
    if (! empty($children)) {
        foreach ($children[$childFormat] as $child) {
            $childrenLinks[] = $view['dataEditionEdit']->getEditLink($child);
        }
        $configOptions['childrenLinks'] = $childrenLinks;
    }
    if (empty($childrenLinks)) {
        $content = $view['translator']->trans('No %value% found.');
        $configOptions['html'] = str_replace('%value%', strtolower($view->escape($childTableLabel)), $content);
    }
    
    // Add link to a new child
    $configOptions['AddChildURL'] = $view['dataEditionAdd']->getAddLink($data->getTableFormat()->getSchemaCode(), $childFormat, $data->getIdFields());
    
    array_push($childrenConfigOptions, $configOptions);
}
$patch['childrenConfigOptions'] = $childrenConfigOptions;

echo json_encode($patch);
?>
 ]