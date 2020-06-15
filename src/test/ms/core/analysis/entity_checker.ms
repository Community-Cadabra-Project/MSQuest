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
    @exceptions = _quest_entity_checker(@entities['SETTING'], true)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_entity(@entities) {
    @exceptions = _quest_entity_checker(@entities['ENTITY'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_mob(@entities) {
    @exceptions = _quest_entity_checker(@entities['MOB'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _unit_test_npc_analysis_spec(@entities) {
    _skip_test()
}

proc _unit_test_npc_analysis_fail(@entities) {
    @exceptions = _quest_entity_checker(@entities['BAD'], true)
    _assert_size(9, @exceptions, string(@exceptions))
    foreach(@e in @exceptions) {
        _assert_true(
            array_contains(
                array('cast_exception', 'size_exception', 'range_exception', 'key_not_found_exception', 'less_exception'),
                @e['type']
            ),
            'Unexpected type: '.@e['type']
        )
    }
}