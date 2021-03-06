array proc _bind_import() {
    return(import('org.cadabra.msquest.bind'))
}

proc _bind_export(array @model) {
    export('org.cadabra.msquest.bind', @model)
}

proc _bind_init() {
    @model = array()
    @model['events'] = array()
    @model['dialog'] = null
    _bind_export(@model)
}

proc _bind_events() {
    @class_events = _events_get_all_classes()
    if (array_size(@arguments) < 1) {
        throw(IllegalArgumentException, 'Procedure parameter signature is {events|[details...]}')
    }
    @events = array_filter(@arguments, closure(@k, @v){
        return(array_contains(@class_events, @v['class']))
    })
    @details = array_sort(
        array_filter(
            @arguments,
            closure(@k, @v) {return(@v['class'] == 'DetailEvent')}
        ),
        closure(@l, @r) {return(@l['priority'] > @r['priority'])}
    )

    @result = array()
    if (@details) {
        @arr = array()
        @cur = @details[0]['priority']
        foreach(@d in @details) {
            if (@cur == @d['priority']) {
                @arr[] = @d
            } else {
                @cur = @d['priority']
                @result[] = @arr
                @arr = array(@d)
            }
        }
        @result[] = @arr
    }
    
    @ids = array()
    foreach(@event in @events) {
        @event['details'] = @result
    }
    @model = _bind_import()
    array_push_all(@model['events'], @events)
}

proc _bind_dialog(string @dialog) {
    @model = _bind_import()
    @model['dialog'] = @dialog
}