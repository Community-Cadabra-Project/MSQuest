/*
Exceptions:
    keySet: type, args, [msg]
- key_not_found_exception
    args: []
- stage_id_exception
    args: [key]
- quest_id_exception
    args: [key]
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
    foreach(@log in @npc_logs) {
        @id = @log['id']
        string_append(@builder, '\n')
        string_append(@builder, 'Stage at: ')
        string_append(@builder, @id)
        foreach(@attr: @e in @log['exceptions']) {
            string_append(@builder, '\n- attribute: ')
            string_append(@builder, @attr)
            string_append(@builder, '\n\t')
            string_append(@builder, _parse_exception(@e))
            string_append(@builder, '\n')
        }
    }
    
    return(string(@builder))
}

proc _stage_checker_analys(string @entries, array @stage) {
    @logs = array()
    @ids = array()
    foreach(@entry in @entries) {
        @id = @entry['id']
        @stage = @entry['stage']

        @exceptions = _pr_stage_checker_single(@stage)
        if (array_size(@exceptions) != 0) {
            array_push(@logs, array(id: @id, exceptions: = @exceptions))
        }
        if (array_index_exists(@stage, 'id')) {
            @_id = @stage['id']
            if (array_contains(@ids, @_id)) {
                @exceptions = array()
                @exceptions['id']= _init_exception('quest_id_exception', array(@_id))
                array_push(@logs, array(id: @id, exceptions: = @exceptions))
            } else {
                array_push(@ids, @_id)
            }
        }
    }
    return(@logs)
}

proc _pr_stage_checker_put_exception(array @exceptions, array @e, string @key = null) {
    if (@key) {
        @key = @e['args'][-1]
        array_remove(@e['args'], -1)
        @exceptions[@key] = @e
    } else {
        @exceptions[@key] = @e
    }
}

array proc _pr_stage_checker_single(array @stage) {
    @exceptions = array()

    if (!array_index_exists(@stage, 'id')) {
        @e = _init_exception('key_not_found_exception')
        _stage_checker_put_exception(@exceptions, @e, 'id')
    }
    if (!array_index_exists(@stage, 'stages')) {
        @e = _init_exception('key_not_found_exception')
        _stage_checker_put_exception(@exceptions, @e, 'stages')
    }
    if (!is_array(@stage['stages'])) {
        @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@data), 'stages'))
        return(@error)
    }
    if (!is_associative(@stage['stages'])) {
        @error = _init_exception('cast_exception', array('associated array', 'linear array', 'stages'))
        return(@error)
    }
    foreach(@st in @stage['stages']) {
        array_push_all(@exceptions, _pr_stage_checker_stages(@st))
    }
    return(@exceptions)
}

array proc _pr_stage_checker_stages(array @stage, string @path) {
    @env = _pr_stage_checker_get_env()
    @c = _pr_stage_checker_get_commander()
    @ids = array()
    @exceptions = array()

    foreach(@id: @struct in @stage) {
        if (array_contains(@ids, @id)) {
            @error = _init_exception('stage_id_exception', array('id'))
            @exceptions[@path] = @error
            return(@exceptions)
        } else {
            array_push(@ids, @id)
        }
        if (!is_array(@struct)) {
            @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@data), @path))
            @exceptions[@path.@id] = @error
            return(@exceptions)
        }
        if (!is_associative(@data)) {
            @error = _init_exception('cast_exception', array('associated array', 'linear array', @path))
            @exceptions[@path.@id] = @error
            return(@exceptions)
        }
        @keys = array('type, data')
        if (array_size(@struct) != array_size(@keys)) {
            @unknown = _util_array_minus(array_keys(@data), @keys)
            @error = _init_exception('unknown_keys_exception', array(@unknown))
            @exceptions[@path.@id] = @error
            return(@exceptions)
        }
        @e = _pr_stage_checker_stage(@struct, @env, @c, @path.@id)
        if (@e) {
            _pr_stage_checker_put_exception(@exceptions, @e)
        }
    }
}

array proc _pr_stage_checker_stage(array @stage, array @env, array @c, string @path) {
    @env['path'] = @path.'data'
    @env['value'] = @stage['data']
    _util_commander_execute(@commander, @stage['type'])
    @exception = @env['exception']
    execute(@env['clear'])
    return(@exception)
}

execute(closure() {
    include('checks.ms')
    @commander = _util_commander_init_self()
    @env = array()
    @env['clear'] = closure() {
        @env['path'] = null
        @env['value'] = null
        @env['exception'] = null
    }

    _util_commander_register(@commander, 'set' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'linear' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'orientated_linear' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'cycle' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'orientated_cycle' , closure() {
        @env['exception'] = _array(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'graph' , closure() {
        @env['exception'] = _graph(@env['value'], @env['path'])
    })
    _util_commander_register(@commander, 'tree' , closure() {
        @env['exception'] = _tree(@env['value'], @env['path'])
    })
    @o = array(commander: @commander, env: @env)
    export('org.cadabra.msquest.stage_checker', @o)
})