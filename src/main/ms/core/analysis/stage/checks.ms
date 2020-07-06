/*
Exceptions:
    keySet: type, args, [msg]
- cast_exception
    args: [expect_type, actually_type, path]
- key_not_found_exception
    args: []
- size_graph_exception
    args: [expect_type, actually_type, path]
- contain_graph_exception
    args: [possible, actually, path]
- stage_duplicate_exception
    args: [stage, path]
- unreachable_points_exception
    args: [stages, path]
- tree_head_exception
    args: [path]
- tree_node_exception
    args: [actually_type, path]
- unknown_keys_exception
    args: [keys, path]
*/

proc _is_ass_array(mixed @data, array @keys, string @path) {
    if (!is_array(@data)) {
        @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@data), @path))
        return(@error)
    }
    if (!is_associative(@data)) {
        @error = _init_exception('cast_exception', array('associated array', 'linear array', @path))
        return(@error)
    }
    if (@keys && array_size(@data) != array_size(@keys)) {
        @unknown = _util_array_minus(array_keys(@data), @keys)
        if (array_size(@unknown) != 0) {
            @error = _init_exception('unknown_keys_exception', array(@unknown, @path))
            return(@error)
        }
    }
    return(false)
}

proc _is_lin_array(mixed @data, string @path) {
    if (!is_array(@data)) {
        @error = _init_exception('cast_exception', array('ms.lang.array', typeof(@data), @path))
        return(@error)
    }
    if (is_associative(@data)) {
        @error = _init_exception('cast_exception', array('linear array', 'associated array', @path))
        return(@error)
    }
    return(false)
}

proc _valide_stages(array @data, string @path) {
    @set = array()
    foreach(@o in @data) {
        if (!is_string(@o)) {
            @error = _init_exception('cast_exception', array('ms.lang.string', typeof(@o), @path.string(@o)), 'Stages must be of type "string"')
            return(@error)
        }
        if (array_contains(@set, @o)) {
            @error = _init_exception('stage_duplicate_exception', array(@o, @path))
            return(@error)
        }
        array_push(@set, @o)
    }
    return(false)
}

# Checker
proc _array(mixed @data, string @path) {
    @error = _is_lin_array(@data, @path)
    if (@error) {
        return(@error)
    }
    @error = _valide_stages(@data, @path)
    if (@error) {
        return(@error)
    }
    return(false)
}

proc _is_grapth(mixed @g, int @size, string @path) {
    @error = _is_lin_array(@g, @path)
    if (@error) {
        return(@error)
    }

    if (array_size(@g) != @size) {
        @error = _init_exception('size_graph_exception', array(@size, array_size(@g), "@path"))
        return(@error)
    }

    for(@i = 0, @i < @size, @i++) {
        @row = @g[@i]
        @error = _is_lin_array(@row, "@path[@i]")
        if (@error) {
            return(@error)
        }
        if (array_size(@g) != @size) {
            @error = _init_exception('size_graph_exception', array(@size, array_size(@g), "@path"))
            return(@error)
        }
        for(@j = 0, @j < @size, @j++) {
            if (@row[@j] != 0 && @row[@j] != 1) {
                @error = _init_exception('contain_graph_exception', array(array(0, 1), @row[@j], "@path[@i][@j]"))
                return(@error)
            }
        }
    }
    return(false)
}

proc _visitor(array @g, int @pos, array @set) {
    for(@i = 0, @i < array_size(@g), @i++) {
        if (array_contains(@set, @i)) {
            continue()
        }
        if (@g[@pos][@i] == 1) {
            array_push(@set, @i)
            _visitor(@g, @i, @set)
        }
    }
    return(false)
}

# Checker
proc _graph(mixed @data, string @path) {
    @error = _is_ass_array(@data, array('stages', 'graph'), @path)
    if (@error) {
        return(@error)
    }

    @key_stages = 'stages'
    if (!array_index_exists(@data, @key_stages)) {
        @error = _init_exception('key_not_found_exception', array(@key_stages))
        return(@error)
    }
    @error = _array(@data[@key_stages], "@path.data.@key_stages")
    if (@error) {
        return(@error)
    }

    @key_graph = 'graph'
    if (!array_index_exists(@data, @key_graph)) {
        @error = _init_exception('key_not_found_exception', array("@path.graph"))
        return(@error)
    }
    @error = _is_grapth(@data[@key_graph], array_size(@data[@key_stages]), "@path.@key_graph")
    if (@error) {
        return(@error)
    }

    @set = array(0)
    _visitor(@data[@key_graph], 0, @set)
    @points = _util_array_minus(range(array_size(@data[@key_stages])), @set)
    if (array_size(@points) != 0) {
        @error = _init_exception(
            'unreachable_points_exception',
            array(array_map(@points, closure(@i) {
                return(@data[@key_stages])
            }), "@path.@key_graph")
        )
        return(@error)
    }
    return(false)
}

proc _node(mixed @n, string @path, array @set) {
    if (is_associative(@n)) {
        foreach(@key in array_keys(@n)) {
            @error = _node(@n[@key], "@path.@key")
            if (@error) {
                return(@error)
            }
        }
    } else if (is_string(@n)) {
        return(false)
    } else {
        return(_init_exception('tree_node_exception', array(typeof(@n), @path)))
    }
    return(false) 
}

# Checker
proc _tree(mixed @data, string @path) {
    @error = _is_ass_array(@data, null, @path)
    if (@error) {
        return(@error)
    }
    @keys = array_keys(@data)
    if (array_size(@keys) != 0) {
        @error = _init_exception('tree_head_exception', array("@path.data"))
        return(@error)
    }
    @error = _node(@data[@keys[0]], @path.@keys[0])
    if (@error) {
        return(@error)
    }
    return(false)
}