proc _register_as() {
    _bind_dialog('dialog')
    _bind_events(
        _entity_event('npc', 'interactive', 'quest1'),
        _quest_event('sleep', 'quest2'),
        _world('world'),
        _biome('mountains'),
        _game_time(0, 12), _game_time(13, 24),
        _year_time(0, 3000),
        _month_time(0, 12),
        _day_time(0, 31),
        _week_time(0, 7),
        _hour_time(0, 24)
    )
}

proc _script_run() {
    
}