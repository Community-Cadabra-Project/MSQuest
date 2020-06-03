array proc _quest_entities_get_instance() {
    return(import('__QUEST_DOMAIN_ENTITIES_INSTANCE'))
}

array proc _private_quest_entities_init_self() {
    @o = array()
    @o['templates'] = array()
    @o['npc'] = array()
    @o['id'] = array()
    return(@o)
}

proc _package_quest_entities_add_template(array @template) {
    @self = _quest_entities_get_instance()
    array_push(@self['templates'], @template)
    _private_quest_entities_push_id(@template)
}

proc _package_quest_entities_add_npc(array @npc) {
    @self = _quest_entities_get_instance()
    array_push(@self['npc'], @npc)
    _private_quest_entities_push_id(@npc)
}

proc _private_quest_entities_push_id(array @entity) {
    @self = _quest_entities_get_instance()
    if (array_index_exists(@entity, 'id')) {
        array_push(@self['id'], @entity['id'])
    }
}

array proc _package_quest_entities_get_all() {
    @self = _quest_entities_get_instance()
    @arr = array()
    array_push_all(@arr, @self['npc'])
    array_push_all(@arr, @self['template'])
    return(@arr)
}

array proc _package_quest_entities_get_ids() {
    @self = _quest_entities_get_instance()
    return(@self['id'][])
}

export('__QUEST_DOMAIN_ENTITIES_INSTANCE', _private_quest_entities_init_self())