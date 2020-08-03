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
    @procs['health'] = closure(@uuid, double @data) {
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
    @procs['effect'] = closure(@uuid, array @data) {
        @args = array_merge(array(@uuid), @data)
        call_proc_array('set_mob_effect', @args)
    }
    @procs['equipment'] = closure(@uuid, array @data) {
        set_mob_equipment(@uuid, @data)
    }
    @procs['owner'] = closure(@uuid, string @data) {
        set_mob_owner(@uuid, @data)
    }
})