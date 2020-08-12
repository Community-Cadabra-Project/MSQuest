/*
Exceptions:
- unknown_keys_exception
    args: [keys]
- id_exception
    args: [id]
- key_not_found_exception
    args: []
- cast_exception
    args: [expect_type, actually_type]
*/

Resource proc _dialog_checker_parse_exceptions(array @logs, Resource @builder = res_create_resource('STRING_BUILDER')) {
    string_append(@builder, '############ DIALOG ############')
    string_append(@builder, '\n')
    foreach(@log in @logs) {
        @id = @log['id']
        string_append(@builder, '\n############\n')
        string_append(@builder, 'Dialog at: ')
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
    } else {
        string_append(@builder, 'Successfully')
        string_append(@builder, '\n')
    }
    
    return(@builder)
}

array proc _dialog_checker_ids(array @entries) {
    @ids = array()
    foreach(@entry in @entries) {
        @dialog = @entry['object']
        if (array_index_exists(@dialog, 'id') && is_string(@dialog['id'])) {
            @_id = @dialog['id']
            if (array_contains(@ids, @_id)) {
                continue()
            } else {
                @ids[] = @_id
            }
        }
    }
    return(@ids)
}

array proc _dialog_checker_analys(array @dialogs) {
    @logs = array()
    @ids = array()
    foreach(@entry in @dialogs) {
        @id = @entry['id']
        @dialog = @entry['object']
        @exceptions = _pr_dialog_checker_single(@dialog)
        @log_exist = false
        if (@exceptions) {
            @logs[] = array(id: @id, exceptions: @exceptions)
            @log_exist = true
        }
        if (array_index_exists(@dialog, 'id') && is_string(@dialog['id'])) {
            @_id = @dialog['id']
            if (array_contains(@ids, @_id)) {
                _pr_stage_checker_put_exception(
                    @exceptions,
                    _init_exception('id_exception', array(@_id)),
                    'id'
                )
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

array proc _pr_dialog_checker_single(array @dialog) {
    @exceptions = array()
    if (!array_index_exists(@dialog, 'id')) {
        @e = _init_exception('key_not_found_exception', array('id'))
        _pr_dialog_checker_put_exception(@exceptions, @e, './')
    } else if (!is_string(@dialog['id'])) {
        @e = _init_exception('cast_exception', array(typeof(''), typeof(@dialog['id'])))
        _pr_dialog_checker_put_exception(@exceptions, @e, 'id')
    }

    if (!array_index_exists(@dialog, 'message')) {
        @e = _init_exception('key_not_found_exception', array('message'))
        _pr_dialog_checker_put_exception(@exceptions, @e, './')
        return(@exceptions)
    } 
    if (!is_associative(@dialog['message'])) {
        @e = _init_exception('cast_exception', array('associative array', typeof(@dialog['message'])))
        _pr_dialog_checker_put_exception(@exceptions, @e, 'message')
        return(@exceptions)
    }
    @keys = array('message', 'id')
    if (array_size(@dialog) != array_size(@keys)) {
        @unknown = _util_array_minus(array_keys(@dialog), @keys)
        if (array_size(@unknown) != 0) {
            @e = _init_exception('unknown_keys_exception', array(@unknown))
            _pr_dialog_checker_put_exception(@exceptions, @e, './')
        }
    }
    foreach(@key: @v in @dialog['message']) {
        if (!is_string(@v)) {
            if (!is_array(@v) || is_associative(@v)) {
                @e = _init_exception('cast_exception', array(typeof('').' | '.array.'[not associative]', typeof(@dialog['message'][@key])))
                _pr_dialog_checker_put_exception(@exceptions, @e, "message.@key")
            } else {
                for(@i = 0, @i < array_size(@v), @i++) {
                    @s = @v[@i]
                    if (!is_string(@s)) {
                        @e = _init_exception('cast_exception', array(typeof(''), typeof(@dialog['message'][@key])))
                        _pr_dialog_checker_put_exception(@exceptions, @e, "message.@key[@i]")
                    }
                }
            }
        }
    }
    return(@exceptions)
}

void proc _pr_dialog_checker_put_exception(array @exceptions, array @e, string @key) {
    @exceptions[] = array(key: @key, e: @e)
}