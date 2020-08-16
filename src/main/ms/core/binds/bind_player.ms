unbind('msquest:quest:player_death-lowest')
bind('player_death', array(id: 'msquest:quest:player_death-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: ploc(@event['player'])['world'],
            biome: get_biome(ploc(@event['player'])),
            type: 'QUEST',
            id: _quest_event_get_id('player_death')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_death',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_enter_bed-lowest')
bind('player_enter_bed', array(id: 'msquest:quest:player_enter_bed-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['location']['world'],
            biome: get_biome(@event['location']),
            type: 'QUEST',
            id: _quest_event_get_id('player_enter_bed')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_enter_bed',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_join-lowest')
bind('player_join', array(id: 'msquest:quest:player_join-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['world'],
            biome: get_biome(ploc(@event['player'])),
            type: 'QUEST',
            id: _quest_event_get_id('player_join')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_join',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_kick-lowest')
bind('player_kick', array(id: 'msquest:quest:player_kick-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: ploc(@event['player'])['world'],
            biome: get_biome(ploc(@event['player'])),
            type: 'QUEST',
            id: _quest_event_get_id('player_kick')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_kick',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_leave_bed-lowest')
bind('player_leave_bed', array(id: 'msquest:quest:player_leave_bed-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['location']['world'],
            biome: get_biome(@event['location']),
            type: 'QUEST',
            id: _quest_event_get_id('player_leave_bed')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_leave_bed',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_portal_travel-lowest')
bind('player_portal_travel', array(id: 'msquest:quest:player_portal_travel-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['from']['world'],
            biome: get_biome(@event['from']),
            type: 'QUEST',
            id: _quest_event_get_id('player_portal_travel')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_portal_travel',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_quit-lowest')
bind('player_quit', array(id: 'msquest:quest:player_quit-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: ploc(@event['player'])['world'],
            biome: get_biome(ploc(@event['player'])),
            type: 'QUEST',
            id: _quest_event_get_id('player_quit')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_quit',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_spawn-lowest')
bind('player_spawn', array(id: 'msquest:quest:player_spawn-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['location']['world'],
            biome: get_biome(@event['location']),
            type: 'QUEST',
            id: _quest_event_get_id('player_spawn')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_spawn',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:player_teleport-lowest')
bind('player_teleport', array(id: 'msquest:quest:player_teleport-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['from']['world'],
            biome: get_biome(@event['from']),
            type: 'QUEST',
            id: _quest_event_get_id('player_teleport')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'player_teleport',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:world_changed-lowest')
bind('world_changed', array(id: 'msquest:quest:world_changed-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['from']['world'],
            biome: get_biome(@event['from']),
            type: 'QUEST',
            id: _quest_event_get_id('world_changed')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: @event['player'],
            entity: null,
            model: @model,
            action: 'world_changed',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}

unbind('msquest:quest:item_despawn-lowest')
bind('item_despawn', array(id: 'msquest:quest:item_despawn-lowest', priority: 'LOWEST'), null, @event, @model) {
    @entity_repo = @model['repo']['entity']
    @game_event = _init_game_event(
        associative_array(
            world: @event['location']['world'],
            biome: get_biome(@event['location']),
            type: 'QUEST',
            id: _quest_event_get_id('item_despawn')
        )
    )
    @events = _method(@model['event']['map'], 'getEvents', @game_event)
    @c = @model['scripts']['commander']
    foreach(@user_event in @events) {
        @id = _method(@user_event, 'getUUID')
        
        _api_model_init(array(
            quest: @user_event['quest'],
            player: null,
            entity: null,
            model: @model,
            action: 'item_despawn',
            event: @event,
            dialog: @model['dialogs']['mapUUID'][@id]
        ))

        _util_commander_execute(@c, @id)

        _after_event()
    }
}