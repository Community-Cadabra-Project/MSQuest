array proc _argument_key_val(string @arg, string @del = '=') {
    @index = string_position(@arg, @del)
    if (@index == -1) {
        return(null)
    }
    @key = @arg[cslice(0, @index-1)]
    @val = if((@index == (length(@arg)-1)), '', @arg[cslice(@index+1, -1)])
    return(array(@key, @val))
}

string proc _trace_entity() {
    @uuids = ray_trace()['entities']
    if (!@uuids) {
        _error('No entity found front of you')
    }
    return(@uuids[0]['uuid'])
}

string proc _get_uuid_entity(@arg, @model) {
    @uuid = null
    @entry = _argument_key_val(@arg)
    if (@entry) {
        switch(@entry[0]) {
            case 'id':
                @entity_repo = @model['repo']['entity']
                @id = @entry[1]
                @uuid = _method(@entity_repo, 'getUUID', @id)
                if (!@uuid) {
                    _error("This npc: @id doesn\'t bind")
                } else if (!is_entity_living(@uuid)) {
                    _error("This npc: @id is dead")
                }
            case 'uuid':
                @uuid = @entry[1] 
                if(!is_entity_living(@uuid)) {
                    _error("This npc: @id is dead")
                }
            default:
                _error('Unknown key: '.@entry[0])
        }
    }
    return(@uuid)
}

proc _attrchange_edit(@args, @model) {
    if (array_size(@args) < 1) {
        _error("Invalid number of arguments, must be [id|uuid] and json")
    }
    @uuid = _get_uuid_entity(@args[0], @model)
    @json_start = 0
    if (!@uuid) {
        @uuid = _trace_entity()
    } else {
        if (array_size(@args) < 2) {
            _error('Not found argument: json')
        }
        @json_start = 1
    }
    
    @json = if ((array_size(@args) == @json_start+1), @args[@json_start], array_implode(@args[cslice(@json_start, -1)]))
    msg(@args.' - '.@json_start)
    array @data = array()
    try {
        @data = json_decode(@json)
    } catch(FormatException @e) {
        _error(@e['message'])
    } catch (CastException @e) {
        _error(@e['message'])
    }
    @creater = @model['entity']['creater']
    try {
        _method(@creater, 'change', @uuid, @data)
        _log('INFO', "The attributes for @uuid have been changed")
    } catch(Exception @e) {
        _error(@e['message'])
    }
}

proc _bind_model(@args, @model) {
    if (array_size(@args) > 0) {
        _error('To many arguments')
    }
    include('../binds/bind_loader.ms')
    _log('INFO', 'Binds complete')
}

proc _info(@args, @model) {
    @modes = array('id', 'group', 'uuid')
    if (array_size(@args) < 1) {
        _error("Invalid number of arguments, must be [id|uuid] and 'group'|'id', ...")
    }
    @uuid = _get_uuid_entity(@args[0], @model)
    array @attrs
    if (!@uuid) {
        @uuid = _trace_entity()
        @attrs = @args[0..]
    } else {
        if (array_size(@args) < 2) {
            _error('Not found arguments: \'group\'|\'id\', ...')
        } else {
            @attrs = @args[1..]
        }
    }
    @entity_repo = @model['repo']['entity']
    @group_repo = @model['repo']['group']
    @builder = res_create_resource('STRING_BUILDER')
    string_append(@builder, 'Informations:\n')
    foreach(@mode in @attrs) {
        if (!array_contains(@modes, @mode)) {
            _error("Unknown argument: @mode, possible @modes")
        }
        switch(@mode) {
            case 'id':
                @id = _method(@entity_repo, 'getID', @uuid)
                string_append(@builder, 'ID: ')
                if (@id) {
                    string_append(@builder, @id)
                } else {
                    string_append(@builder, 'not found')
                }
                string_append(@builder, '\n')
                break();
            case 'group':
                @groups = _method(@group_repo, 'getGroups', @uuid)
                string_append(@builder, 'Groups: ')
                if (@groups) {
                    string_append(@builder, array_implode(@groups, ', '))
                } else {
                    string_append(@builder, 'not found')
                }
                string_append(@builder, '\n')
                break();
            case 'uuid':
                string_append(@builder, 'UUID: ')
                string_append(@builder, @uuid)
                string_append(@builder, '\n')
                break();
        }
    }
    _log('INFO', string(@builder))
}

