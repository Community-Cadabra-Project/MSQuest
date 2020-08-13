proc _msquest_SA(@args) {
    if (array_size(@args) > 0) {
        _error('To many arguments')
    }
    @msg = _static_analys(_get_paths_of_data())['message']
    _log('INFO', @msg)
}

proc _msquest_load_model(@args) {
    if (array_size(@args) > 2) {
        _error('To many arguments')
    } else if (array_size(@args) == 0) {
        _error("No one arguments, possible 'update', 'reset'")
    }
    @mode = @args[0]
    @modes = array('update', 'reset')
    if (!array_contains(@modes, @mode)) {
        _error("Unknown argument: @mode, possible 'update', 'reset'")
    }

    _log('INFO', 'Start load model')

    @paths_data = _get_paths_of_data()

    @response = _static_analys(@paths_data)
    if (!@response['status']) {
        _error(@response['message'])
    } else {
        _log('INFO', @response['message'])
    }

    @model = _model_init(@response['data']) 

    include('register_script.ms')
    x_recompile_includes(@paths_data['script'])
    x_recompile_includes(@paths_data['localPackages'])
    _register_scripts(
        @model,
        _get_src('core.event.api_register.ms'),
        _get_src('api.api_loader.ms'),
        array_map(@model['data']['scripts'], closure(@v) {return(@v['object'])}),
        @paths_data['localPackages']._util_sdn().'main.ms'
    )

    include('create_npc.ms')
    switch(@mode) {
        case 'update':
            _update_npc(@model)
            break();
        case 'reset':
            _reset_npc(@model)
            break();
    }

    _log('INFO', 'Finish load model')
    _log('INFO', 'Registration command "quest"')
    include('model_command.ms')
}

execute(closure() {
    register_command('msquest', array(
        'description': 'MSQuest module control',
        'usage': '/msquest',
        'aliases':array('msq'),

        'executor': closure() {
            if (array_size(@arguments[2]) == 0) {
                _error("No arguments, possible 'analys', 'load'")
            }
            @args = if(array_size(@arguments[2]) > 1, @arguments[2][1..], array())
            @mode = @arguments[2][0]
            @modes = array('analys', 'load')
            if (!array_contains(@modes, @mode)) {
                _error("Unknown argument: @mode, possible 'load', 'analys'")
            }
            switch(@mode) {
                case 'analys':
                    _msquest_SA(@args)
                    break();
                case 'load':
                    _msquest_load_model(@args)
                    break();
            }
        }
    ))
    set_tabcompleter('msquest', closure(@alias, @sender, @args, @info) {
    	@input = @args[-1];
    	@completions = array();
    	if(array_size(@args) == 1) {
    		@completions = array('analys', 'load');
    	} else if(array_size(@args) == 2 && @args[0] == 'load') {
    		@completions = array('reset', 'update');
    	}
    	return(array_filter(@completions, closure(@key, @value) {
    		return(length(@input) <= length(@value) 
    				&& equals_ic(@input, substr(@value, 0, length(@input))));
    	}));
    });
})