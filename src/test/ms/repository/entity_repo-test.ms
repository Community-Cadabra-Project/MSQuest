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
    return(array(@entities, _entity_creater_init()))
}

proc _before_each(@test) {
    @path = get_absolute_path('out'._util_sdn().'entity_repo'._util_sdn().@test)
    _util_make_folder(@path, -4)
    return(_entity_repo_init(@path))
}

proc _test(@all, @repo) {
    # Cause x_run_on_main_thread_now
    _assert_time_limit(0.4, 0.5)
    @entities = @all[0]
    @creater = @all[1]

    @id_w = @entities['witch']['main']['id']
    @uuid_w = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['witch']))}
    )

    _method(@repo, 'save', @uuid_w, @id_w)

    @id_v = @entities['village']['main']['id']
    @uuid_v = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['village']))}
    )

    _method(@repo, 'save', @uuid_v, @id_v)

    @id_s = @entities['slime']['main']['id']
    @uuid_s = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['slime']))}
    )

    _method(@repo, 'save', @uuid_s, @id_s)

    _assert_equals(@uuid_w, _method(@repo, 'getUUID', @id_w))
    _assert_equals(@uuid_v, _method(@repo, 'getUUID', @id_v))
    _assert_equals(@uuid_s, _method(@repo, 'getUUID', @id_s))

    _assert_equals(@id_w, _method(@repo, 'getID', @uuid_w))
    _assert_equals(@id_v, _method(@repo, 'getID', @uuid_v))
    _assert_equals(@id_s, _method(@repo, 'getID', @uuid_s))

    _method(@repo, 'deleteID', @id_w)
    _method(@repo, 'deleteUUID', @uuid_v)
    _method(@repo, 'deleteID', @id_s)

    _assert_null(_method(@repo, 'getUUID', @id_w))
    _assert_null(_method(@repo, 'getUUID', @id_v))
    _assert_null(_method(@repo, 'getUUID', @id_s))

    _assert_null(_method(@repo, 'getID', @uuid_w))
    _assert_null(_method(@repo, 'getID', @uuid_v))
    _assert_null(_method(@repo, 'getID', @uuid_s))

    @path = get_absolute_path('out'._util_sdn().'entity_repo'._util_sdn().'_test1')
    _util_make_folder(@path, -4)
    @repo = _entity_repo_init(@path)

    _assert_null(_method(@repo, 'getUUID', @id_w))
    _assert_null(_method(@repo, 'getUUID', @id_v))
    _assert_null(_method(@repo, 'getUUID', @id_s))

    _assert_null(_method(@repo, 'getID', @uuid_w))
    _assert_null(_method(@repo, 'getID', @uuid_v))
    _assert_null(_method(@repo, 'getID', @uuid_s))
    try {
        if (is_entity_living(@uuid_w)) {
            entity_remove(@uuid_w)
        }
        if (is_entity_living(@uuid_v)) {
            entity_remove(@uuid_v)
        }
        if (is_entity_living(@uuid_s)) {
            entity_remove(@uuid_s)
        }
    } catch (BadEntityException @e) {
        _print('Entity very dast died')
    }
}

proc _after_all() {
    delete_file('out'._util_sdn().'entity_repo')
}