proc _group_edit(@args, @model) {
    @modes = array('remove', 'unbind', 'bind', 'setbind', 'delete')
    if (array_size(@args) == 0) {
        _error("No arguments, possible: @modes")
    }
    @mode = @args[0]
    @sub_args = if (array_size(@args) == 1, array(), @args[1..])
    if (!array_contains(@modes, @mode)) {
        _error("Unknown argument: @mode, possible @modes")
    }
    switch(@mode) {
        case 'remove':
            _group_remove(@sub_args, @model)
            break();
        case 'unbind':
            _group_unbind(@sub_args, @model)
            break();
        case 'bind':
            _group_bind(@sub_args, @model)
            break();
        case 'setbind':
            _group_setbind(@sub_args, @model)
            break();
        case 'delete':
            _group_delete(@sub_args, @model)
            break();
    }
}

proc _group_delete(@args, @model) {
    if (array_size(@args) == 0) {
        @uuid = _trace_entity()
        if (@uuid) {

        } else if (!is_entity_living(@uuid)) {
            _log('WARNING', "This entity: @uuid is dead")
        } else if (_method(@group_repo, 'hasUUID')) {
            @groups = _method(@group_repo, 'getGroups', @uuid)
            _method(@group_repo, 'deleteUUID', @uuid)
            @id = _method(@entity_repo, 'getID', @id)
            if (@id) {
                _log('INFO', "Clear groups: @groups for NPC: @id - @uuid")
            } else {
                _log('INFO', "Clear groups: @groups for entity: @uuid")
            }
        } else {
            _log('WARNING', "This entity: @uuid doesn't have groups")
        }
    }
    @entity_repo = @model['repo']['entity']
    @group_repo = @model['repo']['group']
    foreach(@arg in @args) {
        @entry = _argument_key_val(@arg)
        @key = @entry[0]
        @val = @entry[1]
        switch(@key) {
            case 'id':
                @entity_repo = @model['repo']['entity']
                @id = @entry[1]
                @uuid = _method(@entity_repo, 'getUUID', @id)
                if (!@uuid) {
                    _log('WARNING', "This npc: @id doesn\'t bind")
                } else if (!is_entity_living(@uuid)) {
                    _log('WARNING', "This npc: @id is dead")
                } else if(_method(@group_repo, 'hasUUID', @uuid)) {
                    @groups = _method(@group_repo, 'getGroups', @uuid)
                    _method(@group_repo, 'deleteUUID', @uuid)
                    _log('INFO', "Clear groups: @groups for NPC: @id - @uuid")
                } else {
                    _log('WARNING', "This npc: @id doesn't have groups")
                }
            case 'uuid':
                @uuid = @entry[1] 
                if(!is_entity_living(@uuid)) {
                    _log('WARNING', "This entity: @uuid is dead")
                } else if (_method(@group_repo, 'hasUUID', @uuid)) {
                    @groups = _method(@group_repo, 'getGroups', @uuid)
                    _method(@group_repo, 'deleteUUID', @uuid)
                    @id = _method(@entity_repo, 'getID', @id)
                    if (@id) {
                        _log('INFO', "Clear groups: @groups for NPC: @id - @uuid")
                    } else {
                        _log('INFO', "Clear groups: @groups for entity: @uuid")
                    }
                } else {
                    _log('WARNING', "This entity: @uuid doesn't have groups")
                }
            case 'g':
                if (_method(@group_repo, 'hasGroup', @val)) {
                    @uuids = _method(@model['repo']['group'], 'getUUIDs', @val)
                    @ids = array_map(@uuids, closure(@uuid){return(if((@id=_method(@entity_repo, 'getID', @uuid)), @id, null))})
                    _method(@group_repo, 'deleteGroup', @val)
                    for(@i = 0, @i < array_size(@ids), @i++) {
                        @id = @ids[@i]
                        @uuid = @uuids[@i]
                        if (@id) {
                            _log('INFO', "Delete group: @val of NPC: @id - @uuid")
                        } else {
                            _log('INFO', "Delete group: @val of entity: @uuid")
                        }
                    } else {
                        _log('WARNING', "Group: @val not have entities")
                    }
                } else {
                    _log('WARNING', "Group: @val not have entities")
                }
            default:
                _log('ERROR', 'Unknown key: '.@key)
        }
    }
}

