proc _load_dialogs() {
    string @path = get_absolute_path('dialog')

    array @entities = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    @dialogs = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -5)]
        try {
            @dialogs[] = array(id: @id, dialog: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@dialogs)
}

proc _load_entities() {
    string @path_to_npc = get_absolute_path('entity')

    array @entities = array()
    int @len_npc = length(@path_to_npc)

    @files = _util_get_all_files(@path_to_npc)
    @entities = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len_npc+1, -5)]
        try {
            @entities[] = array(is_npc: true, id: @id, entity: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@entities)
}

proc _load_scripts() {
    string @path = get_absolute_path('script')

    array @scripts = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -6)]
        @scripts[] = array(id: @id, path: @file)
    }
    return(@scripts)
}

proc _load_stages() {
    string @path = get_absolute_path('stages')

    array @entities = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    @stages = array()
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -5)]
        try {
            @stages[] = array(id: @id, stage: yml_decode(read(@file)))
        } catch(FormatException @e) {
            console(@file)
        }
    }
    return(@stages)
}

proc _before_all() {
    @data = associative_array()
    @data['entities'] = _load_entities()
    @data['stages'] = _load_stages()
    @data['scripts'] = _load_scripts()
    @data['dialogs'] = _load_dialogs()
    return(@data)
}

proc _test_analys(@data) {
    @log = _static_analys(@data)
    _assert_true_obj(@log['entity'], @log['entity'])
    _assert_true_obj(@log['stage'], @log['stage'])
    _assert_true_obj(@log['script'], @log['script'])
    _assert_true_obj(@log['dialog'], @log['dialog'])
    @string = string(_static_analys_parse_log(@log))
    // _print(@string)
}