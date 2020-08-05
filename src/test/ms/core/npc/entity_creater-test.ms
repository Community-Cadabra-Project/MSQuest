proc _before_all() {
    string @path_to_npc = _unit_resource('npc')

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

proc _before_each() {
    return(_entity_creater_init())
}

proc _test_witch(@entities, @creater) {
    @uuid = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['witch']))}
    )
    _assert_true_obj(@uuid)
    entity_remove(@uuid)
}

proc _test_slime(@entities, @creater) {
    @uuid = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['slime']))}
    )
    _assert_true_obj(@uuid)
    entity_remove(@uuid)
}

proc _test_village(@entities, @creater) {
    @uuid = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['village']))}
    )
    _assert_true_obj(@uuid)
    entity_remove(@uuid)
}