proc _group_remove(@args, @model) {
    if (array_size(@args) == 0) {
        _error('No arguments, possible groups...')
    }
    @entity_repo = @model['repo']['entity']
    foreach(@group in @args) {
        _log('INFO', '### Group: '.@group.' ###')
        @uuids = _method(@model['repo']['group'], 'getUUIDs', @group)
        @ids = array_map(@uuids, closure(@uuid){return(if((@id=_method(@entity_repo, 'getID', @uuid)), @id, null))})
        _method(@model, 'removeGroup', @group)
        for(@i = 0, @i < array_size(@ids), @i++) {
            @id = @ids[@i]
            @uuid = @uuids[@i]
            if (@id) {
                _log('INFO', "Remove NPC: @id - @uuid")
            } else {
                _log('INFO', "Remove entity: @uuid")
            }
        }
    }
}

proc _group_unbind(@args, @model) {
    if (array_size(@args) < 1) {
        _error("Invalid number of arguments, must be [id|uuid] and groups...")
    }
    @uuid = _get_uuid_entity(@args[0], @model)
    @start = 0
    if (!@uuid) {
        @uuid = _trace_entity()
    } else {
        if (array_size(@args) < 2) {
            _error('Not found arguments: groups...')
        }
        @start = 1
    }
    @groups = @args[cslice(@start, -1)]
    @group_repo = @model['repo']['group']
    _method(@group_repo, 'unbindGroups', @uuid, @groups)
    _log('INFO', 'Successful unbind groups: '.@groups)
}

proc _group_bind(@args, @model) {
    if (array_size(@args) < 1) {
        _error("Invalid number of arguments, must be [id|uuid] and groups...")
    }
    @uuid = _get_uuid_entity(@args[0], @model)
    @start = 0
    if (!@uuid) {
        @uuid = _trace_entity()
    } else {
        if (array_size(@args) < 2) {
            _error('Not found arguments: groups...')
        }
        @start = 1
    }
    @groups = @args[cslice(@start, -1)]
    @group_repo = @model['repo']['group']
    _method(@group_repo, 'save', array(@uuid), @groups)
    _log('INFO', 'Successful bind groups: '.@groups)
}

proc _group_setbind(@args, @model) {
    if (array_size(@args) < 1) {
        _error("Invalid number of arguments, must be [id|uuid] and groups...")
    }
    @uuid = _get_uuid_entity(@args[0], @model)
    @start = 0
    if (!@uuid) {
        @uuid = _trace_entity()
    } else {
        if (array_size(@args) < 2) {
            _error('Not found arguments: groups...')
        }
        @start = 1
    }
    @groups = @args[cslice(@start, -1)]
    @group_repo = @model['repo']['group']
    _method(@group_repo, 'deleteUUID', @uuid, false)
    _method(@group_repo, 'save', array(@uuid), @groups)
    _log('INFO', 'Successful bind groups: '.@groups)
}

proc _npc_edit(@args, @model) {
    @modes = array('remove', 'bind', 'unbind', 'create', 'attchange', 'move', 'setbind', 'set')
    if (array_size(@args) == 0) {
        _error("No arguments, possible: @modes")
    }
    @mode = @args[0]
    @sub_args = if (array_size(@args) == 1, array(), @args[1..])
    if (!array_contains(@modes, @mode)) {
        _error("Unknown argument: @mode, possible @modes")
    }
    switch(@mode) {
        case 'remove':
            _npc_edit_rm(@sub_args, @model)
            break();
        case 'create':
            _npc_edit_create(@sub_args, @model)
            break();
        case 'set':
            _npc_edit_set(@sub_args, @model)
            break();
        case 'move':
            _npc_edit_move(@sub_args, @model)
            break();
        case 'setbind':
            _npc_edit_setbind(@sub_args, @model)
            break();
        case 'unbind':
            _npc_edit_unbind(@sub_args, @model)
            break();
        case 'bind':
            _npc_edit_bind(@sub_args, @model)
            break();
    }
}

proc _is_as(@arg) {
    return(@arg == 'as')
}

