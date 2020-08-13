@procs = associative_array()

execute(closure() {
    @procs['location'] = closure(@uuid, array @data) {
        @location = entity_loc(@uuid)
        @location['x'] = @data[0]
        @location['y'] = @data[1]
        @location['z'] = @data[2]
        set_entity_loc(@uuid, @location)
    } 
    @procs['pitch'] = closure(@uuid, number @data) {
        @location = entity_loc(@uuid)
        @location['pitch'] = @data
        set_entity_loc(@uuid, @location)
    } 
    @procs['world'] = closure(@uuid, string @data) {
        @location = entity_loc(@uuid)
        @location['world'] = @data
        set_entity_loc(@uuid, @location)
    } 
    @procs['yaw'] = closure(@uuid, number @data) {
        @location = entity_loc(@uuid)
        @location['yaw'] = @data
        set_entity_loc(@uuid, @location)
    }
})