string proc _get_id_module() {
    return('org.cadabra.msquest')
}

string proc _msg(string @key, int @stack = 1, array @args = array()) {
    return(_util_msg(_get_id_module(), @key, @stack + 1, @args))
}

void proc _log(string @type, string @msg) {
    _util_log(_get_id_module(), @type, @msg)
}

# quick log = qlog
void proc _qlog(string @type, string @key, array @args = array(), string @append = '', int @stack = 1) {
    _log(@type, _util_msg(_get_id_module(), @key, @stack + 1, @args).@append)
}

array proc _init_exception(string @type, array @args = array(), string @msg = '', string @at = null) {
    return(array('class': 'Exception', type: @type, args: @args, msg: @msg, at: @at))
}

string proc _parse_exception(array @e, int @stack = 1) {
    @message = _util_msg(_get_id_module(), @e['type'], @stack + 1, @e['args'])
    if (@e['msg'] != null && trim(@e['msg']) != '') {
        @message .= '\nMessage: '.@e['msg']
    }
    return(@message)
}

void proc _error(string @key, array @args = array(), int @stack = 1) {
    @msg = _util_msg(_get_id_module(), @key, @stack + 1, @args)
    _log('FATAL', @msg)
    die()
}

execute(closure() {
    # messager
    _util_msg_register_module(_get_id_module(), _get_src(''))
    @files = _util_get_all_files(_get_resource('msg'))
    foreach(@file in @files) {
        if (string_contains(@file, '.yml')) {
            _util_msg_register_file(_get_id_module(), yml_decode(read(@file)))
        }
    }

    # logger
    @to_console = closure(@msg) {
        console(@msg, false)
    }
    @path_to_log = _get_data('log')
    @to_file = closure(@msg) {
        @path_to_log .= '\\'.simple_date('yyyy.MM.dd').'txt'
        if (!file_exists(@path_to_log)) {
            _util_make_file(@path_to_log, '\\', 3)
        }
        write_file(@path_to_log, "@msg\n", 'APPEND')
    }
    _util_log_register(_get_id_module(), 'MSQuest', array(@to_console, @to_file))
})