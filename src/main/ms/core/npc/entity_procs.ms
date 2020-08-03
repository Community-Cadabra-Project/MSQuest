@procs = associative_array()

execute(closure() {
    @procs['glowing'] = closure(@uuid, boolean @data) {
        set_entity_glowing(@uuid, @data)
    } 
    @procs['gravity'] = closure(@uuid, boolean @data) {
        set_entity_gravity(@uuid, @data)
    } 
    @procs['invulnerable'] = closure(@uuid, boolean @data) {
        set_entity_invulnerable(@uuid, @data)
    } 
    @procs['on_fire'] = closure(@uuid, int @data) {
        set_entity_onfire(@uuid, @data)
    } 
    @procs['silent'] = closure(@uuid, boolean @data) {
        set_entity_silent(@uuid, @data)
    } 
    @procs['name'] = closure(@uuid, string @data) {
        set_mob_name(@uuid, @data)
    } 
    @procs['visible_name'] = closure(@uuid, boolean @data) {
        set_name_visible(@uuid, @data)
    } 
    @procs['velocity'] = closure(@uuid, array @data) {
        set_entity_velocity(@uuid, @data)
    }
})