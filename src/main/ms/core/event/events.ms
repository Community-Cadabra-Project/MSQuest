array proc _entity_event(string @entity, string @action, string @quest = null) {
    @self = associative_array()
    @self = array()
    @self['type'] = 'ENTITY'
    @self['class'] = 'Event'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['id'] = @entity
    @self['action'] = @action
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')) {
        @self[@key] = @method
    }
    return(@self)
}

array proc _quest_event(string @action, string @quest = null) {
    @self = associative_array()
    @self['type'] = 'QUEST'
    @self['class'] = 'Event'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['id'] = '__static_event__'
    @self['action'] = @action
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    @methods = array()
    @methods['test'] = closure(array @self, array @info_event) {
        foreach(@types in @self['details']) {
            @res = false
            foreach(@detail in @types) {
                if (_method(@detail, 'test', @info_event)) {
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
    @methods['getID'] = closure(array @self) {
        return(_event_to_id(@self['id'], @self['action']))
    }
    @methods['getUUID'] = closure(array @self) {
        return(@self['registed_id'])
    }
    export('org.cadabra.msquest.events', @methods)
})


