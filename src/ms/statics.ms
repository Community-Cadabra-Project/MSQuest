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

array proc _quest__get_syntax() {
    return(import('__QUEST_SETTING')['syntax'])
}

array proc _quest__get_syntax_full() {
    return(import('__QUEST_SETTING')['syntax']['full'])
}

array proc _quest__get_syntax_head_part() {
    return(import('__QUEST_SETTING')['syntax']['head_part'])
}

array proc _quest_get_syntax_tail_part() {
    return(import('__QUEST_SETTING')['syntax']['tail_part'])
}

string proc _quest_get_prefix() {
    return('quest')
}

string proc _quest_msg(string @key) {
    if (array_size(@arguments) > 1) {
        return(_util_msg(_quest_get_prefix(), @key, 2, @arguments[1..]))
    } else {
        return(_util_msg(_quest_get_prefix(), @key, 2))
    }
}