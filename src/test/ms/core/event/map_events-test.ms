proc _test_to_register() {

    include(_get_src('core.event.details.ms'))
    include(_get_src('core.event.events.ms'))
    include(_get_src('core.event.bind.ms'))

    array proc _bind_import() {
        return(import('org.cadabra.msquest.bind-test'))
    }
    proc _bind_export(array @model) {
        export('org.cadabra.msquest.bind-test', @model)
    }

    _bind_init()

    _bind_events(
        _quest_event('interactive', 'quest3'),
        _game_time(12, 24)
    )
    _assert_size(1, _bind_import()['events'], _bind_import())

    _bind_events(
        _entity_event('npc', 'interactive', 'quest1'),
        _quest_event('interactive', 'quest2'),
        _world('world'),
        _biome('mountains'),
        _game_time(0, 24)
    )
    _assert_size(3, _bind_import()['events'], _bind_import())

    _bind_events(
        _quest_event('interactive', 'quest3'),
        _game_time(0, 6), _game_time(8, 15)
    )
    _assert_size(4, _bind_import()['events'], _bind_import())
    
    @evs = _bind_import()['events']
    @map = _map_events_init()
    foreach(@event in @evs) {
        _method(@map, 'register', @event)
    }

    array @ids = _method(@map, 'getEvents', array(
        type: 'QUEST',
        id: 'QUEST$interactive',
        info: array(
            game: array(
                time: 13,
                biome: 'mountains',
                world: 'world'
            )
        )
    ))
    _assert_equals(
        array(
            _method(@evs[0], 'getUUID'), _method(@evs[2], 'getUUID'), _method(@evs[3], 'getUUID')
        ),
        array_map(@ids, closure(@v) {return(_method(@v, 'getUUID'))}),
        @ids
    )

    @ids = _method(@map, 'getEvents', array(
        type: 'QUEST',
        id: 'QUEST$interactive',
        info: array(
            game: array(
                time: 5,
                biome: 'mountains',
                world: 'world'
            )
        )
    ))
    _assert_equals(
        array(
            _method(@evs[2], 'getUUID'), _method(@evs[3], 'getUUID')
        ),
        array_map(@ids, closure(@v) {return(_method(@v, 'getUUID'))})
    )

    @ids = _method(@map, 'getEvents', array(
        type: 'QUEST',
        id: 'QUEST$interactive',
        info: array(
            game: array(
                time: 7,
                biome: 'badlands',
                world: 'world'
            )
        )
    ))
    _assert_equals(array(), array_map(@ids, closure(@v) {return(_method(@v, 'getUUID'))}))
}