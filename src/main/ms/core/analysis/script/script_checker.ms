/*
Exceptions:
    keySet: type, args, [msg]
- proc_not_found_exception
    args: [proc]
- mismatch_number_procs_exception
    args: [proc, exp_n, act_n]
*/

string proc _script_checker_parse_exceptions(array @log) {
    @builder = res_create_resource('STRING_BUILDER')

    string_append(@builder, '########## SCRIPTS ##########')
    string_append(@builder, '\n')
    foreach(@id: @exceptions in @log) {
        string_append(@builder, '\nScript at: ')
        string_append(@builder, @id)
        string_append(@builder, '\n')
        foreach(@e in @exceptions) {
            string_append(@builder, '- ')
            string_append(@builder, _parse_exception(@e))
            string_append(@builder, '\n')
        }
    }
    return(string(@builder))
}

array proc _script_checker_analys(array @scripts) {
    @log = array()
    foreach(@script in @scripts) {
        @path = @script['path']
        @id = @script['id']
        @exceptions = _pr_script_checker_single(@path)
        if (@exceptions) {
            @log[@id] = @exceptions
        }
    }
    return(@log)
}

array proc _pr_script_checker_single(string @path) {
    @res = import('org.cadabra.msquest.script_checker')
    @exceptions = array()
    @old_procs = get_procedures()
    include(@path)
    @new_procs = get_procedures()
    @procs = _util_array_minus(@new_procs, @old_procs)
    foreach(@data in @res) {
        @e = _pr_script_checker_proc(@data, @procs)
        if (@e) {
            array_push(@exceptions, @e)
        }
    }
    return(@exceptions)
}

proc _pr_script_checker_proc(array @data, array @procs) {
    switch(@data['type']) {
        case 'full':
            if (@data['required'] && !array_contains(@procs, @data['proc'])) {
                @e = _init_exception('proc_not_found_exception', array(@data['proc']))
                return(@e)
            }
            break()
        case 'tail':
            @len = length(@data['proc'])
            @sorted_procs = array_filter(@procs, closure(@v) {
                return(@v[cslice(-@len, -1)] == @data['proc'])
            })
            if (@data['repeat'] != array_size(@sorted_procs)) {
                @e = _init_exception('mismatch_number_procs_exception', array(@data['proc'].'*', @data['repeat'], array_size(@sorted_procs)))
                return(@e)
            }
            break()
        case 'head':
            @len = length(@data['proc'])
            @sorted_procs = array_filter(@procs, closure(@v) {
                return(@v[cslice(0, @len-1)] == @data['proc'])
            })
            if (@data['repeat'] != array_size(@sorted_procs)) {
                @e = _init_exception('mismatch_number_procs_exception', array('*'.@data['proc'], @data['repeat'], array_size(@sorted_procs)))
                return(@e)
            }
            break()
    }
    return(false)
}

execute(closure() {
    @syntax = yml_decode(read(_get_resourse('template.script.syntax.yml')))
    export('org.cadabra.msquest.script_checker', @syntax)
})