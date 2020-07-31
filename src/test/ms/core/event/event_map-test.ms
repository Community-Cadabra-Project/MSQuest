proc _test_to_register() {

    include(_get_src('core.event.details.ms'))
    include(_get_src('core.event.events.ms'))
    include(_get_src('core.event.bind.ms'))
    include('rewrite-ign.ms')

    _bind_init()
    _map_events_init()

    _bind_events(
        _quest_event('interactive', 'quest3'),
        _game_time(12, 24),
        _week_time(5, 7)
    )
    _assert_equals(array(1), _bind_import()['ids'], _bind_import())

    _bind_init()
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

    _bind_init()
    _bind_events(
        _quest_event('interactive', 'quest3'),
        _game_time(0, 6), _game_time(8, 15)
    )
    _assert_equals(array(4), _bind_import()['ids'], _bind_import())
    
    _bind_init()
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
    _assert_equals(array(1, 3, 4), @ids)

    @ids = _map_event_get_id(array(
        type: 'QUEST',
        id: 'static_event$interactive',
        info: array(
            game: array(
                time: 5,
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
    _assert_equals(array(3, 4), @ids)

    @ids = _map_event_get_id(array(
        type: 'QUEST',
        id: 'static_event$interactive',
        info: array(
            game: array(
                time: 7,
                biome: 'badlands',
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
    _assert_equals(array(), @ids)
    // _map_events_init()
}