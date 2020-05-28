execute(closure() {

    ### paths to resourses ###

    @path_to_dialogs = _quest_get_path('dialogs')
    @path_to_characters = _quest_get_path('characters')
    @path_to_scripts = _quest_get_path('scripts')
    @path_to_msgs = _quest_get_path_resourse('msg')

    ### LOGGING ###

    _util_msg_register_module(_quest_get_prefix(), _quest_get_path('ms'))
    @files = _util_get_all_files(@path_to_msgs)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _util_msg_register_file(_quest_get_prefix(), yml_decode(read(@file)))
        }
    }

    ### CHARACTERS ###

    if (!file_exists(@path_to_characters)) {
        _util_error(_quest_msg('incor_characters', @path_to_characters))
    }
    @files = _util_get_all_files(@path_to_characters)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _quest_characters_add(yml_decode(read(@file)))
        }
    }

    ### DIALOGS ###

    if (!file_exists(@path_to_dialogs)) {
        _util_error(_quest_msg('incor_dialogs', @path_to_dialogs))
    }
    @files = _util_get_all_files(@path_to_dialogs)
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _quest_dialogs_add(yml_decode(read(@file)))
        }
    }

    ### SCRIPTS ###

    if (!file_exists(@path_to_scripts)) {
        _util_error(_quest_msg('incor_scripts', @path_to_scripts))
    }
    @scripts = _util_get_all_scripts(@path_to_scripts)
    _quest_scripts_add_all(@scripts)
})