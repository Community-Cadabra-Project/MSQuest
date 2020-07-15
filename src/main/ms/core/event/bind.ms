execute(closure() {
    @model = array()
    @model['ids'] = array()
    @model['dialog'] = null
    export('org.cadabra.msquest.bind', @model)
})

proc _bind_import() {
    return(import('org.cadabra.msquest.bind'))
}

proc _bind_events() {
    if (arrays_size(@arguments) < 1) {
        throw(IllegalArgumentException, 'Procedure parameter signature is {events|details...}')
    }
    @events = array_filter(@arguments, closure(@k, @v) {@v['class'] == 'Event'})
    @details = array_sort(
        array_filter(
            @arguments,
            closure(@k, @v) {@v['class'] == 'DetailEvent'}
        ),
        closure(@l, @r) {@l['priority'] > @r['priority']}
    )
    @ids = array()
    foreach(@event in @events) {
        @event['details'] = @details
        array_push(@ids, _map_events_register(@event))
    }
    @model = import('org.cadabra.msquest.bind')
    array_push_all(@model['ids'], @ids)
}

proc _bind_dialog(string @dialog) {
    @model['dialog'] = @dialog
}