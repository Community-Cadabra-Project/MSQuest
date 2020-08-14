proc _register_as() {
    _bind_dialog('dialog1')
    _bind_events(
        _entity_event('npc', 'interactive', 'quest1'),
        _quest_event('sleep', 'quest2'),
        _world('WoW'),
        _biome('unknown'),
        // _game_time(25, -1),
        // _year_time(-1, -20),
        // _month_time(20, -4),
        // _day_time(40, -1),
        // _week_time(25, -1),
        // _hour_time(25, -1),
        array()
    )
    _bind_events()
    _bind_dialog('dialog2')
    _bind_import(123)
    _unknown_proc()
}