UPDATE mapping.layer SET
    service_layer_name = 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES:rnr'
    WHERE name = 'PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS' 
;

UPDATE mapping.layer SET
    service_layer_name = 'PROTECTEDAREAS.RNCF:rncfs_fxx'
    WHERE name = 'PROTECTEDAREAS_RNCF_WFS'
;

UPDATE mapping.layer SET
    service_layer_name = 'PROTECTEDAREAS.RNC:rnc'
    WHERE name = 'PROTECTEDAREAS_RNC_WFS'
;

UPDATE mapping.layer SET
    service_layer_name = 'PROTECTEDAREAS.BIOS:bios'
    WHERE name = 'PROTECTEDAREAS_BIOS_WFS'
;