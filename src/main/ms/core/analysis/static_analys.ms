include('entity/entity_checker.ms')
include('stage/stage_checker.ms')
include('script/script_checker.ms')
include('dialog/dialog_checker.ms')

array proc _static_analys(array @data) {
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

Resource proc _static_analys_parse_log(array @log, Resource @builder = res_create_resource('STRING_BUILDER')) {
    if (@log['dialog']) {
        @builder = _dialog_checker_parse_exceptions(@log['dialog'], @builder)
        string_append(@builder, '\n')  
    }
    if (@log['stage']) {
        @builder = _stage_checker_parse_exceptions(@log['stage'], @builder)
        string_append(@builder, '\n')
    }
    if (@log['entity']) {
        @builder = _entity_checker_parse_exceptions(@log['entity'], @builder)
        string_append(@builder, '\n')
    }
    if (@log['script']) {
        @builder = _script_checker_parse_exceptions(@log['script'], @builder)
        string_append(@builder, '\n')
    }
    return(@builder)
}