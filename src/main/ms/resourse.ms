### paths to resourses ###

@path_to_dialogs = _get_path('dialogs')
@path_to_characters = _get_path('characters')
@path_to_templates = _get_path('templates')
@path_to_scripts = _get_path('scripts')
@path_to_msgs = _get_path_resourse('msg')
@path_to_log = _get_path('log')

### LOGGING ###

# messager
_util_msg_register_module(_get_prefix(), _get_path('ms'))
@files = _util_get_all_files(@path_to_msgs)
foreach(@file in @files) {
    if (string_contains(@file, '.yml')) {
        _util_msg_register_file(_get_prefix(), yml_decode(read(@file)))
    }
}

# logger
@to_console = closure(@msg) {
    console(@msg, false)
}
@to_file = closure(@msg) {
    @path_to_log .= '\\'.simple_date('yyyy.mm.dd').'txt'
    if (!file_exists(@path_to_log)) {
        _util_make_file(@path_to_log)
    }
    write_file(@path_to_log, @msg, 'APPEND')
}
_util_log_register(_get_prefix(), 'MSQuest', array(@to_console, @to_file))

### DATA.ENTITIES ###

# characters
if (!file_exists(@path_to_characters)) {
    _error('incor_characters', array(@path_to_characters))
}
@files = _util_get_all_files(@path_to_characters)
foreach(@file in @files) {
    if (string_contains(@file, '.yml')) {
        _package_entities_add_npc(@file, yml_decode(read(@file)))
    }
}

# templates
if (!file_exists(@path_to_templates)) {
    _error('incor_templates', array(@path_to_templates))
}
@files = _util_get_all_files(@path_to_templates)
foreach(@file in @files) {
    if (string_contains(@file, '.yml')) {
        _package_entities_add_template(@file, yml_decode(read(@file)))
    }
}

### DATA.DIALOGS ###

if (!file_exists(@path_to_dialogs)) {
    _error('incor_dialogs', array(@path_to_dialogs))
}
@files = _util_get_all_files(@path_to_dialogs)
foreach(@file in @files) {
    if (string_contains(@file, '.yml')) {
        _dialogs_add(yml_decode(read(@file)))
    }
}

### DATA.SCRIPTS ###

if (!file_exists(@path_to_scripts)) {
    _error('incor_scripts', array(@path_to_scripts))
}
@scripts = _util_get_all_scripts(@path_to_scripts)
_scripts_add_all(@scripts)

### RESOURSE.CORE.NPC ###
@npc_samples = _util_get_all_files(_get_path_resourse('template.spec'))
@npc_mob = yml_decode(read(_get_path_resourse('template.mob')))
@npc_entity = yml_decode(read(_get_path_resourse('template.entity')))
@npc_main = yml_decode(read(_get_path_resourse('template.main')))
@npc_sections = yml_decode(read(_get_path_resourse('template.sections')))

@npc_spec = array()
foreach(@sample in @npc_samples) {
    if (string_contains(@sample, '.yml')) {
        @o = yml_decode(read(@sample))
        @npc_spec[@o['id']] = @o['spec'] 
    }
}
@templates = _pck_entity_checker_import()['templates']
@templates['main'] = @npc_main
@templates['sections'] = @npc_sections
@templates['entity'] = @npc_entity
@templates['spec'] = @npc_spec
@templates['mob'] = @npc_mob