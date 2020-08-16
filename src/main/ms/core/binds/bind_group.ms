unbind('msquest:group:player_interact_entity-lowest')
bind('player_interact_entity', array(id: 'msquest:group:player_interact_entity-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: entity_loc(@event['id'])['world'],
                biome: get_biome(entity_loc(@event['id'])),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'player_interact_entity')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: @event['player'],
                entity: @event['id'],
                model: @model,
                action: 'player_interact_entity',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_damage-lowest')
bind('entity_damage', array(id: 'msquest:group:entity_damage-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['world'],
                biome: get_biome(entity_loc(@event['id'])),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_damage')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: if (array_index_exists(@event, 'damager') && array_contains(all_players(), @event['damager']), @event['damager'], null),
                entity: @event['id'],
                model: @model,
                action: 'entity_damage',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_damage_player-lowest')
bind('entity_damage_player', array(id: 'msquest:group:entity_damage_player-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['location']['world'],
                biome: get_biome(@event['location']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_damage_player')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: @event['player'],
                entity: @event['id'],
                model: @model,
                action: 'entity_damage_player',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_death-lowest')
bind('entity_death', array(id: 'msquest:group:entity_death-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['location']['world'],
                biome: get_biome(@event['location']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_death')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: if (array_index_exists(@event['cause'], 'damager') && array_contains(all_players(), @event['cause']['damager']), @event['cause']['damager'], null),
                entity: @event['id'],
                model: @model,
                action: 'entity_death',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_explode-lowest')
bind('entity_explode', array(id: 'msquest:group:entity_explode-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['location']['world'],
                biome: get_biome(@event['location']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_explode')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: null,
                entity: @event['id'],
                model: @model,
                action: 'entity_explode',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_regain_health-lowest')
bind('entity_regain_health', array(id: 'msquest:group:entity_regain_health-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @location = entity_loc(@event['id'])
        @game_event = _init_game_event(
            associative_array(
                world: @location['world'],
                biome: get_biome(@location),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_regain_health')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: null,
                entity: @event['id'],
                model: @model,
                action: 'entity_regain_health',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:entity_portal_travel-lowest')
bind('entity_portal_travel', array(id: 'msquest:group:entity_portal_travel-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['from']['world'],
                biome: get_biome(@event['from']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'entity_portal_travel')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: null,
                entity: @event['id'],
                model: @model,
                action: 'entity_portal_travel',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:projectile_hit-lowest')
bind('projectile_hit', array(id: 'msquest:group:projectile_hit-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['shooter']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['location']['world'],
                biome: get_biome(@event['location']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'projectile_hit')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: null,
                entity: @event['shooter'],
                model: @model,
                action: 'projectile_hit',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:projectile_launch-lowest')
bind('projectile_launch', array(id: 'msquest:group:projectile_launch-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['shooter']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: @event['location']['world'],
                biome: get_biome(@event['location']),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'projectile_launch')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: null,
                entity: @event['shooter'],
                model: @model,
                action: 'projectile_launch',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

unbind('msquest:group:target_player-lowest')
bind('target_player', array(id: 'msquest:group:target_player-lowest', priority: 'LOWEST'), null, @event, @model) {
    @group_repo = @model['repo']['group']
    if(!(@groups = _method(@group_repo, 'getGroups', @event['id']))) {
        return()
    }
    foreach(@group in @groups) {
        @game_event = _init_game_event(
            associative_array(
                world: entity_loc(@event['id'])['world'],
                biome: get_biome(entity_loc(@event['id'])),
                type: 'GROUP',
                id: _group_event_get_id(@group, 'target_player')
            )
        )
        @events = _method(@model['event']['map'], 'getEvents', @game_event)
        @c = @model['scripts']['commander']
        foreach(@user_event in @events) {
            @id = _method(@user_event, 'getUUID')

            _api_model_init(array(
                quest: @user_event['quest'],
                player: @event['player'],
                entity: @event['id'],
                model: @model,
                action: 'target_player',
                event: @event,
                dialog: if (array_index_exists(@model['dialogs']['mapUUID'], @id), @model['dialogs']['mapUUID'][@id], null)
            ))

            _util_commander_execute(@c, @id)

            _after_event()
        }
    }
}

