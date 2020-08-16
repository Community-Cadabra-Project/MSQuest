string proc _get_id_module() {
    return('org.cadabra.msquest')
}

string proc _msg(string @key, int @stack = 1, array @args = array()) {
    return(_util_msg(_get_id_module(), @key, @stack + 1, @args))
}

void proc _log(string @type, string @msg, mixed @args = null) {
    _util_log(_get_id_module(), @type, player(), @msg, @args)
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

void proc _qerror(string @key, array @args = array(), int @stack = 1) {
    @msg = _util_msg(_get_id_module(), @key, @stack + 1, @args)
    _log('FATAL', @msg)
    die()
}

void proc _error(string @msg, mixed @args = null) {
    _log('ERROR', @msg, @args)
    die()
}

void proc _fatal(string @msg, mixed @args = null) {
    _log('FATAL', @msg, @args)
    die()
}

array proc _get_paths_of_data() {
    return(associative_array(
        npc: _get_data('npc'),
        dialog: _get_data('dialog'),
        script: _get_data('script'),
        stage: _get_data('stage'),
        template: _get_data('template'),
        localPackages: _get_data('localPackages')
    ))
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
    @to_console = associative_array(
        write: closure(@params) {
            if (@params['who'] == '~console') {
                @args = @params['args']
                if (@args && array_index_exists(@args, 'console')) {
                    if (@args['console']) {
                        console(sprintf('[%s] [%s] %s', @params['type'], @params['prefix'], @params['msg']), false)
                    }
                } else {
                    console(sprintf('[%s] [%s] %s', @params['type'], @params['prefix'], @params['msg']), false)
                }
            }
        },
        level: 0
    )
    @to_player = associative_array(
        write: closure(@params) {
            @who = @params['who']
            if (@who != '~console') {
                @args = @params['args']
                if (@args && array_index_exists(@args, 'player')) {
                    if (@args['player']) {
                        broadcast(sprintf('[%s] %s: %s', @params['type'], @params['prefix'], @params['msg']), array(@who))
                    }
                } else {
                    broadcast(sprintf('[%s] %s: %s', @params['type'], @params['prefix'], @params['msg']), array(@who))
                }
            }
        },
        level: 2000
    )
    @path_to_log = _get_data('log')
    @to_file = associative_array(
        write: closure(@params) {
            @path_to_log .= _util_sdn().simple_date('yyyy.MM.dd').'.log'
            @msg = sprintf('[%s] [%s/%s]: [%s] %s\n', simple_date('yyyy.MM.dd HH:mm:ss,S'), @params['who'], @params['type'], @params['prefix'], @params['msg'])
            if (!file_exists(@path_to_log)) {
                _util_make_file(@path_to_log, -3)
            }
            write_file(@path_to_log, @msg, 'APPEND')
        },
        level: 0
    )
    _util_log_register(_get_id_module(), 'MSQuest', array(@to_player, @to_console, @to_file))
})