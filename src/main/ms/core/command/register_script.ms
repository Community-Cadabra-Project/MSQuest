proc _register(array @model, string @path) {
    include('../event/api_register.ms')
    include(@path)
    _bind_init()
    # stupid SA "Procedure cannot be resolved"
    // _register_as()
    @a = '_register_as'
    call_proc(@a)
    @binds = _bind_import()
    @map = @model['event']['map']
    @ids = array()
    foreach(@event in @binds['events']) {
        @ids[] = _method(@map, 'register', @event)
    }
    return(array(ids: @ids, dialog: @binds['dialog']))
}

proc _register_run(array @c, array @ids, string @path) {
    include(@path)
    foreach(@id in @ids) {
        _util_commander_register_proc(@c, @id, '_script_run')
    }
}

proc _register_scripts(array @model, string @api_register, string @api_run, array @paths, string @local) {
    if (file_exists(@local)) {
        include(@local)
    }
    include('../../api/api_loader.ms')
    @c = _util_commander_init_self()
    
    @dialogs = associative_array()
    foreach(@path in @paths) {
        @response = _register(@model, @path)
        foreach(@id in @response['ids']) {
            @dialogs[@id] = @model['dialogs']['mapID'][@response['dialog']]
        }
        _register_run(@c, @response['ids'], @path)
        _log('INFO', "Registered script @path")
    }
    @model['dialogs']['mapUUID'] = @dialogs
    @model['scripts']['commander'] = @c
}