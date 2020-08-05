proc _sa_load_dialogs() {
    string @path = _unit_resource('sa.dialog')

    array @entities = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    @dialogs = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -5)]
        try {
            @dialogs[@id] = array(id: @id, dialog: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@dialogs)
}

proc _sa_load_entities() {
    string @path_to_npc = _unit_resource('sa.entity')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    @entities = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len_npc+1, -5)]
        try {
            @entities[@id] = array(is_npc: true, id: @id, entity: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    _entity_checker_init()
    return(@entities)
}

proc _sa_load_scripts() {
    string @path = _unit_resource('sa.script-ign')

    array @scripts = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -4)]
        @scripts[@id] = array(id: @id, path: @file)
    }
    _script_checker_init()
    return(@scripts)
}

proc _sa_load_stages() {
    string @path = _unit_resource('sa.stages')

    array @entities = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    @stages = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -5)]
        try {
            @stages[@id] = array(id: @id, stage: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    _stage_checker_init()
    return(@stages)
}
