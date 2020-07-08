proc _before_all() {

    string @path_to_npc = get_absolute_path('entity')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    @entities = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len_npc+1, -5)]
        try {
            @entities[@id] = yml_decode(read(@file))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@entities)
}

proc _test_npc_analysis_main(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['SETTING'], true)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_entity(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['ENTITY'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_mob(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['MOB'], false)
    _assert_size(0, @exceptions, string(@exceptions))
}

proc _test_npc_analysis_spec(@entities) {
    _skip_test()
}

proc _test_npc_analysis_fail(@entities) {
    @exceptions = _pr_entity_checker_single(@entities['BAD'], true)
    _assert_size(10, @exceptions, string(@exceptions))
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
            array(id: 'BAD', entity: @entities['BAD'], is_npc: true)
        )
    )
    _assert_not_empty(@logs)
    _print(_entity_checker_parse_exceptions(@logs))
}