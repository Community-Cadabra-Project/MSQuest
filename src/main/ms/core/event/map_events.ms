include('game_event.ms')
include('event_id_procs.ms')

array proc _map_events_init() {
    @self = array()
    @self['map_event_id'] = associative_array()
    @self['map_id_event'] = associative_array()
    foreach(@key: @method in import('org.cadabra.msquest.map_events')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    @methods = associative_array()

    @methods['register'] = closure(array @self, array @event) {
        @map = @self['map_event_id']
        if (!array_index_exists(@map, @event['type'])) {
            @events = associative_array()
            @map[@event['type']] = @events
            @events[_method(@event, 'getID')] = array(@event)
        } else {
            @events = @map[@event['type']]
            @id = _method(@event, 'getID')
            if (!array_index_exists(@events, @id)) {
                @events[@id] = array(@event)
            } else {
                @events[@id][] = @event
            }
        }
        @id = uuid()
        @event['registed_id'] = @id
        @self['map_id_event'][@id] = @event
        return(@event['registed_id'])
    }

    @methods['getEvents'] = closure(array @self, array @game_event) {
        @map = @self['map_event_id']
        if (!array_index_exists(@map, @game_event['type'])) {
            return(array())
        }

        @events = @map[@game_event['type']]
        if (!array_index_exists(@events, @game_event['id'])) {
            return(array())
        }

        @ids = array()
        foreach(@event in @events[@game_event['id']]) {
            if (_method(@event, 'test', @game_event['info'])) {
                @ids[] = @event
            }
        }
        return(@ids)
    }

    export('org.cadabra.msquest.map_events', @methods)
})