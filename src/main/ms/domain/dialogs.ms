proc _quest_dialogs_get_instance() {
    return(import('__QUEST_DOMAIN_DIALOGS_INSTANCE'))
}

proc _private_quest_dialogs_init_self() {
    @o = array()
    @o['dialogs'] = array()
    return(@o)
}

proc _quest_dialogs_add(array @dialog) {
    @self = _quest_dialogs_get_instance()
    @self['dialogs'] = @dialog
}

proc _quest_dialogs_get(string @name_quest) {
    @self = _quest_dialogs_get_instance()
    return(@self['dialogs'][@name_quest])
}

export('__QUEST_DOMAIN_DIALOGS_INSTANCE', _private_quest_dialogs_init_self())
