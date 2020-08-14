boolean proc _has_npc() {
    @api_model = import('org.cadabra.msquest.api')
    return(boolean(@api_model['current']['entity']))
}

string proc _npc_create(array @npc) {
    @model = import('org.cadabra.msquest.api')['main_model']
    _method(@model, 'addNPC', @npc)
}

string proc _get_npc_uuid(string @id = null) {
    @api_model = import('org.cadabra.msquest.api')
    if (@id == null) {
        return(@api_model['current']['entity'])
    }
    @model = @api_model['main_model']
    @entity_repo = @model['repo']['entity']
    return(_method(@entity_repo, 'getUUID', @id))
}

string proc _get_npc_id(string @uuid = null) {
    @api_model = import('org.cadabra.msquest.api')
    if (@uuid == null) {
        @uuid = @api_model['current']['entity']
    }
    @model = @api_model['main_model']
    @entity_repo = @model['repo']['entity']
    return(_method(@entity_repo, 'getID', @uuid))
}

string proc _get_msg(string @key) {
    @api_model = import('org.cadabra.msquest.api')
    @dialog = @api_model['current']['dialog']
    if (!@dialog) {
        throw(NotFoundException, 'Dialog not found')
    }
    string @msg
    if (is_array(@dialog[@key])) {
        @msg = @dialog[@key][rand(array_size(@dialog[@key])-1)]
    } else {
        @msg = @dialog[@key]
    }
    return(@msg)
}

array proc _get_uuids_of_group(string @group) {
    @api_model = import('org.cadabra.msquest.api')
    @model = @api_model['main_model']
    return(_method(@model['repo']['group'], 'getUUIDs', @group))
}

array proc _get_groups_of_uuid(string @uuid) {
    @api_model = import('org.cadabra.msquest.api')
    @model = @api_model['main_model']
    return(_method(@model['repo']['group'], 'getGroups', @group))
}

proc _npc_say_msg(string @msg, string @id = null) {
    @api_model = import('org.cadabra.msquest.api')
    @player = @api_model['current']['player']
    @uuid = _get_npc_uuid(@id)
    if (!@uuid) {
        throw(NotFoundException, 'NPC not found')
    }
    @name = get_mob_name(@uuid)
    broadcast("@name: @msg", array(_get_player()))
}