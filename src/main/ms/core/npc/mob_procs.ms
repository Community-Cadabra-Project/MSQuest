@procs = associative_array()

execute(closure() {
    @procs['pickup'] = closure(@uuid, boolean @data) {
        set_can_pickup_items(@uuid, @data)
    }
    @procs['ai'] = closure(@uuid, boolean @data) {
        set_entity_ai(@uuid, @data)
    }
    @procs['air'] = closure(@uuid, int @data) {
        set_entity_air(@uuid, @data)
    }
    @procs['breedable'] = closure(@uuid, boolean @data) {
        set_entity_breedable(@uuid, @data)
    }
    @procs['gliding'] = closure(@uuid, boolean @data) {
        set_entity_gliding(@uuid, @data)
    }
    @procs['health'] = closure(@uuid, int @data) {
        set_entity_health(@uuid, @data)
    }
    @procs['immunity'] = closure(@uuid, int @data) {
        set_entity_immunity_ticks(@uuid, @data)
    }
    @procs['max_air'] = closure(@uuid, int @data) {
        set_entity_max_air(@uuid, @data)
    }
    @procs['persistence'] = closure(@uuid, boolean @data) {
        set_entity_persistence(@uuid, @data)
    }
    @procs['equipment_droprates'] = closure(@uuid, array @data) {
        set_equipment_droprates(@uuid, @data)
    }
    @procs['max_health'] = closure(@uuid, double @data) {
        set_max_health(@uuid, @data)
    }
    @procs['collidable'] = closure(@uuid, boolean @data) {
        set_mob_collidable(@uuid, @data)
    }
    @procs['effects'] = closure(@uuid, array @data) {
        foreach(@d in @data) {
            switch(array_size(@d)) {
                case 1:
                    set_mob_effect(@uuid, @d[0])
                    break()
                case 2:
                    set_mob_effect(@uuid, @d[0], @d[1])
                    break()
                case 3:
                    set_mob_effect(@uuid, @d[0], @d[1], @d[2])
                    break()
                case 4:
                    set_mob_effect(@uuid, @d[0], @d[1], @d[2], @d[3])
                    break()
                case 5:
                    set_mob_effect(@uuid, @d[0], @d[1], @d[2], @d[3], @d[4])
                    break()
                default:
                    throw(IllegalArgumentException, 'Array size must be in the range [1, 5]')
            }
        }
    }
    @procs['equipment'] = closure(@uuid, array @data) {
        set_mob_equipment(@uuid, @data)
    }
    @procs['owner'] = closure(@uuid, string @data) {
        set_mob_owner(@uuid, @data)
    }
})