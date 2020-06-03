proc _quest_scripts_get_instance() {
    return(import('__QUEST_DOMAIN_SCRIPTS_INSTANCE'))
}

proc _private_quest_scripts_init_self() {
    @o = array()
    return(@o)
}

proc _quest_scripts_add(string @name_scripts) {
    @self = _quest_scripts_get_instance()
    array_push(@self, @name_scripts)
}

proc _quest_scripts_add_all(array @names_scripts) {
    @self = _quest_scripts_get_instance()
    array_push_all(@self, @names_scripts)
}

proc _quest_scripts_get_all(string @name_quest) {
    @self = _quest_scripts_get_instance()
    return(@self[])
}

export('__QUEST_DOMAIN_SCRIPTS_INSTANCE', _private_quest_scripts_init_self())