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

proc _pr_stage_checker_get_commander() {
    return(_pr_stage_checker_import()['commander'])
}

Resource proc _stage_checker_parse_exceptions(array @logs, Resource @builder = res_create_resource('STRING_BUILDER')) {
    string_append(@builder, '############ STAGE ############')
    string_append(@builder, '\n')
    foreach(@log in @logs) {
        @id = @log['id']
        string_append(@builder, '\n############\n')
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
    
    return(@builder)
}

array proc _stage_checker_ids(array @entries) {
    @ids = array()
    foreach(@entry in @entries) {
        @stage = @entry['stage']
        if (array_index_exists(@stage, 'id') && is_string(@stage['id'])) {
            @_id = @stage['id']
            if (array_contains(@ids, @_id)) {
                continue()
            } else {
                @ids[] = @_id
            }
        }
    }
    return(@ids)
}

array proc _stage_checker_analys(array @entries) {
    @logs = array()
    @ids = array()
    foreach(@entry in @entries) {
        @id = @entry['id']
        @stage = @entry['stage']

        @exceptions = _pr_stage_checker_single(@stage)
        @log_exist = false
        if (array_size(@exceptions) != 0) {
            @logs[] = array(id: @id, exceptions: @exceptions)
            @log_exist = true
        }
        if (array_index_exists(@stage, 'id') && is_string(@stage['id'])) {
            @_id = @stage['id']
            if (array_contains(@ids, @_id)) {
                _pr_stage_checker_put_exception(@exceptions, _init_exception('quest_id_exception', array(@_id)), 'id')
                if (!@log_exist) {
                    @logs[] = array(id: @id, exceptions: @exceptions)
                }
            } else {
                @ids[] = @_id
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
    @exceptions[] = array(key: @key, e: @e)
}

array proc _pr_stage_checker_single(array @stage) {
    @exceptions = array()

    if (!array_index_exists(@stage, 'id')) {
        @e = _init_exception('key_not_found_exception')
        _pr_stage_checker_put_exception(@exceptions, @e, 'id')
    }
    if (!array_index_exists(@stage, 'branches')) {
        @e = _init_exception('key_not_found_exception')
        _pr_stage_checker_put_exception(@exceptions, @e, 'branches')
        return(@exceptions)
    }
    if (!is_array(@stage['branches'])) {
        @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@stage['branches']), 'branches'))
       _pr_stage_checker_put_exception(@exceptions, @e, 'branches')
        return(@exceptions)
    }
    if (!is_associative(@stage['branches'])) {
        @error = _init_exception('cast_exception', array('associated array', typeof(@stage['branches']), 'branches'))
        _pr_stage_checker_put_exception(@exceptions, @e, 'branches')
        return(@exceptions)
    }
    @keys = array('branches', 'id', 'global')
    @unknown = _util_array_minus(array_keys(@stage), @keys)
    if (array_size(@unknown) != 0) {
        @e = _init_exception('unknown_keys_exception', array(@unknown))
        _pr_stage_checker_put_exception(@exceptions, @e, './')
    }
    if (array_size(@stage['branches']) == 0) {
        @e = _init_exception('not_one_stage_exception', array())
        _pr_stage_checker_put_exception(@exceptions, @e, 'branches')
        return(@exceptions)
    }
    array_push_all(@exceptions, _pr_stage_checker_stages(@stage['branches'], 'branches'))
    return(@exceptions)
}

array proc _pr_stage_checker_stages(array @stage, string @path) {
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
        @e = _pr_stage_checker_stage(@struct, @c, "@path.@id")
        if (@e) {
            _pr_stage_checker_put_exception(@exceptions, @e)
        }
    }
    return(@exceptions)
}

proc _pr_stage_checker_stage(array @stage, array @c, string @path) {
    @exception = null
    try {
        @exception = _util_commander_execute(@c, @stage['type'], @stage['data'], "@path.data")
    } catch (IllegalArgumentException @e) {
        @exception = _init_exception('type_exception', array(@stage['type'], "@path.type"))
    }
    return(@exception)
}

proc _stage_checker_init() {
    synchronized('org.cadabra.msquest.stage_checker') {
        if (_pr_stage_checker_import()) {
            return()
        }
        include('checks.ms')
        @c = _util_commander_init_self()
    
        _util_commander_register_proc(@c, 'set' , '_array')
        _util_commander_register_proc(@c, 'linear' , '_array')
        _util_commander_register_proc(@c, 'orientated_linear' , '_array')
        _util_commander_register_proc(@c, 'cycle' , '_array')
        _util_commander_register_proc(@c, 'orientated_cycle' , '_array')
        _util_commander_register_proc(@c, 'graph' , '_graph')
        _util_commander_register_proc(@c, 'flag' , '_array')
        // _util_commander_register(@c, 'tree', '_tree')
        @o = array(commander: @c)
        export('org.cadabra.msquest.stage_checker', @o)
    }
}