proc _dialogs_get_instance() {
    return(import('org.cadabra.msquest.dialogs'))
}

proc _private_dialogs_init_self() {
    @o = array()
    @o['dialogs'] = array()
    return(@o)
}

proc _dialogs_add(array @dialog) {
    @self = _dialogs_get_instance()
    @self['dialogs'] = @dialog
}

proc _dialogs_get(string @name) {
    @self = _dialogs_get_instance()
    return(@self['dialogs'][@name])
}

export('org.cadabra.msquest.dialogs', _private_dialogs_init_self())
