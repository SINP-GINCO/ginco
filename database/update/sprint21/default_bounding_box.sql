-- Bounding box for the every provider - just necessary for the first, but fixes bug in #831
UPDATE mapping.bounding_box SET bb_xmin='@bb.xmin@', bb_ymin='@bb.ymin@', bb_xmax='@bb.xmax@', bb_ymax='@bb.ymax@', zoom_level='@bb.zoom@' WHERE 1=1;


