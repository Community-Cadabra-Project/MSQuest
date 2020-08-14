string proc _entity_get_id(array @npc) {
    return(@npc['main']['id'])
}

array proc _entity_get_group(array @npc) {
    return(if(array_index_exists(@npc['main'], 'group'), @npc['main']['group'], array()))
}

array proc _entity_creater_init() {
    array @self = associative_array()
    @self['class'] = 'EntityCreater'
    foreach(@key: @method in import('org.cadabra.msquest.npc_creater')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    array @methods = associative_array()

    @entity_commander = _util_commander_init_self()
    include('entity_procs.ms')
    foreach(@key: @proc in @procs) {
        _util_commander_register(@entity_commander, "entity.@key", @proc)
    }

    @mob_commander = _util_commander_init_self()
    include('mob_procs.ms')
    foreach(@key: @proc in @procs) {
        _util_commander_register(@mob_commander, "mob.@key", @proc)
    }

    @main_commander = _util_commander_init_self()
    include('main_procs.ms')
    foreach(@key: @proc in @procs) {
        _util_commander_register(@main_commander, "main.@key", @proc)
    }

    @methods['change'] = closure(array @self, string @id, array @data) {
        string @path
        try {
            if (array_index_exists(@data, 'main')) {
                foreach(@key: @d in @data['main']) {
                    @path = "main.@key"
                    _util_commander_execute(@main_commander, @path, @id, @d)
                }
            }
            if (array_index_exists(@data, 'entity')) {
                foreach(@key: @d in @data['entity']) {
                    @path = "entity.@key"
                    _util_commander_execute(@entity_commander, @path, @id, @d)
                }
            }
            if (array_index_exists(@data, 'mob')) {
                foreach(@key: @d in @data['mob']) {
                    @path = "mob.@key"
                    _util_commander_execute(@mob_commander, @path, @id, @d)
                }
            }
            if (array_index_exists(@data, 'spec')) {
                set_entity_spec(@id, @data['spec'])
            }
            @unknown_keys = _util_array_minus(array_keys(@data), array('mob', 'entity', 'main', 'spec'))
            if (@unknown_keys) {
                throw(FormatException, "Unknown keys: @unknown_keys")
            }
        } catch (CastException @e) {
            throw(CastException, @path.': '.@e['message'], @e)
        }
    }

    @methods['create'] = closure(array @self, array @data) {
        @main = @data['main']
        @location = associative_array(
            pitch: @main['pitch'],
            yaw: @main['yaw'],
            world: @main['world']
        )
        @location['x'] = @main['location'][0]
        @location['y'] = @main['location'][1]
        @location['z'] = @main['location'][2]
        @uuid = spawn_entity(
            @main['type'],
            1,
            @location,
            closure(@id){
                string @path
                try {
                    if (array_index_exists(@data, 'entity')) {
                        foreach(@key: @d in @data['entity']) {
                            @path = "entity.@key"
                            _util_commander_execute(@entity_commander, @path, @id, @d)
                        }
                    }
                    if (array_index_exists(@data, 'mob')) {
                        foreach(@key: @d in @data['mob']) {
                            @path = "mob.@key"
                            _util_commander_execute(@mob_commander, @path, @id, @d)
                        }
                    }
                    if (array_index_exists(@data, 'spec')) {
                        set_entity_spec(@id, @data['spec'])
                    }
                    @unknown_keys = _util_array_minus(array_keys(@data), array('mob', 'entity', 'main', 'spec'))
                    if (@unknown_keys) {
                        throw(FormatException, "Unknown keys: @unknown_keys")
                    }
                } catch (CastException @e) {
                    throw(CastException, @path.': '.@e['message'], @e)
                }
            }
        )[0]
        return(@uuid)
    }
    export('org.cadabra.msquest.npc_creater', @methods)
})