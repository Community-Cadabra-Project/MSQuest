proc _bind_model(@args, @model) {
    if (array_size(@args) > 0) {
        _error('To many arguments')
    }
    include('../binds/bind_loader.ms')
    _log('INFO', 'Binds complete')
}

proc _npc_edit(@args, @model) {
    @modes = array('rm', 'bind', 'unbind', 'create', 'attchange', 'move', 'setbind', 'set')
    if (array_size(@args) == 0) {
        _error("No arguments for npc, @modes")
    }
    @mode = @args[0]
    @sub_args = if (array_size(@args) == 1, array(), @args[1..])
    if (!array_contains(@modes, @mode)) {
        _error("Unknown argument: @mode, possible @modes")
    }
    switch(@mode) {
        case 'rm':
            _npc_edit_rm(@sub_args, @model)
            break();
        case 'unbind':
            _npc_edit_unbind(@sub_args, @model)
            break();
        case 'bind':
            _npc_edit_bind(@sub_args, @model)
            break();
        case 'create':
            _npc_edit_create(@sub_args, @model)
            break();
        case 'attchange':
            _npc_edit_attchange(@sub_args, @model)
            break();
        case 'move':
            _npc_edit_move(@sub_args, @model)
            break();
        case 'setbind':
            _npc_edit_setbind(@sub_args, @model)
            break();
        case 'set':
            _npc_edit_set(@sub_args, @model)
            break();
    }
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
        @uuids = ray_trace()['entities']
        if (!@uuids) {
            _error('No entity found')
        }
        @uuid = @uuids[0]['uuid']
    }
    _method(@model, 'unbindNPC', @id)
    if (_method(@model, 'bindNPC', @id, @uuid)) {
        _log('INFO', "Successful setbind NPC @id")
    } else {
        _log('INFO', "Fail setbind NPC @id")
    }
}

proc _npc_edit_set(@args, @model) {
    if (array_size(@args) == 0) {
        _error('No arguments, must be only id and [json]')
    }
    @id = @args[0]
    @data = array()
    if (array_size(@args) > 1) {
        @json = array_implode(@args[1..])
        try {
            @data = json_decode(@json)
        } catch(FormatException @e) {
            _error(@e['message'])
        } catch (CastException @e) {
            _error(@e['message'])
        }
    }
    @creater = @model['entity']['creater']
    if (array_contains(array_keys(@model['entities']), @id)) {
        @entity = @model['entities'][@id]
        @uuid = _method(@model, 'setNPC', @entity)
        _log('INFO', "Successful set NPC @id - @uuid")
        try {
            _method(@creater, 'change', @uuid, @data)
        } catch(Exception @e) {
            _method(@model, 'removeNPC', @id)
            _error('Delete NPC cause: '.@e['message'])
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

proc _npc_edit_attchange(@args, @model) {
    if (array_size(@args) < 2) {
        _error("Invalid number of arguments, must be id and json")
    }
    @id = @args[0]
    @json = array_implode(@args[1..])
    array @data = array()
    try {
        @data = json_decode(@json)
    } catch(FormatException @e) {
        _error(@e['message'])
    } catch (CastException @e) {
        _error(@e['message'])
    }
    @entity_repo = @model['repo']['entity']
    @creater = @model['entity']['creater']
    if (!(@uuid = _method(@entity_repo, 'getUUID', @id))) {
        _error('This npc doesn\'t exist')
    } else {
        if (!is_entity_living(@uuid)) {
            _error('This npc is dead')
        } else {
            try {
                _method(@creater, 'change', @uuid, @data)
                _log('INFO', "The attributes for @id have been changed")
            } catch(Exception @e) {
                _error(@e['message'])
            }
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
    foreach(@arg in @args) {
        if (_method(@model, 'unbindNPC', @arg)) {
            _log('INFO', "Successful unbind NPC @arg")
        }
    }
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
        @uuids = ray_trace()['entities']
        if (!@uuids) {
            _error('No entity found')
        }
        @uuid = @uuids[0]['uuid']
    }
    if (_method(@model, 'bindNPC', @id, @uuid)) {
        _log('INFO', "Successful bind NPC @id")
    } else {
        _log('INFO', "Fail bind NPC @id")
    }
}

proc _npc_edit_create(@args, @model) {
    if (array_size(@args) == 0) {
        _error('No arguments, must be only id and [json]')
    }
    @id = @args[0]
    @data = array()
    if (array_size(@args) > 1) {
        @json = array_implode(@args[1..])
        try {
            @data = json_decode(@json)
        } catch(FormatException @e) {
            _error(@e['message'])
        } catch (CastException @e) {
            _error(@e['message'])
        }
    }
    @creater = @model['entity']['creater']
    if (array_contains(array_keys(@model['entities']), @id)) {
        @entity = @model['entities'][@id]
        if (@uuid = _method(@model, 'addNPCIfAbsent', @entity)) {
            _log('INFO', "Successful create NPC @id - @uuid")
            try {
                _method(@creater, 'change', @uuid, @data)
            } catch(Exception @e) {
                _method(@model, 'removeNPC', @id)
                _error('Delete NPC cause: '.@e['message'])
            }
        } else {
            _error("This id: @id is already taken")
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
            @modes = array('npc', 'bind', 'stage')
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
            }
        }
    ))
    set_tabcompleter('quest', closure(@alias, @sender, @args, @info) {
    	@input = @args[-1];
    	@completions = array();
    	if(array_size(@args) == 1) {
    		@completions = array('npc', 'stage', 'bind');
    	} else if(array_size(@args) == 2) {
            if (@args[0] == 'npc') {
                @completions = array('setbind', 'bind', 'unbind', 'set', 'create', 'remove', 'move', 'attchange');
            } else if (@args[0] == 'stage') {
                @completions = array('reset');
            } else if (@args[0] == 'bind') {

            }
    	} else if(array_size(@args) == 3) {
            if (@args[0] == 'npc') {
                if (array_contains(array('setbind', 'bind', 'unbind', 'set', 'create', 'remove', 'move', 'attchange'), @args[1])) {
                    @completions = _method(@model['repo']['entity'], 'getAllID');
                }
            } else if (@args[0] == 'stage') {
                if (@args[1] == 'reset') {
                    @completions = all_players()
                    @completions[] = '*'
                }
            }
        } else if (array_size(@args) == 4) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'rm') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~ ~ ~')
                } else if (array_contains(array('bind', 'setbind'), @args[1])) {
                    @completions = all_entities()
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
            }
        } else if (array_size(@args) == 5) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'rm') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~ ~')
                }
            }
        } else if (array_size(@args) == 6) {
            if (@args[0] == 'npc') {
                if (@args[1] == 'rm') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                } else if (@args[1] == 'move') {
                    @completions = array('~')
                }
            }
        } else {
            if (@args[0] == 'npc') {
                if (@args[1] == 'rm') {
                    @completions = _method(@model['repo']['entity'], 'getAllID')
                    foreach(@id in @args[2..]) {
                        array_remove_values(@completions, @id)
                    }
                }
            }
        }
    	return(array_filter(@completions, closure(@key, @value) {
    		return(length(@input) <= length(@value) 
    				&& equals_ic(@input, substr(@value, 0, length(@input))));
    	}));
    });
})