proc _npc_edit_setbind(@args, @model) {
    if (array_size(@args) > 2) {
        _error('To many arguments, must be only id and [uuid]')
    }
    if (array_size(@args) == 0) {
        _error('No arguments, must be only id and [uuid]')
    }
    @id = @args[0]
    string @uuid
    if (array_size(@args) == 2) {
        @uuid = @args[1]
    } else {
        @uuid = _trace_entity()
    }
    @entity_repo = @model['repo']['entity']
    _method(@entity_repo, 'deleteID', @id, false)
    _method(@entity_repo, 'save', @uuid, @id)
    _log('INFO', "Successful setbind NPC @id")
}

proc _npc_edit_set(@args, @model) {
    if (array_size(@args) < 2) {
        _error('Invalid number of arguments, must be only id [as customID] and [json]')
    }
    @id = @args[0]
    @custom_id = null
    @data = array()
    @json_start = 1
    if (_is_as(@args[1])) {
        if (array_size(@args) < 3) {
            _error('As what? Write your custom id')
        } else {
            @custom_id = @args[2]
            @json_start = 3
        }
    }
    if ((@custom_id && array_size(@args) > 3) || (!@custom_id && array_size(@args) > 1)) {
        @json = if ((array_size(@args) == @json_start+1), @args[@json_start], array_implode(@args[cslice(@json_start, -1)]))
        try {
            @data = json_decode(@json)
        } catch(FormatException @e) {
            _error(@e['message'])
        } catch (CastException @e) {
            _error(@e['message'])
        }
    }
    if (@custom_id) {
        if (array_index_exists(@data, 'main')) {
            @data['main']['id'] = @custom_id
        } else {
            @data['main'] = associative_array()
            @data['main']['id'] = @custom_id
        }
    }
    @creater = @model['entity']['creater']
    if (array_contains(array_keys(@model['entities']), @id)) {
        @entity = @model['entities'][@id]
        @entity = _util_array_deap_push(@entity, @data)
        string @uuid
        @id = @entity['main']['id']
        try {
            @uuid = _method(@model, 'setNPC', @entity)
            _log('INFO', "Successful set NPC @id - @uuid")
        } catch(Exception @e) {
            _error(@e['message'])
        }
    } else {
        _error("Not found entity with id: @id")
    }
}

proc _npc_edit_move(@args, @model) {

    number proc _to_coord(string @arg, string @coord) {
        if (length(@arg) == 1) {
            return(ploc()[@coord])
        }
        if (length(@arg) < 3) {
            throw(FormatException, 'Invalid coordinate format: '.@coord)
        }
        @op = @arg[1]
        @number = double(@arg[2..])
        switch(@op) {
            case '-':
                return(ploc()[@coord] - @number)
            case '+':
                return(ploc()[@coord] + @number)
            default:
                throw(FormatException, "Unknown operand @op at @coord")
        }
    }
    string @id = @args[0]
    number @x
    number @y
    number @z
    try {
        @x = if (@args[1][0] != '~', double(@args[1]), _to_coord(@args[1], 'x'))
        @y = if (@args[2][0] != '~', double(@args[2]), _to_coord(@args[2], 'y'))
        @z = if (@args[3][0] != '~', double(@args[3]), _to_coord(@args[3], 'z'))
    } catch(Exception @e) {
        _error(@e['message'])
    }
    if (array_size(@args) != 4) {
        _error("Invalid number of arguments, must be x, y, z")
    }
    @entity_repo = @model['repo']['entity']
    if (!(@uuid = _method(@entity_repo, 'getUUID', @id))) {
        _error('This npc doesn\'t exist')
    } else {
        if (!is_entity_living(@uuid)) {
            _error('This npc is dead')
        } else {
            @location = entity_loc(@uuid)
            @location['x'] = @x
            @location['y'] = @y
            @location['z'] = @z
            set_entity_loc(@uuid, @location)
        }
    }
}

proc _npc_edit_rm(@args, @model) {
    if (array_size(@args) == 0) {
        @ids = _method(@model['repo']['entity'], 'getAllID')
        _error("No arguments, possible @ids")
    }
    foreach(@arg in @args) {
        if (_method(@model, 'removeNPC', @arg)) {
            _log('INFO', "Removed NPC @arg")
        }
    }
}

