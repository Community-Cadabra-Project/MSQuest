proc _before_all() {
    return(_sa_load_stages())
}

proc _test_contain_graph_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['contain_graph_exc']['stage'])
    _assert_equals(array('contain_graph_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_unreachable_points_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['unreachable_points_exc']['stage'])
    _assert_equals(array('unreachable_points_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_key_not_found_exc1(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['key_not_found_exc1']['stage'])
    _assert_equals(array('key_not_found_exception', 'key_not_found_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_key_not_found_exc2(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['key_not_found_exc2']['stage'])
    _assert_equals(array('key_not_found_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_no_one_stage_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['no_one_stage_exc']['stage'])
    _assert_equals(array('not_one_stage_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_size_graph_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['size_graph_exc']['stage'])
    _assert_equals(array('size_graph_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_stage_dublication_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['stage_dublication_exc']['stage'])
    _assert_equals(array('stage_duplicate_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_tree_head_exc(@stages) {
    _skip_test()
    @exceptions = _pr_stage_checker_single(@stages['tree_head_exc']['stage'])
    _assert_equals(array('tree_head_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_tree_node_exc(@stages) {
    _skip_test()
    @exceptions = _pr_stage_checker_single(@stages['tree_node_exc']['stage'])
    _assert_equals(array('tree_node_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_type_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['type_exc']['stage'])
    _assert_equals(array('type_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_unknown_keys_exc1(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['unknown_keys_exc1']['stage'])
    _assert_equals(array('unknown_keys_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_unknown_keys_exc2(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['unknown_keys_exc2']['stage'])
    _assert_equals(array('unknown_keys_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_unreachable_points_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['unreachable_points_exc']['stage'])
    _assert_equals(array('unreachable_points_exception'),_to_types(@exceptions), string(@exceptions))
}

proc _test_quest_id_exc(@stage) {
    @logs = _stage_checker_analys(
        array(
            @stage['quest_id_exc1'],
            @stage['quest_id_exc2']
        )
    )
    _assert_not_empty(array_filter(@logs, closure(@k, @v) {
        return(array_size(array_filter(@v['exceptions'], closure(@k, @v) {
            return(@v['e']['type'] == 'quest_id_exception')
        })) != 0)
    }), @logs)
}

proc _test_valide_stage(@stage) {
    @exception = _pr_stage_checker_single(@stage['valid_stage']['stage'])
    _assert_empty(@exception, string(@exception))
}

proc _test_log(@stage) {
    @logs = _stage_checker_analys(
        array(
            @stage['check_log']
        )
    )
    @act_types = _to_types(@logs[0]['exceptions'])
    @exp_types = array(
        'contain_graph_exception',
        'unknown_keys_exception',
        'stage_duplicate_exception',
        'type_exception'
    )
    _assert_true(array_every(
        @act_types,
        closure(@v) {
            return(array_contains(@exp_types, @v))
        }
    ))
    @string = string(_stage_checker_parse_exceptions(@logs))
    _assert_not_empty(@string)
    //_print(@string)
}

proc _to_types(@exceptions) {
    @map = array_map(@exceptions, closure(@v) {
        return(@v['e']['type'])
    })
    @result = array()
    foreach(@v in @map) {
        @result[] = @v
    }
    return(@result)
}