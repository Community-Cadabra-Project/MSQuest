array proc _entity_event(string @entity, string @action, string @quest = null) {
    @self = associative_array()
    @self = array()
    @self['type'] = 'ENTITY'
    @self['class'] = 'EntityEvent'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['id'] = @entity
    @self['action'] = @action
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')[@self['class']]) {
        @self[@key] = @method
    }
    return(@self)
}

array proc _quest_event(string @action, string @quest = null) {
    @self = associative_array()
    @self['type'] = 'QUEST'
    @self['class'] = 'QuestEvent'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['action'] = @action
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')[@self['class']]) {
        @self[@key] = @method
    }
    return(@self)
}

array proc _group_event(string @group, string @action, string @quest = null) {
    @self = associative_array()
    @self = array()
    @self['type'] = 'GROUP'
    @self['class'] = 'GroupEvent'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['group'] = @group
    @self['action'] = @action
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')[@self['class']]) {
        @self[@key] = @method
    }
    return(@self)
}

array proc _custom_event(string @id, string @quest = null) {
    @self = associative_array()
    @self = array()
    @self['type'] = 'CUSTOM'
    @self['class'] = 'CostumEvent'
    @self['details'] = array()
    @self['registed_id'] = null

    @self['id'] = @id
    @self['quest'] = @quest

    foreach(@key: @method in import('org.cadabra.msquest.events')[@self['class']]) {
        @self[@key] = @method
    }
    return(@self)
}

array proc _events_get_all_classes() {
    return(import('org.cadabra.msquest.events.classes'))
}

execute(closure() {
    @super_methods = array()
    @super_methods['test'] = closure(array @self, array @info_event) {
        if (is_null(_method(@self, 'getUUID'))) {
            return(false)
        }
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
    @super_methods['getUUID'] = closure(array @self) {
        return(@self['registed_id'])
    }

    @class_methods = associative_array()

    @class_methods['EntityEvent'] = associative_array()
    @class_methods['EntityEvent']['getID'] = closure(array @self) {
        return(_entity_event_get_id(@self['id'], @self['action']))
    }

    @class_methods['GroupEvent'] = associative_array()
    @class_methods['GroupEvent']['getID'] = closure(array @self) {
        return(_group_event_get_id(@self['group'], @self['action']))
    }

    @class_methods['QuestEvent'] = associative_array()
    @class_methods['QuestEvent']['getID'] = closure(array @self) {
        return(_quest_event_get_id(@self['action']))
    }

    @class_methods['CostumEvent'] = associative_array()
    @class_methods['CostumEvent']['getID'] = closure(array @self) {
        return(_custom_event_get_id(@self['id']))
    }

    @final_methods = associative_array()
    foreach(@class: @methods in @class_methods) {
        @final_methods[@class] = array_merge(@methods, @super_methods)
    }
    export('org.cadabra.msquest.events.classes', array_keys(@final_methods))
    export('org.cadabra.msquest.events', @final_methods)
})