proc _npc_edit_unbind(@args, @model) {
    if (array_size(@args) == 0) {
        @ids = _method(@model['repo']['entity'], 'getAllID')
        _error("No arguments, possible @ids")
    }
    @entity_repo = @model['repo']['entity']
    @successful = array()
    @id = @args[0]
    foreach(@arg in @args) {
        if (_method(@entity_repo, 'deleteID', @id, false)) {
            @successful[] = @arg
        }
    }
    _method(@entity_repo, 'write')
    _log('INFO', "Successful unbind NPC @successful")
}

proc _npc_edit_bind(@args, @model) {
    if (array_size(@args) > 2) {
        _error('To many arguments, must be only id and [uuid]')
    }
    if (array_size(@args) == 0) {
        _error('No arguments, must be only id and [uuid]')
    }
    @id = @args[0]
    string @uuid
    if (array_size(@args) == 2) {
        @uuid = @args[1]
    } else {
        @uuid = _trace_entity() 
    }
    @entity_repo = @model['repo']['entity']
    if (!_method(@entity_repo, 'hasID', @id)) {
        _method(@entity_repo, 'save', @uuid, @id)
        _log('INFO', "Successful bind NPC @id")
    } else {
        _log('INFO', "Fail bind, cause @id already taken")
    }
}

proc _npc_edit_create(@args, @model) {
    if (array_size(@args) < 1) {
        _error('No arguments, must be only id [as customID] and [json]')
    }
    @id = @args[0]
    @custom_id = null
    @data = array()
    @json_start = 1
    if (array_size(@args) > 1 && _is_as(@args[1])) {
        if (array_size(@args) < 3) {
            _error('As what? Write your custom id')
        } else {
            @custom_id = @args[2]
            @json_start = 3
        }
    }
    if ((@custom_id && array_size(@args) > 3) || (!@custom_id && array_size(@args) > 1)) {
        @json = if ((array_size(@args) == @json_start+1), @args[@json_start], array_implode(@args[cslice(@json_start, -1)]))
        try {
            msg(@json)
            @data = json_decode(@json)
        } catch(FormatException @e) {
            _error(@e['message'])
        } catch (CastException @e) {
            _error(@e['message'])
        }
    }
    if (@custom_id) {
        if (array_index_exists(@data, 'main')) {
            @data['main']['id'] = @custom_id
        } else {
            @data['main'] = associative_array()
            @data['main']['id'] = @custom_id
        }
    }
    @creater = @model['entity']['creater']
    if (array_contains(array_keys(@model['entities']), @id)) {
        @entity = @model['entities'][@id]
        @entity = _util_array_deap_push(@entity, @data)
        @id = @entity['main']['id']
        try {
            if (@uuid = _method(@model, 'addNPCIfAbsent', @entity)) {
                _log('INFO', "Successful create NPC @id - @uuid")
            } else {
                _error("This id: @id is already taken")
            }
        } catch(Exception @e) {
            console(@e)
            _error(@e['message'])
        }
    } else {
        _error("Not found entity with id: @id")
    }
}

proc _stage_edit(@args, @model) {
    if (array_size(@args) == 0) {
        _error("No arguments, possible 'reset'")
    }
    @mode = @args[0]
    @sub_args = if (array_size(@args) == 1, array(), @args[1..])
    @modes = array('reset')
    if (!array_contains(@modes, @mode)) {
        _error("Unknown argument: @mode, possible 'reset'")
    }
    switch(@mode) {
        case 'reset':
            _stage_edit_reset(@sub_args, @model)
            break();
    }
}

proc _stage_edit_reset(@args, @model) {
    if (array_size(@args) > 2) {
        _error('To many arguments, must be only \'player\' and \'quest\'')
    }
    if (array_size(@args) == 0) {
        _error("No arguments, must be only 'player' and 'quest'")
    }
    @player = @args[0]
    @quest = @args[1]
    if (@player == '*' && @quest == '*') {
        _error('All data cannot be deleted')
    } else if (@player == '*') {
        if (_method(@model['repo']['player'], 'deleteQuest', @quest)) {
            _log('INFO', "Successful delete stages of quest: @quest")
        } else {
            _log('INFO', "Fail delete stages of quest: @quest")
        }
    } else if (@quest == '*') {
        if (_method(@model['repo']['player'], 'deletePlayer', @player)) {
            _log('INFO', "Successful delete stages of player: @player")
        } else {
            _log('INFO', "Fail delete stages of player: @player")
        }
    } else {
        if (_method(@model['repo']['player'], 'delete', @quest, @player)) {
            _log('INFO', "Successful delete stage of quest: @quest, and player: @player")
        } else {
            _log('INFO', "Fail delete stage of quest: @quest, and player: @player")
        }
    }
}

