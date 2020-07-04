proc _before_all() {

    string @path_to_npc = get_absolute_path('npc')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    foreach(@file in @files) {
        @id = @file[cslice(@len_npc+1, -5)]
        @entities[@id]['id'] = @file
        @entities[@id]['entity'] = yml_decode(read(@file))
    }
    return(@entities)
}

proc _test_npc_analysis_main(@entities) {
    @exceptions = _package_entity_checker(@entities['SETTING']['entity'], true)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_entity(@entities) {
    @exceptions = _package_entity_checker(@entities['ENTITY']['entity'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_mob(@entities) {
    @exceptions = _package_entity_checker(@entities['MOB']['entity'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_spec(@entities) {
    _skip_test()
}

proc _test_npc_analysis_fail(@entities) {
    @exceptions = _package_entity_checker(@entities['BAD']['entity'], true)
    _assert_size(10, @exceptions, string(@exceptions))
    foreach(@e in @exceptions) {
        _assert_true(
            array_contains(
                array('cast_exception', 'size_exception', 'range_exception', 'key_not_found_exception', 'less_exception', 'contains_exception'),
                @e['type']
            ),
            'Unexpected type: '.@e['type']
        )
    }
}

proc _test_npc_analysis_log(@entities) {
    @logs = _entity_checker_analys(
        array(
            array(id: @entities['BAD']['id'], entity: @entities['BAD']['entity'], is_npc: true)
        )
    )
    _assert_not_empty(@logs)
    _print(_entity_checker_parse_exceptions(@logs))
}