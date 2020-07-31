proc _map_events_export(array @model) {
    export('org.cadabra.msquest.event_map', @model)
}

array proc _map_events_import() {
    return(import('org.cadabra.msquest.event_map'))
}

proc _map_events_init() {
    @model = array()
    @model['id'] = 1
    @model['map_event_ID'] = associative_array()
    @model['map_ID_event'] = associative_array()
    _map_events_export(@model)
}

int proc _map_events_register(array @event) {
    @model = _map_events_import()
    @map = @model['map_event_ID']
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
            @events[@id][] = @event
        }
    }
    @id = @model['id']
    @event['registed_id'] = @id
    @model['map_ID_event'][@id] = @event
    @model['id'] = @id + 1
    return(@event['registed_id'])
}

array proc _map_event_get_id(array @game_event) {
    @map = _map_events_import()['map_event_ID']
    if (!array_index_exists(@map, @game_event['type'])) {
        return(null)
    }
    
    @events = @map[@game_event['type']]
    if (!array_index_exists(@events, @game_event['id'])) {
        return(null)
    }
    
    @ids = array()
    foreach(@event in @events[@game_event['id']]) {
        if (_method(@event, 'test', @game_event['info'])) {
            @ids[] = @event['registed_id']
        }
    }
    return(@ids)
}

// array proc _map_events_save() {
//     @model = _map_events_import()['map_event_ID']
//     return(_util_delete_closures(@model))
// }

// proc _map_events_load(array @load) {
//     __map_events_init()
//     include(_get_src('core.event.details.ms'))
//     include(_get_src('core.event.events.ms'))

//     foreach(@e in @load) {
//         @e['test'] = import('org.cadabra.msquest.events')['test']
//         @e['get_id'] = import('org.cadabra.msquest.events')['get_id']
//         foreach(@d in @e['details']) {
//             @d['test'] = import('org.cadabra.msquest.details')[@d['type']]
//         }
//     }
// }