execute(closure() {

    ### paths to resourses ###

    @path_to_dialogs = _quest_get_path('dialogs')
    @path_to_characters = _quest_get_path('characters')
    @path_to_templates = _quest_get_path('templates')
    @path_to_scripts = _quest_get_path('scripts')
    @path_to_msgs = _quest_get_path_resourse('msg')
    @path_to_log = _quest_get_path('log')

    ### LOGGING ###

    # messager
    _util_msg_register_module(_quest_get_prefix(), _quest_get_path('ms'))
    @files = _util_get_all_files(@path_to_msgs)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _util_msg_register_file(_quest_get_prefix(), yml_decode(read(@file)))
        }
    }
    
    # logger
    @to_console = closure(@msg) {
        console(@msg, false)
    }
    @to_file = closure(@msg) {
        @path_to_log .= '\\'.simple_date('yyyy.mm.dd').'txt'
        if (!file_exist(@path_to_log)) {
            _util_make_dir(@path_to_log)
        }
        write_file(@path_to_log, @msg, 'APPEND')
    }
    _util_log_register(_quest_get_prefix(), 'MSQuest', array(@to_console, @to_file))

    ### ENTITIES ###

    # characters
    if (!file_exists(@path_to_characters)) {
        _quest_error('incor_characters', array(@path_to_characters))
    }
    @files = _util_get_all_files(@path_to_characters)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _quest_entities_add_npc(yml_decode(read(@file)))
        }
    }

    # templates
    if (!file_exists(@path_to_templates)) {
        _quest_error('incor_templates', array(@path_to_templates))
    }
    @files = _util_get_all_files(@path_to_templates)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _quest_entities_add_template(yml_decode(read(@file)))
        }
    }

    ### DIALOGS ###

    if (!file_exists(@path_to_dialogs)) {
        _quest_error('incor_dialogs', array(@path_to_dialogs))
    }
    @files = _util_get_all_files(@path_to_dialogs)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _quest_dialogs_add(yml_decode(read(@file)))
        }
    }

    ### SCRIPTS ###

    if (!file_exists(@path_to_scripts)) {
        _quest_error('incor_scripts', array(@path_to_scripts))
    }
    @scripts = _util_get_all_scripts(@path_to_scripts)
    _quest_scripts_add_all(@scripts)

    ### RESOURSE NPC ###

    @ncp_samples = _util_get_all_files(_quest_get_path_resourse('template.sample'))
    @npc_mob = yml_decode(_quest_get_path_resourse('template.mob'))
    @npc_entity = yml_decode(_quest_get_path_resourse('template.entity'))
    @npc_global = yml_decode(_quest_get_path_resourse('template.global'))

    @npc_spec = array()
    foreach(@sample in @npc_samples) {
        if (string_contains(@sample, '.yml')) {
            @spec[to_lower(@spec)] = yml_decode(@npc_samples)
        }
    }
    @templates = _quest_entity_checker_import()['templates']
    @templates['spec'] = @spec
    @templates['global'] = @npc_global
    @templates['entity'] = @npc_entity
    @templates['spec'] = @npc_spec
})