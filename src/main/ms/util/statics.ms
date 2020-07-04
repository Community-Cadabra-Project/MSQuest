string proc _get_path(string @path) {
    @KEY_PATH = 'paths'
    @keys = split('.', @path)
    @result = _get_setting()[@KEY_PATH]
    foreach(@key in @keys) {
        @result = @result[@key]
    }
    return(@result)
}

string proc _get_path_resourse(string @path) {
    @KEY_PATH = 'paths'
    @KEY_RESOURSE = 'resourse'
    @keys = split('.', @path)
    @result = _get_setting()[@KEY_PATH][@KEY_RESOURSE]
    foreach(@key in @keys) {
        @result = @result[@key]
    }
    return(@result)
}

string proc _get_prefix() {
    return('quest')
}

string proc _msg(string @key, int @stack = 1, array @args = array()) {
    return(_util_msg(_get_prefix(), @key, @stack + 1, @args))
}

void proc _log(string @type, string @msg) {
    _util_log(_get_prefix(), @type, @msg)
}

#quick log = qlog
void proc _qlog(string @type, string @key, array @args = array(), string @append = '', int @stack = 1) {
    _log(@type, _util_msg(_get_prefix(), @key, @stack + 1, @args).@append)
}

array proc _init_exception(string @type, array @args = array(), string @msg = '') {
    return(array(type: @type, args: @args, msg: @msg))
}

string proc _parse_exception(array @e, int @stack = 1) {
    @message = _util_msg(_get_prefix(), @e['type'], @stack + 1, @e['args'])
    if (@e['msg'] != null && trim(@e['msg']) != '') {
        @message .= '\nMessage: '.@e['msg']
    }
    return(@message)
}

void proc _log_exception(string @type, array @e, int @stack = 1) {

}

void proc _error(string @key, array @args = array()) {
    @msg = _util_msg(_get_prefix(), @key, @stack + 1, @args)
    _log('FATAL', @msg)
    die()
}