proc _before_each() {
    return(_qprogress_repo_init(get_absolute_path('out'._util_sdn().'qprogress')))
}

proc _init_temp() {
    @path = _unit_resource('stage.stage.yml')
    @temp = yml_decode(read(@path))
    return(@temp)
}

proc _test(@qp_repo) {
    @progress = _init_temp('player')
    @qp = _qprogress_default(_init_temp())
    
    @qp['quest'] = 'test-1'
    _method(@qp_repo, 'save', array_deep_clone(@qp))

    @qp['quest'] = 'test-2'
    _method(@qp_repo, 'save', array_deep_clone(@qp))

    @qp['quest'] = 'test-3'
    _method(@qp_repo, 'save', array_deep_clone(@qp))

    _method(@qp_repo, 'clearCache')
    _assert_false_obj(@qp_repo['cache'])

    @qp['quest'] = 'test-1'
    _assert_equals(@qp, _method(@qp_repo, 'get', 'test-1'))

    @qp['quest'] = 'test-2'
    _assert_equals(@qp, _method(@qp_repo, 'get', 'test-2'))

    @qp['quest'] = 'test-3'
    _assert_equals(@qp, _method(@qp_repo, 'get', 'test-3'))

    _assert_true(_method(@qp_repo, 'delete', 'test-1'))
    _assert_true(_method(@qp_repo, 'delete', 'test-2'))
    _assert_true(_method(@qp_repo, 'delete', 'test-3'))

    _assert_null(_method(@qp_repo, 'get', 'test-1'))
    _assert_null(_method(@qp_repo, 'get', 'test-2'))
    _assert_null(_method(@qp_repo, 'get', 'test-3'))
}
