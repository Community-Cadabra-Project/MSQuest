proc _scripts_get_instance() {
    return(import('org.cadabra.msquest.scripts'))
}

proc _private_scripts_init_self() {
    @o = array()
    return(@o)
}

proc _scripts_add(string @name_scripts) {
    @self = _scripts_get_instance()
    array_push(@self, @name_scripts)
}

proc _scripts_add_all(array @names_scripts) {
    @self = _scripts_get_instance()
    array_push_all(@self, @names_scripts)
}

proc _scripts_get_all(string @name) {
    @self = _scripts_get_instance()
    return(@self[])
}

export('org.cadabra.msquest.scripts', _private_scripts_init_self())