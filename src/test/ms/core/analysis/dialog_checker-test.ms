proc _before_all() {

    string @path = get_absolute_path('dialog')

    array @entities = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    @dialogs = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -5)]
        try {
            @dialogs[@id] = yml_decode(read(@file))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@dialogs)
}

proc _test_cast_exc1(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['cast_exc1'])
    _assert_equals(array('cast_exception', 'cast_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_cast_exc1(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['cast_exc2'])
    _assert_equals(array('cast_exception', 'cast_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_key_not_found_exc1(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['key_not_found_exc1'])
    _assert_equals(array('key_not_found_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_key_not_found_exc2(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['key_not_found_exc2'])
    _assert_equals(array('key_not_found_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_key_not_found_exc3(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['key_not_found_exc3'])
    _assert_equals(array('key_not_found_exception', 'key_not_found_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_unknown_keys_exc(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['unknown_keys_exc'])
    _assert_equals(array('unknown_keys_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_unknown_keys_exc(@dialogs) {
    @exceptions = _pr_dialog_checker_single(@dialogs['unknown_keys_exc'])
    _assert_equals(array('unknown_keys_exception'),_to_types(@exceptions), @exceptions)
}

proc _test_id_exc(@dialogs) {
    @logs = _dialog_checker_analys(
        array(
            array(
                id: 'id_exc1',
                dialog: @dialogs['id_exc1']
            ),
            array(
                id: 'id_exc2',
                dialog: @dialogs['id_exc2']
            )
        )
    )
    _assert_not_empty(array_filter(@logs, closure(@k, @v) {
        return(array_size(array_filter(@v['exceptions'], closure(@k, @v) {
            return(@v['e']['type'] == 'id_exception')
        })) != 0)
    }), @logs)
}

proc _test_log(@dialogs) {
    @logs = _dialog_checker_analys(
        array(
            array(
                id: 'check_log',
                dialog: @dialogs['check_log']
            ),
        )
    )
    @act_types = _to_types(@logs[0]['exceptions'])
    @exp_types = array(
        'cast_exception',
        'unknown_keys_exception'
    )
    _assert_true(array_every(
        @act_types,
        closure(@v) {
            return(array_contains(@exp_types, @v))
        }
    ), "@exp_types : @act_types")
    @string = _dialog_checker_parse_exceptions(@logs)
    _assert_not_empty(@string)
    _print(@string)
}

proc _to_types(@exceptions) {
    @map = array_map(@exceptions, closure(@v) {
        return(@v['e']['type'])
    })
    @result = array()
    foreach(@v in @map) {
        array_push(@result, @v)
    }
    return(@result)
}