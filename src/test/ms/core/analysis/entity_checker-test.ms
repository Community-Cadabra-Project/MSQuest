proc _before_all() {
    return(_sa_load_entities())
}

proc _test_npc_analysis_main(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['SETTING']['object'], true)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_entity(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['ENTITY']['object'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_mob(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['MOB']['object'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_spec(@entities) {
    _skip_test()
}

proc _test_npc_analysis_fail(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['BAD']['object'], true)
    _assert_size(11, @exceptions, string(@exceptions))
    foreach(@entry in @exceptions) {
        _assert_true(
            array_contains(
                array('cast_exception', 'size_exception', 'range_exception', 'key_not_found_exception', 'less_exception', 'contains_exception'),
                @entry['e']['type']
            ),
            'Unexpected type: '.@entry['e']['type']
        )
    }
}

proc _test_npc_analysis_log(@entities) {
    @logs = _entity_checker_analys(
        array(
           @entities['BAD']
        )
    )
    _assert_not_empty(@logs)
    //_print(_entity_checker_parse_exceptions(@logs))
}