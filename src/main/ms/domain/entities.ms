array proc _entities_get_instance() {
    return(import('org.cadabra.msquest.entities'))
}

proc _package_entities_add_template(string @file, array @template) {
    @self = _entities_get_instance()
    array_push(@self['entry_templates'], array(file: @file, entity: @template))
    _private_entities_push_id(@template)
}

proc _package_entities_add_npc(string @file, array @npc) {
    @self = _entities_get_instance()
    array_push(@self['entry_npc'],  array(file: @file, entity: @npc))
    _private_entities_push_id(@npc)
}

proc _private_entities_push_id(array @entity) {
    @self = _entities_get_instance()
    if (array_index_exists(@entity, 'id')) {
        array_push(@self['id'], @entity['id'])
    }
}

array proc _package_entities_get_all() {
    @self = _entities_get_instance()
    @arr = array()
    array_push_all(@arr, @self['entry_npc'])
    array_push_all(@arr, @self['entry_template'])
    return(@arr)
}

array proc _package_entities_get_all_npc() {
    @self = _entities_get_instance()
    return(@self['entry_npc'][])
}

array proc _package_entities_get_all_temp() {
    @self = _entities_get_instance()
    return(@self['entry_template'][])
}

array proc _package_entities_get_ids() {
    @self = _entities_get_instance()
    return(@self['id'][])
}

execute(closure() {
    //todo
    export('org.cadabra.msquest.entities', null)
})