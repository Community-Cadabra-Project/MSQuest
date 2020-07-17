proc _test_to_register() {

    proc _map_events_export(mixed @model) {
        export('org.cadabra.msquest.event_map-test', @model)
    }

    array proc _map_events_import(mixed @model) {
        return(import('org.cadabra.msquest.event_map-test'))
    }

    _map_events_init()

    include(_util_includer_get_path('org.cadabra.msquest.event.details'))
    include(_util_includer_get_path('org.cadabra.msquest.event.events'))
    include(_util_includer_get_path('org.cadabra.msquest.event.bind'))

    _bind_events(
        _quest_event('interactive', 'quest3'),
        _game_time(12, 24),
        _week_time(5, 7)
    )
    _assert_equals(array(1), _bind_import()['ids'], _bind_import())
    _bind_clear()

    _bind_events(
        _entity_event('npc', 'interactive', 'quest1'),
        _quest_event('interactive', 'quest2'),
        _world('world'),
        _biome('mountains'),
        _game_time(0, 24),
        _year_time(0, 3000),
        _month_time(0, 12),
        _day_time(0, 31),
        _week_time(0, 7),
        _hour_time(0, 24)
    )
    _assert_equals(array(2, 3), _bind_import()['ids'], _bind_import())
    _bind_clear()

    array @ids = _map_event_get_id(array(
        type: 'QUEST',
        id: 'static_event$interactive',
        info: array(
            game: array(
                time: 13,
                biome: 'mountains',
                world: 'world'
            ),
            time: array(
                year: 2020,
                month: 11,
                day: 24,
                week: 6,
                hour: 13
            )
        )
    ))
    _assert_equals(array(1, 3), @ids)

    @ids = _map_event_get_id(array(
        type: 'QUEST',
        id: 'static_event$interactive',
        info: array(
            game: array(
                time: 11,
                biome: 'mountains',
                world: 'world'
            ),
            time: array(
                year: 2020,
                month: 11,
                day: 24,
                week: 6,
                hour: 13
            )
        )
    ))
    _assert_equals(array(3), @ids)
    _map_events_clear()
}