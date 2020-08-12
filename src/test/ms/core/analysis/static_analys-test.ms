proc _before_all() {
    @data = associative_array()
    @data['entities'] = _sa_load_entities()
    @data['stages'] = _sa_load_stages()
    @data['scripts'] = _sa_load_scripts()
    @data['dialogs'] = _sa_load_dialogs()
    return(@data)
}

proc _test_analys(@data) {
    _assert_time_limit(0.5, 1)
    @log = _static_analys_data(@data)
    _assert_true_obj(@log['entity'], @log['entity'])
    _assert_true_obj(@log['stage'], @log['stage'])
    _assert_true_obj(@log['script'], @log['script'])
    _assert_true_obj(@log['dialog'], @log['dialog'])
    @string = string(_static_analys_parse_log(@log))
    _assert_not_empty(@string)
    // _print(@string)
}