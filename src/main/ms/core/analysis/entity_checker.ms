/*
Exceptions:
- yml_exception
    args: {}
- unknown_key_exception
    args: {}
- key_not_found_exception
    args: {}
- type_undefined_exception
*/

proc _private_quest_entity_checker_name() {
    return('__QUEST_ENTITY_CHECKER')
}

proc _package_quest_entity_checker_import() {
    return(import(_private_quest_entity_checker_name()))
}

proc _package_quest_entity_checker_successful() {
    return(_package_quest_entity_checker_import()['successful'])
}

proc _package_quest_entity_checker_get_global() {
    return(_package_quest_entity_checker_import()['templates']['global'])
}

proc _package_quest_entity_checker_get_spec() {
    return(_package_quest_entity_checker_import()['templates']['spec'])
}

proc _package_quest_entity_checker_get_entity() {
    return(_package_quest_entity_checker_import()['templates']['entity'])
}

proc _package_quest_entity_checker_get_mob() {
    return(_package_quest_entity_checker_import()['templates']['mob'])
}

proc _private_quest_entity_checker_get_env() {
    return(_package_quest_entity_checker_import()['env'])
}

proc _private_quest_entity_checker_get_commander() {
    return(_package_quest_entity_checker_import()['commander'])
}

string proc _quest_entity_analys(array @entries, string @root = '') {
    int @cslice = length(@root) + 1
    @builder = res_create_resource('STRING_BUILDER')
    @res = true;
    foreach(@entry in @entries) {
        @is_npc = @entry['is_npc']
        @path = @entry['path']

        @info = _package_quest_entity_checker(@path, @is_npc)
        if (array_size(@info['exceptions']) != 0) {
            @res = false
        } else {
            continue()
        }
        string_append(@builder, '\n')
        string_append(@builder, 'Entity at: ')
        string_append(@builder, @info['id'][cslice(@cslice, -1)])
        foreach(@attr: @e in @info['exceptions']) {
            string_append(@builder, '\n- attribute: ')
            string_append(@builder, @attr)
            string_append(@builder, '\n\t')
            string_append(@builder, _quest_parse_exception(@e))
            string_append(@builder, '\n')
        }
    }
    return(if(@res, null, string(@builder)))
}

array proc _package_quest_entity_checker(string @path_to_entity, boolean @is_npc) {
    array @entity
    try {
        @entity = yml_decode(read(@path_to_entity))
    } catch (FormatException @e) {
        return(array(
            id: @path_to_entity,
            exceptions: _quest_init_exception(
                'yml_exception',
                array(@path_to_entity)
            )
        ))
    }

    @commander = _private_quest_entity_checker_get_commander()
    @env = _private_quest_entity_checker_get_env()
    
    @global_temp = _package_quest_entity_checker_get_global()
    @entity_temp = _package_quest_entity_checker_get_entity()
    @mob_temp = _package_quest_entity_checker_get_mob()
    @spec_temp = _package_quest_entity_checker_get_spec()

    @log = array(id: @path_to_entity)
    @exceptions = array()

    if (@is_npc) {
        if (!array_index_exists(@entity, 'main')) {
            @e = _quest_init_exception('key_not_found_exception', array())
            @exceptions['main'] = @e
            @log['exceptions'] = @exceptions
            return(@log)
        }
         @exceptions = array_merge(@exceptions, _private_quest_entity_checker_sparams(
            @global_temp['params'],
            @entity['main'],
            @entity,
            'main',
            @env,
            @commander
        ))
    } else {
        if (array_index_exists(@entity, 'main')) {
             @exceptions = array_merge(@exceptions, _private_quest_entity_checker_params(
                @global_temp['params'],
                @entity['main'],
                @entity,
                'main',
                @env,
                @commander
            ))
        }
    }
    @sections = @global_temp['sections']
    if (!_util_array_some_contains(array_keys(@sections), array_keys(@entity))) {
        @log['exceptions'] = @exceptions
        return(@log)
    }
    if (!array_index_exists(@entity['main'], 'type')) {
        @e = _quest_init_exception('type_undefined_exception', array())
        @exceptions['main.type'] = @e
    } else {
        if (array_index_exists(@entity, 'entity')) {
            if (@e = _private_entity_checker_param(
                @sections['entity']['check'],
                @entity['main']['type'],
                @sections['entity']['data'],
                @entity,
                @env,
                @commander
            )) {
                @exceptions['entity'] = @e
            } else {
                 @exceptions = array_merge(@exceptions, _private_quest_entity_checker_params(
                    @entity_temp,
                    @entity['entity'],
                    @entity,
                    'entity',
                    @env,
                    @commander
                ))
            }
        }
        if (array_index_exists(@entity, 'mob')) {
            if (@e = _private_entity_checker_param(
                @sections['mob']['check'],
                @entity['main']['type'],
                @sections['mob']['data'],
                @entity,
                @env,
                @commander
            )) {
                @exceptions['mob'] = @e
            } else {
                 @exceptions = array_merge(@exceptions, _private_quest_entity_checker_params(
                    @mob_temp,
                    @entity['mob'],
                    @entity,
                    'mob',
                    @env,
                    @commander
                ))
            }
        }
        if (array_index_exists(@entity, 'spec')) {
            if (@e = _private_entity_checker_param(
                @sections['spec']['check'],
                @entity['main']['type'],
                @sections['spec']['data'],
                @entity,
                @env,
                @commander
            )) {
                @exceptions['spec'] = @e
            } else {
                 @exceptions = array_merge(@exceptions, _private_quest_entity_checker_params(
                    @spec_temp[@entity['main']['type']],
                    @entity['spec'],
                    @entity,
                    'spec',
                    @env,
                    @commander
                ))
            }
        }
    }
    @log['exceptions'] = @exceptions
    return(@log)
}

