proc _before_all() {

    string @path = get_absolute_path('script')

    array @scripts = array()
    int @len = length(@path)

    @files = _util_get_all_files(@path)
    foreach(@file in @files) {
        @id = @file[cslice(@len+1, -6)]
        @scripts[@id] = array(id: @id, path: @file)
    }
    return(@scripts)
}

proc _test_proc_not_found_exc1(@scripts) {
    @script = @scripts['proc_not_found_exc1']
    @exceptions = _pr_script_checker_single(@script['path'])
    _assert_equals(array('proc_not_found_exception'), _to_types(@exceptions))
}

proc _test_proc_not_found_exc2(@scripts) {
    @script = @scripts['proc_not_found_exc2']
    @exceptions = _pr_script_checker_single(@script['path'])
    _assert_equals(array('proc_not_found_exception'), _to_types(@exceptions))
}

proc _test_analys(@scripts) {
    @log = _script_checker_analys(@scripts)
    _assert_size(3, @log, string(@log))
    @string = _script_checker_parse_exceptions(@log)
    _assert_not_empty(@string)
    _print(@string)
}


proc _to_types(array @exceptions) {
    return(array_map(@exceptions, closure(@v) {
        return(@v['type'])
    }))
}