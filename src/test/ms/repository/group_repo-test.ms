proc _before_all() {
    string @path_to_npc = _unit_resource('npc')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    @entities = array()
    foreach(@file in @files) {
        @group = @file[cslice(@len_npc+1, -5)]
        try {
            @entities[@group] = yml_decode(read(@file))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(array(@entities, _entity_creater_init()))
}

proc _before_each(@test) {
    @path = get_absolute_path('out'._util_sdn().'group_repo'._util_sdn().@test)
    _util_make_folder(@path, -4)
    return(_group_repo_init(@path))
}

proc _test(@all, @repo) {
    # Cause x_run_on_main_thread_now
    _assert_time_limit(0.4, 0.5)
    @entities = @all[0]
    @creater = @all[1]

    @group_w = @entities['witch']['main']['group']

    @uuid_w_1 = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['witch']))}
    )
    _method(@repo, 'save', array(@uuid_w_1), @group_w)

    @uuid_w_2 = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['witch']))}
    )
    _method(@repo, 'save', array(@uuid_w_2), @group_w)

    @group_v = @entities['village']['main']['group']

    @uuid_v_1 = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['village']))}
    )
    _method(@repo, 'save', array(@uuid_v_1), @group_v)
    @uuid_v_2 = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['village']))}
    )
    _method(@repo, 'save', array(@uuid_v_2), @group_v)

    @uuid_s = x_run_on_main_thread_now(
        closure() {return(_method(@creater, 'create', @entities['slime']))}
    )
    _method(@repo, 'save', array(@uuid_s), @group_v)
    _method(@repo, 'save', array(@uuid_s), @group_w)

    _assert_equals(array(@uuid_w_1, @uuid_w_2, @uuid_s), _method(@repo, 'getUUIDs', @group_w[0]))
    _assert_equals(array(@uuid_v_1, @uuid_v_2, @uuid_s), _method(@repo, 'getUUIDs', @group_v[0]))

    _assert_equals(@group_w, _method(@repo, 'getGroups', @uuid_w_1))
    _assert_equals(@group_w, _method(@repo, 'getGroups', @uuid_w_2))
    _assert_equals(@group_v, _method(@repo, 'getGroups', @uuid_v_1))
    _assert_equals(@group_v, _method(@repo, 'getGroups', @uuid_v_2))
    _assert_equals(array_merge(@group_v, @group_w), _method(@repo, 'getGroups', @uuid_s))

    _method(@repo, 'deleteGroup', @group_w[0])
    _method(@repo, 'deleteGroup', @group_v[0])

    _assert_empty(_method(@repo, 'getUUIDs', @group_w[0]))
    _assert_empty(_method(@repo, 'getUUIDs', @group_v[0]))

    _assert_empty(_method(@repo, 'getGroups', @uuid_w_1))
    _assert_empty(_method(@repo, 'getGroups', @uuid_w_2))
    _assert_empty(_method(@repo, 'getGroups', @uuid_v_1))
    _assert_empty(_method(@repo, 'getGroups', @uuid_v_2))
    _assert_empty(_method(@repo, 'getGroups', @uuid_s))

    @path = get_absolute_path('out'._util_sdn().'group_repo'._util_sdn().'_test1')
    _util_make_folder(@path, -4)
    @repo = _group_repo_init(@path)

    _assert_empty(_method(@repo, 'getUUIDs', @group_w[0]))
    _assert_empty(_method(@repo, 'getUUIDs', @group_v[0]))

    _assert_empty(_method(@repo, 'getGroups', @uuid_w_1))
    _assert_empty(_method(@repo, 'getGroups', @uuid_w_2))
    _assert_empty(_method(@repo, 'getGroups', @uuid_v_1))
    _assert_empty(_method(@repo, 'getGroups', @uuid_v_2))
    _assert_empty(_method(@repo, 'getGroups', @uuid_s))
    try {
        if (is_entity_living(@uuid_w_1)) {
            entity_remove(@uuid_w_1)
        }
        if (is_entity_living(@uuid_w_2)) {
            entity_remove(@uuid_w_2)
        }
        if (is_entity_living(@uuid_v_1)) {
            entity_remove(@uuid_v_1)
        }
        if (is_entity_living(@uuid_v_2)) {
            entity_remove(@uuid_v_2)
        }
        if (is_entity_living(@uuid_s)) {
            entity_remove(@uuid_s)
        }
    } catch (BadEntityException @e) {
        _print('Entity catch timing dead')
    }
}

proc _after_all() {
    delete_file('out'._util_sdn().'group_repo')
}