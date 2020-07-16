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
    foreach(@id: @entry in @log) {
        string_append(@builder,'\n=============================\n')
        string_append(@builder, 'Script at: ')
        string_append(@builder, @id)
        string_append(@builder, '\n')
        if (@entry['static']) {
            string_append(@builder, '\n##### Static exceptions\n')
        }
        foreach(@e in @entry['static']) {
            string_append(@builder, '- ')
            string_append(@builder, _parse_exception(@e))
            string_append(@builder, '\n\n')
        }
        if (@entry['running']) {
            string_append(@builder, '\n##### Running exceptions\n')
        }
        foreach(@e in @entry['running']) {
            string_append(@builder, '- ')
            string_append(@builder, _util_parse_exception(@e))
            string_append(@builder, '\n\n')
        }
    }
    return(string(@builder))
}

array proc _script_checker_analys(array @scripts, array @context) {
    @log = array()
    @context = _pr_script_checker_init_context(@context)
    foreach(@script in @scripts) {
        @path = @script['path']
        @id = @script['id']
        @exceptions = _pr_script_checker_single(@path)
        export('TEMP', array(@path, @context))
        @running_exceptions = _pr_script_checker_run(@path, @context)
        if (@exceptions || @running_exceptions) {
            @log[@id] = array('static': @exceptions, running: @running_exceptions)
        }
    }
    return(@log)
}

array proc _pr_script_checker_init_context(@_context) {
    @context = array()
    @context = array_merge(@context, @_context)
    @context['bioms'] = import('org.cadabra.msquest.script_checker')['bioms']
    @context['fakeEvent'] = array('class': 'Event')
    @context['fakeDetail'] = array('class': 'DetailEvent')

    @context['used_dialog'] = false
    @context['used_bind'] = false
    @context['exceptions'] = array()

    @context['clear'] = closure() {
        @context['used_bind'] = false
        @context['used_dialog'] = false
        @context['exceptions'] = array()
    }

    export('org.cadabra.msquest.script_checker.local_procs', @context)
    return(@context)
}

array proc _pr_script_checker_run(@path) {
    x_clear_env()
    @exceptions = array()
    @path = import('TEMP')[0]
    @context = import('TEMP')[1]
    include('local_procs.ms')
    include(@path)
    if (!is_proc('_register_as')) {
        return(@exceptions)
    }
    try {
        _register_as()
    } catch(Exception @e) {
        @exceptions[] = array(
                'classType': @e['classType'],
                'message': @e['message'],
                'stackTrace': @e['stackTrace'][0..0]
        )
    }
    if (!@context['used_bind']) {
        @exceptions[] = array(
            'classType': 'ms.lang.NotCalledProcException',
            'stackTrace': array(),
            'message': 'The _bind_events() must be called at least once'
        )
    }
    array_push_all(@exceptions, @context['exceptions'])
    execute(@context['clear'])
    return(@exceptions)
}

array proc _pr_script_checker_single(string @path) {
    @res = import('org.cadabra.msquest.script_checker')['syntax']
    @exceptions = array()
    array @procs
    if (file_size(@path) == 0) {
        @procs = array()
    } else {
        @old_procs = get_procedures()
        include(@path)
        @new_procs = get_procedures()
        @procs = _util_array_minus(@new_procs, @old_procs)
    }
    foreach(@data in @res) {
        @e = _pr_script_checker_proc(@data, @procs)
        if (@e) {
            @exceptions[] = @e
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
    @model = array()

    @model['syntax'] = yml_decode(read(_get_resourse('template.script.syntax.yml')))
    @model['bioms'] = yml_decode(read(_get_resourse('template.script.bioms.yml')))

    export('org.cadabra.msquest.script_checker', @model)
})