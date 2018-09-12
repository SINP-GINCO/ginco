UPDATE website.permission SET
    permission_label = 'Modifier son organisme à partir du compte INPN',
    description = 'Modifier son organisme sur le compte INPN.'
    WHERE permission_code = 'MANAGE_OWN_PROVIDER';