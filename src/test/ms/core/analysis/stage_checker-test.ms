proc _before_all() {

    string @path_to_npc = get_absolute_path('stages')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    foreach(@file in @files) {
        @id = @file[cslice(@len_npc+1, -5)]
        @stages[@id] = yml_decode(read(@file))
    }
    return(@stages)
}

proc _test_contain_graph_exc(@stages) {
    @exceptions = _pr_stage_checker_single(@stages['contain_graph_exc'])
    _assert_equals(array('contain_graph_exception'), to_types(@exceptions))
}

proc _test_unreachable_points_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['unreachable_points_exc'])
    _assert_equals(array('unreachable_points_exception'), to_types(@exceptions))
}

proc _test_key_not_found_exc1(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['key_not_found_exc1'])
    _assert_equals(array('key_not_found_exception'), to_types(@exceptions))
}

proc _test_key_not_found_exc2(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['key_not_found_exc2'])
    _assert_equals(array('key_not_found_exception'), to_types(@exceptions))
}

proc _test_no_one_stage_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['no_one_stage_exc'])
    _assert_equals(array('no_one_stage_exception'), to_types(@exceptions))
}

proc _test_size_graph_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['size_graph_exc'])
    _assert_equals(array('size_graph_exception'), to_types(@exceptions))
}

proc _test_stage_dublication_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['stage_dublication_exc'])
    _assert_equals(array('stage_dublication_exception'), to_types(@exceptions))
}

proc _test_stage_id_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['stage_id_exc'])
    _assert_equals(array('stage_id_exception'), to_types(@exceptions))
}

proc _test_tree_head_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['tree_head_exc'])
    _assert_equals(array('tree_head_exception'), to_types(@exceptions))
}

proc _test_tree_node_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['tree_node_exc'])
    _assert_equals(array('tree_node_exception'), to_types(@exceptions))
}

proc _test_type_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['type_exc'])
    _assert_equals(array('type_exception'), to_types(@exceptions))
}

proc _test_unknown_keys_exc1(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['unknown_keys_exc1'])
    _assert_equals(array('unknown_keys_exception'), to_types(@exceptions))
}

proc _test_unknown_keys_exc2(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['unknown_keys_exc2'])
    _assert_equals(array('unknown_keys_exception'), to_types(@exceptions))
}

proc _test_unreachable_points_exc(@stage) {
    @exceptions = _pr_stage_checker_single(@stages['unreachable_points_exc'])
    _assert_equals(array('unreachable_points_exception'), to_types(@exceptions))
}

proc _test_quest_id_exc(@stage) {
    @logs = _stage_checker_analys(
        array(
            array(
                id: 'quest_id_exc1',
                stage: @stage['quest_id_ex1c']
            ),
            array(
                id: 'quest_id_exc2',
                stage: @stage['quest_id_exc2']
            )
        )
    )
    assert_not_empty(array_filter(@logs, closure(@k, @v) {
        return(array_size(array_filter(@v['exceptions'], closure(@k, @v) {
            return(@v['type'] == 'quest_id_exception')
        })) != 0)
    }))
}

proc _test_valide_stage(@stage) {
    @exception = _pr_stage_checker_single(@stage['valide_stage'])
    _assert_empty(@exception)
}

proc _to_types(@excetions) {
    return(map(@exceptions, closure(@k, @v) {
        return(@v['type'])
    }))
}