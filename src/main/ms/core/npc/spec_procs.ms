@procs = associative_array()

execute(closure() {
    @procs['spec'] = closure(@uuid, array @data) {
        set_entity_spec(@uuid, @data)
    }
})