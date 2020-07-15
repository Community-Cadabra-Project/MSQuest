execute(closure() {
    @model = array()
    @model['id'] = 1
    @model['map'] = array()
    export('org.cadabra.msquest.event_map', @model)
})

int proc _map_events_register(array @event) {
    @model = import('org.cadabra.msquest.event_map')
    @map = @model['map']
    if (!array_index_exists(@map, @event['type'])) {
        @events = array()
        @map[@event['type']] = @events
        @events[_method(@event, 'get_id')] = array(@event)
    } else {
        @events = @map[@event['type']]
        @id = _method(@event, 'get_id')
        if (!array_index_exists(@events, @id)) {
            @events[@id] = array(@event)
        } else {
            array_push(@events[@id], @event)
        }
    }
    @event['registed_id'] = @model['id']
    @model['id'] += 1
    return(@event['registed_id'])
}

array proc _map_event_get_id(array @game_event) {
    @map = import('org.cadabra.msquest.event_map')['map']
    if (!array_index_exists(@map, @game_event['type'])) {
        return(null)
    }
    
    @events = @map[@game_event['type']]
    if (!array_index_exists(@events, @game_event['id']))) {
        return(null)
    }

    @ids = array()
    foreach(@event in @events[@game_event['id']]) {
        if (_method1(@event, 'test', @game_event['info'])) {
            array_push(@ids, @event['registed_id'])
        }
    }
    return(if(array_size(@ids) == 0, null, @ids))
}