execute(closure() {
    register_command('quest', array(
        'description': 'Quest module control',
        'usage': '/quest',
        'executor': closure() {
            if (array_size(@arguments[2]) == 0) {
                _error('No arguments')
            }
            @args = if(array_size(@arguments[2]) > 1, @arguments[2][1..], array())
            @mode = @arguments[2][0]
            @modes = array('npc', 'bind', 'stage', 'group', 'info', 'attrchange')
            if (!array_contains(@modes, @mode)) {
                _error("Unknown argument: @mode, possible @modes")
            }
            switch(@mode) {
                case 'npc':
                    _npc_edit(@args, @model)
                    break();
                case 'bind':
                    _bind_model(@args, @model)
                    break();
                case 'stage':
                    _stage_edit(@args, @model)
                    break();
                case 'attrchange':
                    _attrchange_edit(@args, @model)
                    break();
                case 'group':
                    _group_edit(@args, @model)
                    break();
                case 'info':
                    _info(@args, @model)
                    break();
            }
        }
    ))
    set_tabcompleter('quest', closure(@alias, @sender, @args, @info) {
    	@input = @args[-1];
    	@completions = array();
    	if(array_size(@args) == 1) {
    		@completions = array('npc', 'stage', 'bind', 'attrchange', 'group', 'info');
    	} else if(array_size(@args) == 2) {
            if (@args[0] == 'npc') {
                @completions = array('setbind', 'bind', 'unbind', 'set', 'create', 'remove', 'move');
            } else if (@args[0] == 'stage') {
                @completions = array('reset');
            } else if (@args[0] == 'info') {
                @completions = array_map(_method(@model['repo']['entity'], 'getAllID'), closure(@v) {return('id='.@v)})
                array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
            } else if (@args[0] == 'attrchange') {
                @completions = array_map(_method(@model['repo']['entity'], 'getAllID'), closure(@v) {return('id='.@v)})
                array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                array_push_all(@completions, array('group', 'id', 'uuid'))
            } else if (@args[0] == 'group') {
                @completions = array('remove', 'bind', 'unbind', 'setbind', 'delete');
            }
    	} else if(array_size(@args) == 3) {
            if (@args[0] == 'npc') {
                if (array_contains(array('setbind', 'bind', 'unbind', 'remove', 'move'), @args[1])) {
                    @completions = _method(@model['repo']['entity'], 'getAllID');
                } else if(array_contains(array('set', 'create'), @args[1])) {
                    @completions = array_keys(@model['entities'])
                }
            } else if (@args[0] == 'stage') {
                if (@args[1] == 'reset') {
                    @completions = all_players()
                    @completions[] = '*'
                }
            } else if (@args[0] == 'group') {
                if (array_contains(array('bind', 'unbind', 'setbind'), @args[1])) {
                    @completions = array_map(_method(@model['repo']['entity'], 'getAllID'), closure(@v) {return('id='.@v)})
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                } else if (@args[1] == 'remove') {
                    @group_repo = @model['repo']['group']
                    @completions = _method(@group_repo, 'getAllGroup')
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                } else if (@args[1] == 'delete') {
                    @group_repo = @model['repo']['group']
                    @entity_repo = @model['repo']['entity']
                    @completions = array_map(_method(@group_repo, 'getAllGroup'), closure(@v) {return('g='.@v)})
                    array_push_all(@completions, array_map(_method(@entity_repo, 'getAllID'), closure(@v) {return('id='.@v)}))
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }
            } else if (@args[0] == 'info') {
                @completions = array('group', 'id', 'uuid')
                foreach(@arg in @args[1..]) {
                    array_remove_values(@completions, @arg)
                }
            }
        } else if (array_size(@args) == 4) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'remove') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~ ~ ~')
                } else if (array_contains(array('bind', 'setbind'), @args[1])) {
                    @completions = all_entities()
                } else if(array_contains(array('set', 'create'), @args[1])) {
                    @completions = array('as')
                }
            } else if (@args[0] == 'stage') {
                if (@args[1] == 'reset') {
                    @players = all_players()
                    @players[] = '*'
                    if (array_contains(@players, @args[2])) {
                        @completions = array_keys(@model['template_progress'])
                        @completions[] = '*'
                    }
                }
            } else if (@args[0] == 'group') {
                if (@args[1] == 'remove') {
                    @group_repo = @model['repo']['group']
                    @completions = _method(@group_repo, 'getAllGroup')
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }  else if (@args[1] == 'delete') {
                    @group_repo = @model['repo']['group']
                    @entity_repo = @model['repo']['entity']
                    @completions = array_map(_method(@group_repo, 'getAllGroup'), closure(@v) {return('g='.@v)})
                    array_push_all(@completions, array_map(_method(@entity_repo, 'getAllID'), closure(@v) {return('id='.@v)}))
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }
            } else if (@args[0] == 'info') {
                @completions = array('group', 'id', 'uuid')
                foreach(@arg in @args[1..]) {
                    array_remove_values(@completions, @arg)
                }
            }
        } else if (array_size(@args) == 5) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'remove') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~ ~')
                } else if(array_contains(array('set', 'create'), @args[1])) {
                    if (@args[3] == 'as') {
                        @completions = array_keys(@model['entities'])
                        array_remove_values(@completions, @args[2])
                    }
                }
            } else if (@args[0] == 'group') {
                if (@args[1] == 'remove') {
                    @group_repo = @model['repo']['group']
                    @completions = _method(@group_repo, 'getAllGroup')
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }  else if (@args[1] == 'delete') {
                    @group_repo = @model['repo']['group']
                    @entity_repo = @model['repo']['entity']
                    @completions = array_map(_method(@group_repo, 'getAllGroup'), closure(@v) {return('g='.@v)})
                    array_push_all(@completions, array_map(_method(@entity_repo, 'getAllID'), closure(@v) {return('id='.@v)}))
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }
            }
        } else if (array_size(@args) == 6) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'remove') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~')
                }
            } else if (@args[0] == 'group') {
                if (@args[1] == 'remove') {
                    @group_repo = @model['repo']['group']
                    @completions = _method(@group_repo, 'getAllGroup')
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }  else if (@args[1] == 'delete') {
                    @group_repo = @model['repo']['group']
                    @entity_repo = @model['repo']['entity']
                    @completions = array_map(_method(@group_repo, 'getAllGroup'), closure(@v) {return('g='.@v)})
                    array_push_all(@completions, array_map(_method(@entity_repo, 'getAllID'), closure(@v) {return('id='.@v)}))
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }
            } else if (@args[0] == 'info') {
                @completions = array('group', 'id', 'uuid')
                foreach(@arg in @args[1..]) {
                    array_remove_values(@completions, @arg)
                }
            }
        } else {
            if (@args[0] == 'npc') {
                if (@args[1] == 'remove') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                }
            } else if (@args[0] == 'group') {
                if (@args[1] == 'remove') {
                    @group_repo = @model['repo']['group']
                    @completions = _method(@group_repo, 'getAllGroup')
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }  else if (@args[1] == 'delete') {
                    @group_repo = @model['repo']['group']
                    @entity_repo = @model['repo']['entity']
                    @completions = array_map(_method(@group_repo, 'getAllGroup'), closure(@v) {return('g='.@v)})
                    array_push_all(@completions, array_map(_method(@entity_repo, 'getAllID'), closure(@v) {return('id='.@v)}))
                    array_push_all(@completions, array_map(all_entities(), closure(@v) {return('uuid='.@v)}))
                    foreach(@arg in @args[2..]) {
                        array_remove_values(@completions, @arg)
                    }
                }
            } else if (@args[0] == 'info') {
                @completions = array('group', 'id', 'uuid')
                foreach(@arg in @args[1..]) {
                    array_remove_values(@completions, @arg)
                }
            }
        }
    	return(array_filter(@completions, closure(@key, @value) {
    		return(length(@input) <= length(@value) 
    				&& equals_ic(@input, substr(@value, 0, length(@input))));
    	}));
    });
})