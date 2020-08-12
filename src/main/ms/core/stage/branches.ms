execute(closure() {

    @super_methods = associative_array(
        getCurrent: closure(array @self) {
            return(@self['current'])
        },
        getTime: closure(array @self) {
            return(@self['time'])
        }
    )

    @is_stage_single = closure(array @self, string @stage) {
        return(@stage == _method(@self, 'get'))
    }

    @is_stage_array = closure(array @self, array @stages) {
        @cur_stages = _method(@self, 'get')
        foreach(@stage in @stages) {
            if (!array_contains(@cur_stages, @stage)) {
                return(false)
            }
        }
        return(true)
    }

    @get_stage_array = closure(array @self) {
        @stages = array()
        array_sort(@self['current'])
        foreach(@index in @self['current']) {
            @stages[] = @self['stages'][@index]
        }
        return(@stages)
    }

    @get_stage = closure(array @self) {
        return(@self['stages'][@self['current']])
    }

    @to_next_it = closure(array @self) {
        if (@self['current'] == array_size(@self['stages']) - 1) {
            throw(Exception, 'Exceeded the iteration of stages')
        }
        @self['current'] = @self['current'] + 1
        @self['time'] = time()
    }
    @to_prev_it = closure(array @self) {
        if (@self['current'] == 0) {
            throw(Exception, 'Exceeded the iteration of stages')
        }
        @self['current'] = @self['current'] - 1
        @self['time'] = time()
    }

    @to_next = closure(array @self) {
        @self['current'] = (@self['current'] + 1) % array_size(@self['stages'])
        @self['time'] = time()
    }
    @to_prev = closure(array @self) {
        @self['current'] = (abs(@self['current'] - 1)) % array_size(@self['stages'])
        @self['time'] = time()
    }

    @set_set = closure(array @self, string @stage) {
        @index = array_index(@self['stages'], @stage)
        if (@index == null) {
            throw(NotFoundException, 'No such stage: '.@stage)
        }
        @self['current'] = @index
        @self['time'] = time()
    }
    @set_graph = closure(array @self, string @stage) {
        @index = array_index(@self['stages'], @stage)
        if (@index == null) {
            throw(NotFoundException, 'No such stage: '.@stage)
        }
        @status = @self['graph'][@self['current']][@index]
        if (@status == 0) {
            throw(IllegalArgumentException, 'Can\'t go to stage: '.@stage)
        }
        @self['current'] = @index
        @self['time'] = time()
    }
    @set_flag = closure(array @self, string @stage) {
        @index = array_index(@self['stages'], @stage)
        if (@index == null) {
            throw(NotFoundException, 'No such stage: '.@stage)
        }
        if (array_contains(@self['current'], @index)) {
            array_remove_values(@self['current'], @index)
        } else {
            @self['current'][] = @index
            @self['time'] = time()
        }
    }

    @unsupported_go_to = closure(array @self, string @stage) {
        throw(UnsupportedOperationException, 'Unsupported operation: _set_stage')
    }
    @unsupported_next = closure(array @self, string @stage) {
        throw(UnsupportedOperationException, 'Unsupported operation: _next_stage')
    }
    @unsupported_prev = closure(array @self, string @stage) {
        throw(UnsupportedOperationException, 'Unsupported operation: _prev_stage')
    }

    array @methods_of_class = associative_array()
    @methods_of_class['GraphBranch'] = associative_array(
        set: @set_graph,
        toNext: @unsupported_next,
        toPrev: @unsupported_prev,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['SetBranch'] = associative_array(
        set: @set_set,
        toNext: @unsupported_next,
        toPrev: @unsupported_prev,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['LinearBranch'] = associative_array(
        set: @unsupported_go_to,
        toNext: @to_next_it,
        toPrev: @to_prev_it,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['CycleBranch'] = associative_array(
        set: @unsupported_go_to,
        toNext: @to_next,
        toPrev: @to_prev,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['OrienLinearBranch'] = associative_array(
        set: @unsupported_go_to,
        toNext: @to_next_it,
        toPrev: @unsupported_prev,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['OrienCycleBranch'] = associative_array(
        set: @unsupported_go_to,
        toNext: @to_next,
        toPrev: @unsupported_prev,
        get: @get_stage,
        isStage: @is_stage_single
    )

    @methods_of_class['FlagBranch'] = associative_array(
        set: @set_flag,
        toNext: @unsupported_next,
        toPrev: @unsupported_prev,
        get: @get_stage_array,
        isStage: @is_stage_array
    )

    @methods = associative_array()
    foreach(@class: @o in @methods_of_class) {
        @methods[@class] = array_merge(@o, @super_methods)
    }
    export('org.cadabra.msquest.branches', @methods)
})

mixed proc _branch_default_current(string @type) {
    switch(@type) {
        case 'set':
        case 'linear':
        case 'orientated_linear':
        case 'cycle':
        case 'orientated_cycle':
        case 'graph':
            return(0)
        case 'flag':
            return(array())
        default:
            throw(IllegalArgumentException, 'Non-existent branch type')
    }
}

array proc _branch_init(array @branch_data, mixed @current, int @time) {
    switch(@branch_data['type']) {
        case 'set':
            @o = _branch_set(@branch_data['data'], @current, @time)
            return(@o)
        case 'linear':
            @o = _branch_linear(@branch_data['data'], @current, @time)
            return(@o)
        case 'orientated_linear':
            @o = _branch_orien_linear(@branch_data['data'], @current, @time)
            return(@o)
        case 'cycle':
            @o = _branch_cycle(@branch_data['data'], @current, @time)
            return(@o)
        case 'orientated_cycle':
            @o = _branch_orien_cycle(@branch_data['data'], @current, @time)
            return(@o)
        case 'graph':
            @o = _branch_graph(@branch_data['data'], @current, @time)
            return(@o)
        case 'flag':
            @o =  _branch_flag(@branch_data['data'], @current, @time)
            return(@o)
        default:
            throw(IllegalArgumentException, 'Non-existent branch type')
    }
}

array proc _branch_graph(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'GraphBranch'
    @o['stages'] = @data['stages']
    @o['graph'] = @data['graph']
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_set(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'SetBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_linear(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'LinearBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_cycle(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'CycleBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_orien_linear(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'OrienLinearBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_orien_cycle(array @data, int @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'OrienCycleBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

array proc _branch_flag(array @data, array @current, int @time) {
    array @o = associative_array()
    @o['class'] = 'FlagBranch'
    @o['stages'] = @data
    @o['current'] = @current
    @o['time'] = @time
    _branch_include_methods(@o)
    return(@o)
}

void proc _branch_include_methods(array @o) {
    foreach(@key: @method in import('org.cadabra.msquest.branches')[@o['class']]) {
        @o[@key] = @method
    }
}