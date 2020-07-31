proc _before_each() {
    return(_player_progress_init(get_absolute_path('out')))
}

proc _init_progress(string @player) {
    @path = 'resource\\stage.yml'
    @quest_progress = yml_decode(read(@path))
    @progress = _progress_init(@player, @quest_progress, null)
    return(@progress)
}

proc _test_save_and_delete(@saver) {
    @progress = _init_progress('player1')
    @pp = _method(@progress, 'getPlayerProgress')
    _method(@saver, 'save', @pp)

    _method(@saver, 'delete', @pp['quest'], @pp['player'])
    _assert_null(_method(@saver, 'get', @pp['quest'], @pp['player']))
    _assert_true(_method(@saver, 'deletePlayer', @pp['player']))
}

proc _test_cash_and_delete(@saver) {
    @progress = _init_progress('player2')
    @progress['quest'] = 'test'
    @pp = _method(@progress, 'getPlayerProgress')
    _method(@saver, 'save', @pp)

    @cash = _method(@saver, 'getCash', @pp['quest'], @pp['player'])
    _assert_equals(@pp, @cash)

    _method(@saver, 'deleteCash', @pp['quest'], @pp['player'])

    @cash = _method(@saver, 'getCash', @pp['quest'], @pp['player'])
    _assert_null(@cash)

    @get = _method(@saver, 'get', @pp['quest'], @pp['player'])
    _assert_equals(@pp, @get)

    @pp['player'] = 'player3'
    _method(@saver, 'save', @pp)

    _assert_true(_method(@saver, 'deleteQuest', 'test'))
    _assert_true(_method(@saver, 'deletePlayer', 'player2'))
    _assert_true(_method(@saver, 'deletePlayer', 'player3'))
}