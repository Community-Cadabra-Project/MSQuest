proc _before_each() {
    @path = get_absolute_path('out'._util_sdn().'pprogress')
    _util_make_folder(@path, -3)
    return(_pprogress_repo_init(@path))
}

proc _init_progress(string @player) {
    @path = _unit_resource('stage.stage.yml')
    @temp = yml_decode(read(@path))
    @progress = _pprogress_init(@temp, _pprogress_default_data(@player, @temp))
    return(@progress)
}

proc _test1(@pprogress_repo) {
    @progress = _init_progress('player1')
    @pprogress = _method(@progress, 'getData')
    _method(@pprogress_repo, 'save', @pprogress)

    _assert_true(_method(@pprogress_repo, 'delete', @pprogress['quest'], @pprogress['player']))
    _assert_null(_method(@pprogress_repo, 'get', @pprogress['quest'], @pprogress['player']))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', @pprogress['player']))
}

proc _test2(@pprogress_repo) {
    @progress = _init_progress('player2')
    @progress['quest'] = 'test'
    @pprogress = _method(@progress, 'getData')
    _method(@pprogress_repo, 'save', @pprogress)

    @cache = _private_method(@pprogress_repo, 'getCache', @pprogress['quest'], @pprogress['player'])
    _assert_equals(@pprogress, @cache)

    _private_method(@pprogress_repo, 'deleteCache', @pprogress['quest'], @pprogress['player'])

    @cache = _private_method(@pprogress_repo, 'getCache', @pprogress['quest'], @pprogress['player'])
    _assert_null(@cache)

    @get = _method(@pprogress_repo, 'get', @pprogress['quest'], @pprogress['player'])
    _assert_equals(@pprogress, @get)

    @pprogress['player'] = 'player3'
    _method(@pprogress_repo, 'save', @pprogress)

    _assert_true(_method(@pprogress_repo, 'deleteQuest', 'test'))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', 'player2'))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', 'player3'))
}