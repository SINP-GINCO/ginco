UPDATE website.application_parameters SET value='@url.protocol@://@url.domain@@url.basepath@' WHERE name='site_url';

UPDATE mapping.layer_service SET config='{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'   WHERE name='mapProxy';
UPDATE mapping.layer_service SET config='{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}' WHERE name='legend_mapProxy';
UPDATE mapping.layer_service SET config='{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}' WHERE name='Local_MapProxy_WFS_GetFeature';
