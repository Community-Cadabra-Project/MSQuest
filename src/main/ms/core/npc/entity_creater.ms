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
        _util_commander_register(@entity_commander, @key, @proc)
    }

    @mob_commander = _util_commander_init_self()
    include('mob_procs.ms')
    foreach(@key: @proc in @procs) {
        _util_commander_register(@mob_commander, @key, @proc)
    }

    @entity_spec = closure(@uuid, array @data) {
        set_entity_spec(@uuid, @data)
    }

    @methods['create'] = closure(@self, array @data) {
        @main = @data['main']
        @location = associative_array(
            pitch: @main['pitch'],
            yaw: @main['yaw'],
            world: @main['world']
        )
        @location[0] = @main['location'][0]
        @location[1] = @main['location'][1]
        @location[2] = @main['location'][2]
        @uuid = spawn_entity(
            @main['type'],
            1,
            @location,
            closure(@id){
                if (array_index_exists(@data, 'entity')) {
                    foreach(@key: @d in @data['entity']) {
                        _util_commander_execute(@entity_commander, @key, @id, @d)
                    }
                }
                if (array_index_exists(@data, 'mob')) {
                    foreach(@key: @d in @data['mob']) {
                        _util_commander_execute(@mob_commander, @key, @id, @d)
                    }
                }
                if (array_index_exists(@data, 'spec')) {
                    set_entity_spec(@id, @data['spec'])
                }
            }
        )[0]
        return(@uuid)
    }
    export('org.cadabra.msquest.npc_creater', @methods)
})