array proc _private_quest_entity_checker_params(array @temp, array @params, array @npc, string @section, array @env, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _quest_init_exception('unknown_key_exception', array())
            @exceptions[@key] = @e
        } else {
            @data = if (array_index_exists(@temp[@key], 'data'), @temp[@key]['data'], null)
            if (@e = _private_entity_checker_param(
                @temp[@key]['check'],
                @value,
                @data,
                @npc,
                @env,
                @commander
            )) {
                @exceptions[@section.'.'.@key] = @e
            }
        }
    }
    return(@exceptions)
}

array proc _private_quest_entity_checker_sparams(array @temp, array @params, array @npc, string @section, array @env, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @temp) {
        if (!array_index_exists(@params, @key)) {
            @e = _quest_init_exception('key_not_found_exception', array())
            @exceptions[@section.'.'.@key] = @e
        } else {
            @data = if (array_index_exists(@value, 'data'), @value['data'], null)
            if (@e = _private_entity_checker_param(
                @value['check'],
                @params[@key],
                @data,
                @npc,
                @env,
                @commander
            )) {
                @exceptions[@section.'.'.@key] = @e
            }
        }
    }
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _quest_init_exception('unknown_key_exception', array())
            @exceptions[@section.'.'.@key] = @e
        }
    }
    return(@exceptions)
}

proc _private_entity_checker_param(string @check, @value, @data, array @npc, array @env, array @commander) {
    @env['value'] = @value
    @env['data'] = @data
    @env['character'] = @npc
    _util_commander_execute(@commander, @check)
    @exception = @env['exception']
    execute(@env['clear'])
    return(@exception)
}

execute(closure() {
    include('checks.ms')
    @commander = _util_commander_init_self()
    @env = array()
    @env['clear'] = closure() {
        @env['data'] = null
        @env['character'] = null
        @env['value'] = null
        @env['exception'] = null
    }

    _util_commander_register(@commander, 'int' , closure() {
        @env['exception'] = _package_quest_character_check_int(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'double' , closure() {
        @env['exception'] = _package_quest_character_check_double(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'boolean' , closure() {
        @env['exception'] = _package_quest_character_check_boolean(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'string' , closure() {
        @env['exception'] = _package_quest_character_check_string(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'list' , closure() {
        @env['exception'] = _package_quest_character_check_list(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'local' , closure() {
        @env['exception'] = _package_quest_character_check_local(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, 'uuid' , closure() {
        @env['exception'] = _package_quest_character_check_uuid(@env['value'], @env['data'], @env['character'])
    })
    _util_commander_register(@commander, '*' , closure() {
        @env['exception'] = _package_quest_character_check_nothink(@env['value'], @env['data'], @env['character'])
    })
    @o = array(commander: @commander, env: @env, successful: true, templates: array())
    export(_private_quest_entity_checker_name(), @o)
})