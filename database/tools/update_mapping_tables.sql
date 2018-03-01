-- Update instance related parameters in mapping schema

SET search_path = mapping;

-- Update the services

UPDATE layer_service SET config = '{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}' WHERE name = 'mapProxy';
UPDATE layer_service SET config = '{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}' WHERE name = 'legend_mapProxy';
UPDATE layer_service SET config = '{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}' WHERE name = 'Local_MapProxy_WFS_GetFeature';
UPDATE layer_service SET config = '{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}' WHERE name = 'geoportal_wms' ;
UPDATE layer_service SET config = '{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}' WHERE name = 'geoportal_wmts' ;
UPDATE layer_service SET config = '{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}' WHERE name = 'geoportal_wmts_png';
UPDATE layer_service SET config = '{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wfs?"],"params":{"SERVICE":"WFS","VERSION":"1.0.0","REQUEST":"GetFeature", "outputFormat":"json"}}' WHERE name = 'EN_WFS_GetFeature';
UPDATE layer_service SET config = '{"urls":["https://www.geoportail.gouv.fr/depot/layers/"],"params":{}}' WHERE name = 'EN_WMS_Legend';

-- UPDATE all providers data
UPDATE provider_map_params
SET zoom_level = '@bb.zoom@',
  bb_xmin = '@bb.xmin@',
  bb_ymin = '@bb.ymin@',
  bb_xmax = '@bb.xmax@',
  bb_ymax = '@bb.ymax@';

