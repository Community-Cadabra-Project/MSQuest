/*
Exceptions:
    keySet: type, args, [msg]
- key_not_found_exception
    args: []
- not_one_stage_exception
    args: []
- quest_id_exception
    args: [key]
- type_exception
    args: [type]
*/

proc _pr_stage_checker_import() {
    return(import('org.cadabra.msquest.stage_checker'))
}

proc _pr_stage_checker_get_env() {
    return(_pr_stage_checker_import()['env'])
}

proc _pr_stage_checker_get_commander() {
    return(_pr_stage_checker_import()['commander'])
}

string proc _stage_checker_parse_exceptions(array @logs) {
    @builder = res_create_resource('STRING_BUILDER')

    string_append(@builder, '############ STAGE ############')
    string_append(@builder, '\n')
    foreach(@log in @logs) {
        @id = @log['id']
        string_append(@builder, '\n')
        string_append(@builder, 'Stage at: ')
        string_append(@builder, @id)
        foreach(@entry in @log['exceptions']) {
            @attr = @entry['key']
            @e = @entry['e']
            string_append(@builder, '\n- attribute: ')
            string_append(@builder, @attr)
            string_append(@builder, '\n\t')
            string_append(@builder, _parse_exception(@e))
            string_append(@builder, '\n')
        }
    }
    
    return(string(@builder))
}

proc _stage_checker_analys(array @entries, array @stage) {
    @logs = array()
    @ids = array()
    foreach(@entry in @entries) {
        @id = @entry['id']
        @stage = @entry['stage']

        @exceptions = _pr_stage_checker_single(@stage)
        @log_exist = false
        if (array_size(@exceptions) != 0) {
            array_push(@logs, array(id: @id, exceptions: @exceptions))
            @log_exist = true
        }
        if (array_index_exists(@stage, 'id') && is_string(@stage['id'])) {
            @_id = @stage['id']
            if (array_contains(@ids, @_id)) {
                _pr_stage_checker_put_exception(@exceptions, _init_exception('quest_id_exception', array(@_id)), 'id')
                if (!@log_exist) {
                    array_push(@logs, array(id: @id, exceptions: @exceptions))
                }
            } else {
                array_push(@ids, @_id)
            }
        }
    }
    return(@logs)
}

proc _pr_stage_checker_put_exception(array @exceptions, array @e, string @key = null) {
    if (!@key) {
        @key = @e['args'][-1]
        array_remove(@e['args'], array_size(@e['args']) - 1)
    }
    array_push(@exceptions, array(key: @key, e: @e))
}

array proc _pr_stage_checker_single(array @stage) {
    @exceptions = array()

    if (!array_index_exists(@stage, 'id')) {
        @e = _init_exception('key_not_found_exception')
        _pr_stage_checker_put_exception(@exceptions, @e, 'id')
    }
    if (!array_index_exists(@stage, 'stages')) {
        @e = _init_exception('key_not_found_exception')
        _pr_stage_checker_put_exception(@exceptions, @e, 'stages')
        return(@exceptions)
    }
    if (!is_array(@stage['stages'])) {
        @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@stage['stages']), 'stages'))
       _pr_stage_checker_put_exception(@exceptions, @e, 'stages')
        return(@exceptions)
    }
    if (!is_associative(@stage['stages'])) {
        @error = _init_exception('cast_exception', array('associated array', typeof(@stage['stages']), 'stages'))
        _pr_stage_checker_put_exception(@exceptions, @e, 'stages')
        return(@exceptions)
    }
    @keys = array('stages', 'id', 'local', 'global')
    if (array_size(@stage) != array_size(@keys)) {
        @unknown = _util_array_minus(array_keys(@stage), @keys)
        if (array_size(@unknown) != 0) {
            @e = _init_exception('unknown_keys_exception', array(@unknown))
            _pr_stage_checker_put_exception(@exceptions, @e, './')
        }
    }
    if (array_size(@stage['stages']) == 0) {
        @e = _init_exception('not_one_stage_exception', array())
        _pr_stage_checker_put_exception(@exceptions, @e, 'stages')
        return(@exceptions)
    }
    array_push_all(@exceptions, _pr_stage_checker_stages(@stage['stages'], 'stages'))
    return(@exceptions)
}

array proc _pr_stage_checker_stages(array @stage, string @path) {
    @env = _pr_stage_checker_get_env()
    @c = _pr_stage_checker_get_commander()
    @exceptions = array()

    foreach(@id: @struct in @stage) {
        if (!is_array(@struct)) {
            @e = _init_exception('cast_exception', array('ms.lang.array', typeof(@data), @path))
            @exceptions["@path.@id"] = @e
            _pr_stage_checker_put_exception(@exceptions, @e, "@path.@id")
            continue()
        }
        if (!is_associative(@struct)) {
            @e = _init_exception('cast_exception', array('associated array', 'linear array', @path))
            _pr_stage_checker_put_exception(@exceptions, @e, "@path.@id")
            continue()
        }
        @keys = array('type', 'data')
        if (array_size(@struct) != array_size(@keys)) {
            @unknown = _util_array_minus(array_keys(@struct), @keys)
            if (array_size(@unknown) != 0) {
                @e = _init_exception('unknown_keys_exception', array(@unknown))
                _pr_stage_checker_put_exception(@exceptions, @e, "@path.@id")
                continue()
            }
        }
        @e = _pr_stage_checker_stage(@struct, @env, @c, "@path.@id")
        if (@e) {
            _pr_stage_checker_put_exception(@exceptions, @e)
        }
    }
    return(@exceptions)
}

proc _pr_stage_checker_stage(array @stage, array @env, array @c, string @path) {
    @env['path'] = "@path.data"
    @env['value'] = @stage['data']
    @exception = null
    try {
        _util_commander_execute(@c, @stage['type'])
        @exception = @env['exception']
    } catch (IllegalArgumentException @e) {
        @exception = _init_exception('type_exception', array(@stage['type'], "@path.type"))
    } finally {
        execute(@env['clear'])
    }   
    return(@exception)
}

execute(closure() {
    include('checks.ms')
    @c = _util_commander_init_self()
    @env = array()
    @env['clear'] = closure() {
        @env['path'] = null
        @env['value'] = null
        @env['exception'] = null
    }

    _util_commander_register(@c, 'set' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@c, 'linear' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@c, 'orientated_linear' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@c, 'cycle' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@c, 'orientated_cycle' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@c, 'graph' , closure() {
        @env['exception'] = _graph(@env['value'], @env['path'])
    })
    // _util_commander_register(@c, 'tree' , closure() {
    //     @env['exception'] = _tree(@env['value'], @env['path'])
    // })
    @o = array(commander: @c, env: @env)
    export('org.cadabra.msquest.stage_checker', @o)
})