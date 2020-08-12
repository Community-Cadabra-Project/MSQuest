proc _before_all() {
    return(_sa_load_scripts())
}

proc _test_proc_not_found_exc1(@scripts) {
    @script = @scripts['proc_not_found_exc1']
    @exceptions = _pr_script_checker_single(@script['object'])
    _assert_equals(array('proc_not_found_exception'), _to_types(@exceptions))
}

proc _test_proc_not_found_exc2(@scripts) {
    @script = @scripts['proc_not_found_exc2']
    @exceptions = _pr_script_checker_single(@script['object'])
    _assert_equals(array('proc_not_found_exception'), _to_types(@exceptions))
}

proc _test_analys1(@scripts) {
    _assert_time_limit(0.2, 0.5)
    @log = _script_checker_analys(
        array_filter(@scripts, closure(@k, @v) {return(@k != 'valid_script')}),
        array(dialogs: array(), entities: array(), quests: array())
    )
    _assert_size(5, @log, string(@log))
    @string = string(_script_checker_parse_exceptions(@log))
    _assert_not_empty(@string)
    //_print(@string)
}

proc _test_analys2(@scripts) {
     @log = _script_checker_analys(
        array(@scripts['valid_script']),
        array(dialogs: array('dialog'), entities: array('npc'), quests: array('quest1', 'quest2'))
    )
    _assert_empty(@log, string(@log))
}

proc _to_types(array @exceptions) {
    return(array_map(@exceptions, closure(@v) {
        return(@v['type'])
    }))
}