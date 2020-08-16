proc _bind_custom_event(string @id, mixed @event, array @model) {
    @game_event = _init_game_event(
        associative_array(
            world: if (player() != '~console', ploc()['world'], 'world'),
            biome: if (player() != '~console', get_biome(ploc()), '__unknown__'),
            type: 'CUSTOM',
            id: _custom_event_get_id(@id)
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        _api_model_init(array(
            quest: @user_event['quest'],
            player: player(),
            model: @model,
            event: @event,
            'bind': false,
            dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
        ))
        _util_commander_execute(@c, @id)
        _after_event()
    }
}

execute(closure(){
    register_command('qevent', array(
        'description': 'Quest custom event starter',
        'usage': '/qevent',
        'executor': closure() {
            @args = @arguments[2]
            if (array_size(@args) == 0) {
                _error('No arguments')
            }
            @id = @args[0]
            @event = null
            if (array_size(@args) > 1) {
                try {
                    @event = json_decode(if ((array_size(@args) == 2), @args[1], array_implode(@args[1..])))
                } catch(FormatException @e) {
                    _error(@e['message'])
                }
            }
            _bind_custom_event(@id, @event, @model)
        }
    ))
}) 