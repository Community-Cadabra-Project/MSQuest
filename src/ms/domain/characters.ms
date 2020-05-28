proc _quest_characters_get_instance() {
    return(import('__QUEST_DOMAIN_CHARACTERS_INSTANCE'))
}

proc _private_quest_characters_init_self() {
    @o = array()
    @o['characters'] = array()
    return(@o)
}

proc _quest_characters_add(array @character) {
    @self = _quest_characters_get_instance()
    array_push(@self['characters'], @character)
}

proc _quest_characters_save(string @path) {
    @self = _quest_characters_get_instance()
}

proc _private_quest_characters_check(array @character) {
    @self = _quest_characters_get_instance()
    
}

export('__QUEST_DOMAIN_CHARACTERS_INSTANCE', _private_quest_characters_init_self())