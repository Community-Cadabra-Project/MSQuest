proc _private_quest_entity_checker_name() {
    return('__QUEST_ENTITY_CHECKER')
}

proc _quest_entity_checker_import() {
    return(import(_private_quest_entity_checker_name()))
}

proc _quest_entity_checker_test() {
    
}

proc _quest_entity_checker_run() {
    
    if (!_quest_entity_checker_import()['successful']) {
        _quest_qlog('FATAL', 'incor_entities')
        die()
    }
}

execute(closure() {
    proc _log_exception(array @e) {
        _quest_qlog('ERROR', @e['type'], @e['args'], '\n'.@e['msg'])
        _quest_entity_checker_import()['successful'] = false
    }

    @commander = _util_commander_init_self()
    @env = array()
    @env['clear'] = closure() {
        @env['data'] = null
        @env['character'] = null
        @env['value'] = null
    }

    _util_commander_register(@commander, 'int' , closure() {
        if (@e = _package_quest_character_check_int(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'double' , closure() {
        if (@e = _package_quest_character_check_double(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'boolean' , closure() {
        if (@e = _package_quest_character_check_boolean(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'string' , closure() {
        if (@e = _package_quest_character_check_string(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'list' , closure() {
        if (@e = _package_quest_character_check_list(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'local' , closure() {
        if (@e = _package_quest_character_check_local(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, 'uuid' , closure() {
        if (@e = _package_quest_character_check_uuid(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    _util_commander_register(@commander, '*' , closure() {
        if (@e = _package_quest_character_check_nothink(@env['value'], @env['data'], @env['character'])) {
            _log_exception(@e)
        }
        execute(@env['clear'])
    })
    @o = array(commander: @commander, env: @env, successful: true, templates: array())
    export(_private_quest_entity_checker_name(), @o)
})