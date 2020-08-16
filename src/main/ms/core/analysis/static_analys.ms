include('entity/entity_checker.ms')
include('stage/stage_checker.ms')
include('script/script_checker.ms')
include('dialog/dialog_checker.ms')
include('sa_decoder.ms')

array proc _static_analys(@paths_data) {
    @data = associative_array()
    @decoder_exceptions = array()

    @entities = array()

    @root = @paths_data['npc']
    @paths = _util_get_all_files(@root, '.yml')

    @result = _sa_decoder(@paths, cslice(length(@root)+1, -1))
    array_push_all(@decoder_exceptions, @result['exceptions'])
    if (!@decoder_exceptions) {
        foreach(@e in @result['entries']) {
            @e['is_npc'] = true
            @entities[] = @e
        }
    }

    @root = @paths_data['template']
    @paths = _util_get_all_files(@root, '.yml')

    @result = _sa_decoder(@paths, cslice(length(@root)+1, -1))
    array_push_all(@decoder_exceptions, @result['exceptions'])
    if (!@decoder_exceptions) {
        foreach(@e in @result['entries']) {
            @e['is_npc'] = false
            @entities[] = @e
        }
    }
    @data['entities'] = @entities

    @dialogs = array()

    @root = @paths_data['dialog']
    @paths = _util_get_all_files(@root, '.yml')
    
    @result = _sa_decoder(@paths, cslice(length(@root)+1, -1))
    array_push_all(@decoder_exceptions, @result['exceptions'])
    if (!@decoder_exceptions) {
        foreach(@e in @result['entries']) {
            @dialogs[] = @e
        }
    }
    @data['dialogs'] = @dialogs

    @stages = array()

    @root = @paths_data['stage']
    @paths = _util_get_all_files(@root, '.yml')

    @result = _sa_decoder(@paths, cslice(length(@root)+1, -1))
    array_push_all(@decoder_exceptions, @result['exceptions'])
    if (!@decoder_exceptions) {
        foreach(@e in @result['entries']) {
            @stages[] = @e
        }
    }
    @data['stages'] = @stages

    @scripts = array()

    if (!@decoder_exceptions) {
        @root = @paths_data['script']
        @paths = _util_get_all_scripts(@root)
        foreach(@path in @paths) {
            @id = @path[cslice(length(@root)+1, -1)]
            @e = associative_array(
                object: @path,
                id: @id
            )
            @scripts[] = @e
        }
    }
    @data['scripts'] = @scripts

    string @msg
    boolean @status = true
    if (@decoder_exceptions) {
        @msg = _sa_decoder_parse_exceptions(@decoder_exceptions)
        @status = false
    } else {
        @logs = _static_analys_data(@data)
        foreach(@log in @logs) {
            if (@log) {
                @status = false
            }
        }
        @msg  = string(_static_analys_parse_log(@logs))
    }
    return(array(status: @status, message: @msg, data: @data))
}

array proc _static_analys_data(array @data) {
    @entities = @data['entities']
    @stages = @data['stages']
    @scripts = @data['scripts']
    @dialogs = @data['dialogs']

    @log = associative_array()

    _stage_checker_init()
    _entity_checker_init()
    _script_checker_init()

    @log['dialog'] = _dialog_checker_analys(@dialogs)
    @log['stage'] = _stage_checker_analys(@stages)
    @log['entity'] = _entity_checker_analys(@entities)

    @context = associative_array(
        'dialogs': _dialog_checker_ids(@dialogs),
        'quests': _stage_checker_ids(@stages),
        'entities': _entity_checker_ids(@entities)
    )
    @log['script'] = _script_checker_analys(@scripts, @context)
    return(@log)
}

Resource proc _static_analys_parse_log(array @log) {
    Resource @builder = res_create_resource('STRING_BUILDER')
    string_append(@builder, 'Static Analys\n')
    @builder = _dialog_checker_parse_exceptions(@log['dialog'], @builder)
    string_append(@builder, '\n')  
    @builder = _stage_checker_parse_exceptions(@log['stage'], @builder)
    string_append(@builder, '\n')
    @builder = _entity_checker_parse_exceptions(@log['entity'], @builder)
    string_append(@builder, '\n')
    @builder = _script_checker_parse_exceptions(@log['script'], @builder)
    return(@builder)
}