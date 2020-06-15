array proc _quest_get_setting() {
    return(import('__QUEST_SETTING'))
}

string proc _quest_get_path(string @path) {
    @KEY_PATH = 'paths'
    @keys = split('.', @path)
    @result = _quest_get_setting()[@KEY_PATH]
    foreach(@key in @keys) {
        @result = @result[@key]
    }
    return(@result)
}

string proc _quest_get_path_resourse(string @path) {
    @KEY_PATH = 'paths'
    @KEY_RESOURSE = 'resourse'
    @keys = split('.', @path)
    @result = _quest_get_setting()[@KEY_PATH][@KEY_RESOURSE]
    foreach(@key in @keys) {
        @result = @result[@key]
    }
    return(@result)
}

string proc _quest_get_prefix() {
    return('quest')
}

string proc _quest_msg(string @key, int @stack = 1, array @args = array()) {
    return(_util_msg(_quest_get_prefix(), @key, @stack + 1, @args))
}

void proc _quest_log(string @type, string @msg) {
    _util_log(_quest_get_prefix(), @type, @msg)
}

#quick log = qlog
void proc _quest_qlog(string @type, string @key, array @args = array(), string @append = '', int @stack = 1) {
    _quest_log(@type, _util_msg(_quest_get_prefix(), @key, @stack + 1, @args).@append)
}

array proc _quest_init_exception(string @type, array @args, string @msg = '') {
    return(array(type: @type, args: @args, msg: @msg))
}

void proc _quest_error(string @key, array @args = array()) {
    @msg = _util_msg(_quest_get_prefix(), @key, @stack + 1, @args)
    _quest_log('FATAL', @msg)
    die()
}