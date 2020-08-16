unbind('msquest:entity_death-monitor')
bind('entity_death', array(id: 'msquest:entity_death-monitor', priority: 'MONITOR'), null, @event, @model) {
    @uuid = @event['id']

    @group_repo = @model['repo']['group']
    if(@groups = _method(@group_repo, 'getGroups', @uuid)) {
        _method(@group_repo, 'deleteUUID', @uuid)
        @cause = if (array_index_exists(@event['cause'], 'damager'), @event['cause']['cause'].' - '.@event['cause']['damager'], @event['cause']['cause'])
        _log('INFO', "Entity @uuid of groups @groups deleted because it is dead. Cause: @cause")
    }

    @entity_repo = @model['repo']['entity']
    if (@id = _method(@entity_repo, 'getID', @uuid)) {
        _method(@model, 'removeNPC', @id)
        @cause = if (array_index_exists(@event['cause'], 'damager'), @event['cause']['cause'].' - '.@event['cause']['damager'], @event['cause']['cause'])
        _log('INFO', "NPC @id - @uuid deleted because it is dead. Cause: @cause")
    }   
}

unbind('msquest:player_quit-monitor')
bind('player_quit', array(id: 'msquest:player_quit-monitor', priority: 'LOWEST'), null, @event, @model) {
    @player_repo = @model['repo']['player']
    @player = @event['player']
    _method(@player, 'deletePlayerCache', @event['player'])
}