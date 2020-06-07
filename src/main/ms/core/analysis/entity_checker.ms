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
    return(_package_quest_entity_checker_import()['commader'])
}

array proc _quest_entity_checker(array @entity, boolean @is_npc) {
    @commander = _private_quest_entity_checker_get_commander()
    @env = _private_quest_entity_checker_get_env()
    
    @global_temp = _package_quest_entity_checker_get_global()
    @entity_temp = _package_quest_entity_checker_get_entity()
    @mob_temp = _package_quest_entity_checker_get_mob()
    @spec_temp = _package_quest_entity_checker_get_spec()

    @exceptions = array()

    if (@is_npc) {
        array_push_all(@exceptions, _private_quest_entity_checker_sparams(
            @global_temp['params'],
            @entity,
            @entity,
            @env,
            @commander
        ))
        @selections = @global_temp['selections']
        if (!_util_array_some_contains(array_keys(@selections), array_keys(@entity))) {
            return(@exceptions)
        }
        if (!array_index_exists(@entity, 'type')) {
            @e = _package_quest_character_check_e('type_undefined_exception', array(@key))
            array_push(@exceptions, @e)
        } else {
            if (array_index_exists(@entity, 'entity')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['entity']['data'],
                    @env,
                    @commander
                )) {
                    array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @entity_temp,
                        @entity['entity'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
            if (array_index_exists(@entity, 'mob')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['mob']['data'],
                    @env,
                    @commander
                )) {
                    array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @mob_temp,
                        @entity['mob'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
            if (array_index_exists(@entity, 'spec')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['spec']['data'],
                    @env,
                    @commander
                )) {
                    array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @spec_temp[@entity['type']],
                        @entity['spec'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
        }
    } else {
        array_push_all(@exceptions, _private_quest_entity_checker_params(
            @global_temp['params'],
            @entity,
            @entity,
            @env,
            @commander
        ))
        @selections = @global_temp['selections']
        if (!_util_array_some_contains(array_keys(@selections), array_keys(@entity))) {
            return(@exceptions)
        }
        if (!array_index_exists(@entity, 'type')) {
            @e = _package_quest_character_check_e('type_undefined_exception', array(@key))
            array_push(@exceptions, @e)
        } else {
            if (array_index_exists(@entity, 'entity')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['entity']['data'],
                    @env,
                    @commander
                )) {
                    array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @entity_temp,
                        @entity['entity'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
            if (array_index_exists(@entity, 'mob')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['mob']['data'],
                    @env,
                    @commander
                )) {
                    array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @mob_temp,
                        @entity['mob'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
            if (array_index_exists(@entity, 'spec')) {
                if (@e = _private_entity_checker_param(
                    @entity['type'],
                    @selections['spec']['data'],
                    @env,
                    @commander
                )) {
                  array_push(@exceptions, @e)
                } else {
                    array_push_all(@exceptions, _private_quest_entity_checker_sparams(
                        @spec_temp[@entity['type']],
                        @entity['spec'],
                        @entity,
                        @env,
                        @commander
                    ))
                }
            }
        }
    }
    return(@exception)
}

array proc _private_quest_entity_checker_params(array @temp, array @params, array @npc, array @env, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _package_quest_character_check_e('unknown_key_exception', array(@key))
            array_push(@exceptions, @e)
        } else {
            if (@e = _private_entity_checker_param(
                @value,
                @temp[@key]['data'],
                @npc,
                @env,
                @commander
            )) {
                array_push(@exceptions, @e)
            }
        }
    }
    return(@exception)
}

array proc _private_quest_entity_checker_sparams(array @temp, array @params, array @npc, array @env, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @temp) {
        if (!array_index_exists(@params, @key)) {
            @e = _package_quest_character_check_e('key_not_found_exception', array(@key))
            array_push(@exceptions, @e)
        } else {
            if (@e = _private_entity_checker_param(
                @params[@key],
                @value['data'],
                @npc,
                @env,
                @commander
            )) {
                array_push(@exceptions, @e)
            }
        }
    }
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _package_quest_character_check_e('unknown_key_exception', array(@key))
            array_push(@exceptions, @e)
        }
    }
    return(@exception)
}

proc _private_entity_checker_param(@value, @data, @npc, @env, @commander) {
    @env['value'] = @value
    @env['data'] = @data
    @env['character'] = @npc
    _util_commander_execute(@commander, @data['check'])
    @exception = @env['exception']
    execute(@env['clear'])
    return(@exception)
}

execute(closure() {
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