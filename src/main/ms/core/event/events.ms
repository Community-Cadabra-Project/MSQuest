execute(closure() {
    @methods = array()
    @methods['test'] = closure(array @info_event, array @o) {
        foreach(@types in @o['details']) {
            @res = false
            foreach(@detail in @types) {
                if (execute(@info_event, @detail, @detail['test'])) {
                    @res = true
                    break()
                }
            }
            if (!@res) {
                return(false)
            }
        }
        return(true)
    }
    export('org.cadabra.msquest.events', @methods)
    @methods['get_id'] = closure(array @o) {
        return(@o['id'].'$'.@o['action'])
    }
})

proc _entity_event(string @entity, string @action, string @quest = null) {
    @o = associative_array()
    @o = array()
    @o['type'] = 'ENTITY'
    @o['class'] = 'Event'
    @o['details'] = array()

    @o['test'] = import('org.cadabra.msquest.events')['test']
    @o['get_id'] = import('org.cadabra.msquest.events')['get_id']

    @o['id'] = @entity
    @o['action'] = @action
    @o['quest'] = @quest
    return(@o)
}

proc _quest_event(string @action, string @quest = null) {
    @o = associative_array()
    @o['type'] = 'QUEST'
    @o['class'] = 'Event'
    @o['details'] = array()

    @o['test'] = import('org.cadabra.msquest.events')['test']
    @o['get_id'] = import('org.cadabra.msquest.events')['get_id']

    @o['id'] = 'static_event'
    @o['action'] = @action
    @o['quest'] = @quest
    return(@o)
}

