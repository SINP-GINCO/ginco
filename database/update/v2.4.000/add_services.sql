DELETE FROM metadata.event_listener WHERE listener_id = 'GincoChecksDSRService' ;

INSERT INTO metadata.event_listener (listener_id, classname) VALUES
    ('ChecksOcctaxService', 'fr.ifn.ogam.integration.business.ChecksOcctaxService'),
    ('ChecksStationService', 'fr.ifn.ogam.integration.business.ChecksStationService'),
    ('ChecksHabitatService', 'fr.ifn.ogam.integration.business.ChecksHabitatService')
;