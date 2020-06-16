proc _unit_before_all() {

    string @path_to_npc = get_absolute_path('npc')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    foreach(@file in @files) {
        @entities[@file[cslice(@len_npc+1, -5)]] = @file
    }
    return(@entities)
}

proc _unit_test_npc_analysis_main(@entities) {
    @exceptions = _package_quest_entity_checker(@entities['SETTING'], true)['exceptions']
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_entity(@entities) {
    @exceptions = _package_quest_entity_checker(@entities['ENTITY'], false)['exceptions']
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_mob(@entities) {
    @exceptions = _package_quest_entity_checker(@entities['MOB'], false)['exceptions']
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_spec(@entities) {
    _skip_test()
}

proc _unit_test_npc_analysis_fail(@entities) {
    @exceptions = _package_quest_entity_checker(@entities['BAD'], true)['exceptions']
    _assert_size(10, @exceptions, string(_package_quest_entity_checker(@entities['BAD'], true)))
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

proc _unit_test_npc_analysis_log(@entities) {
    @result = _quest_entity_analys(
        array(
            array(path: @entities['BAD'], is_npc: true)
        ),
        get_absolute_path('npc')
    )
    _assert_not_null(@result)
    _print(@result)
}