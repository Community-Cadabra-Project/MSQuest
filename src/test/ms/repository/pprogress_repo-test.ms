proc _before_each() {
    return(_pprogress_repo_init(get_absolute_path('out\\pprogress')))
}

proc _init_progress(string @player) {
    @path = 'resource\\stage.yml'
    @temp = yml_decode(read(@path))
    @progress = _progress_init(@temp, _qprogress_default(@temp), _pprogress_default(@player, @temp))
    return(@progress)
}

proc _test1(@pprogress_repo) {
    @progress = _init_progress('player1')
    @pprogress = _method(@progress, 'getPProgress')
    _method(@pprogress_repo, 'save', @pprogress)

    _assert_true(_method(@pprogress_repo, 'delete', @pprogress['quest'], @pprogress['player']))
    _assert_null(_method(@pprogress_repo, 'get', @pprogress['quest'], @pprogress['player']))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', @pprogress['player']))
}

proc _test2(@pprogress_repo) {
    @progress = _init_progress('player2')
    @progress['quest'] = 'test'
    @pprogress = _method(@progress, 'getPProgress')
    _method(@pprogress_repo, 'save', @pprogress)

    @cash = _private_method(@pprogress_repo, 'getCash', @pprogress['quest'], @pprogress['player'])
    _assert_equals(@pprogress, @cash)

    _private_method(@pprogress_repo, 'deleteCash', @pprogress['quest'], @pprogress['player'])

    @cash = _private_method(@pprogress_repo, 'getCash', @pprogress['quest'], @pprogress['player'])
    _assert_null(@cash)

    @get = _method(@pprogress_repo, 'get', @pprogress['quest'], @pprogress['player'])
    _assert_equals(@pprogress, @get)

    @pprogress['player'] = 'player3'
    _method(@pprogress_repo, 'save', @pprogress)

    _assert_true(_method(@pprogress_repo, 'deleteQuest', 'test'))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', 'player2'))
    _assert_true(_method(@pprogress_repo, 'deletePlayer', 'player3'))
}