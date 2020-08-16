/*
Exceptions:
    keySet: type, args, [msg]
- proc_not_found_exception
    args: [proc]
- mismatch_number_procs_exception
    args: [proc, exp_n, act_n]
*/

Resource proc _script_checker_parse_exceptions(array @log, Resource @builder = res_create_resource('STRING_BUILDER')) {
    string_append(@builder, '########## SCRIPTS ##########')
    string_append(@builder, '\n')
    foreach(@id: @entry in @log) {
        string_append(@builder,'\n===========\n')
        string_append(@builder, 'Script at: ')
        string_append(@builder, @id)
        string_append(@builder, '\n')
        if (@entry['static']) {
            string_append(@builder, '\nStatic exceptions\n')
        }
        foreach(@e in @entry['static']) {
            string_append(@builder, '- ')
            string_append(@builder, _parse_exception(@e))
            string_append(@builder, '\n\n')
        }
        if (@entry['running']) {
            string_append(@builder, '\nRunning exceptions\n')
        }
        foreach(@e in @entry['running']) {
            string_append(@builder, '- ')
            string_append(@builder, _util_parse_exception(@e))
            string_append(@builder, '\n\n')
        }
    } else {
        string_append(@builder, 'Successfully')
        string_append(@builder, '\n')
    }
    return(@builder)
}

array proc _script_checker_analys(array @scripts, array @context) {
    @log = array()
    @context = _pr_script_checker_init_context(@context)
    foreach(@script in @scripts) {
        @path = @script['object']
        @id = @script['id']
        @exceptions = _pr_script_checker_single(@path)
        @running_exceptions = _pr_script_checker_run(@path, @context)
        if (@exceptions || @running_exceptions) {
            @log[@id] = array(static: @exceptions, running: @running_exceptions)
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
    @context['used_bind'] = 0
    @context['exceptions'] = array()

    @context['clear'] = closure() {
        @context['used_bind'] = 0
        @context['used_dialog'] = false
        @context['exceptions'] = array()
    }
    
    _util_export('org.cadabra.msquest.script_checker.local_procs', @context)
    return(@context)
}

array proc _pr_script_checker_run(@path, @context) {
    synchronized('TEMP') {
        export('TEMP', array(@path, @context))
        x_clear_env()
        @exceptions = array()
        @path = import('TEMP')[0]
        @context = import('TEMP')[1]
    }
    include('local_procs.ms')
    try {
        include(@path)
    } catch (IncludeException @e) {
        @exceptions[] = array(
                'classType': @e['classType'],
                'message': @e['message'],
                'stackTrace': @e['stackTrace'][0..0]
        )
        return(@exceptions)
    }
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
    if (@context['used_bind'] > 1) {
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
        try {
            include(@path)
        } catch(IncludeException @e) {
            return(@exceptions)
        }
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

proc _script_checker_init() {
    synchronized('org.cadabra.msquest.script_checker') {
        if (import('org.cadabra.msquest.script_checker')) {
            return()
        }
        @model = associative_array()
    
        @model['syntax'] = yml_decode(read(_get_resource('template.script.syntax.yml')))
        @model['bioms'] = yml_decode(read(_get_resource('template.script.bioms.yml')))
    
        export('org.cadabra.msquest.script_checker', @model)
    }
}