-- This table is added following new handling system for integration service (See #1059)

SET search_path TO metadata;
/*==============================================================*/
/* Table : EVENT_LISTENER                                       */
/*==============================================================*/
CREATE TABLE event_listener
(
  listener_id character varying(50) NOT NULL,
  classname character varying(255),
  _creationdt timestamp without time zone DEFAULT now(),
  CONSTRAINT pk_event_listener PRIMARY KEY (listener_id)
)
WITH (
  OIDS=FALSE
);

COMMENT ON COLUMN event_listener.listener_id IS 'The name/identifier of the post-processing treatment';
COMMENT ON COLUMN event_listener.classname IS 'The fully qualified name of the listener (Ex : fr.ifn.ogam.integration.business.SimpleEventLogger)';
COMMENT ON COLUMN event_listener._creationdt IS 'The creation date';

GRANT SELECT ON TABLE event_listener TO ogam;

INSERT INTO metadata.event_listener(listener_id, classname) VALUES
('GincoComputeGeoAssociationService', 'fr.ifn.ogam.integration.business.ComputeGeoAssociationService'),
('GincoChecksDSRService', 'fr.ifn.ogam.integration.business.ChecksDSRGincoService');