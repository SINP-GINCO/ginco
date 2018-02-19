INSERT INTO application_parameters (name, value, description) VALUES
  ('CAS_login_url', '@cas.url@login', 'CAS login URL'),
  ('CAS_validation_url', '@cas.url@serviceValidate', 'CAS validation URL'),
  ('CAS_logout_url', '@cas.url@logout', 'CAS logout URL'),
  ('CAS_service_parameter', 'service', 'CAS service parameter'),
  ('CAS_ticket_parameter', 'ticket', 'CAS ticket parameter'),
  ('CAS_xml_namespace', 'cas', 'CAS XML namespace'),
  ('CAS_username_attribute', 'user', 'CAS username attribute'),
  ('INPN_authentication_webservice', '@inpn.auth.webservice.url@', 'Webservice to get the user informations'),
  ('INPN_authentication_login', '@inpn.auth.webservice.login@', 'Authentication for the webservice'),
  ('INPN_authentication_password', '@inpn.auth.webservice.password@', 'Authentication for the webservice'),
  ('INPN_account_url', '@inpn.account.url@', 'INPN "My Account" url');