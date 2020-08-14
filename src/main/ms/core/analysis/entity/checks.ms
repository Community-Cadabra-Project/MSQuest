/*
Exceptions:
    keySet: type, args, [msg]
- cast_exception
    args: { 0 : expect_type, 1 : actually_type }
- range_exception
    args: { 0 : value, 1 : less, 2 : more}
- more_exception
    args: { 0 : value, 1 : more}
- less_exception
    args: { 0 : value, 1 : less}
- key_path_exception
    args: { 0 : keys, 1 : key}
- ref_cast_exception
    args: { 0 : keys, 1 : expect_type, 2 : actually_type}
- contains_exception
    args: { 0 : value, 1 : list}
- size_exception
    args: { 0 : expect_size, 1 : actually_size }
- size_range_exception
    args: { 0 : value, 1 : less, 2 : more}
- keys_exception
    args: { 0 : key, 1 : keys}
- set_keys_exception
    args: { 0 : keys}
- id_exception
    args: { 0 : id }
*/

//return (false) means that validation is successful

proc _list_string(@value, array @data, array @character) {
    if (!is_array(@value) || is_associative(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.array[not associative]', typeof(@value)))
        return(@error)
    }
    foreach(@v in @value) {
        if (!is_string(@v)) {
            @error = _init_exception('cast_exception', array('ms.lang.string', typeof(@v)))
            return(@error)
        }
    }
    return(false)
}

proc _equipment_droprates(@value, array @data, array @character) {
    if (!is_array(@value) || !is_associative(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.array[associative]', typeof(@value)))
        return(@error)
    }
    @keys = array_map(array_keys(@value), closure(@v) {
        return(to_lower(@v))
    })
    @exceptions = array()
    foreach(@key in @keys) {
        if (!array_contains(@data, @key)) {
            @error = _init_exception('keys_exception', array(@key, @data))
            return(@error)
        }
    }
    @res = array_intersect(@keys, @data)
    if (array_size(@res) != array_size(@data)) {
        @error =  _init_exception('set_keys_exception', array(@data))
        return(@error)
    }
    foreach(@key in @keys) {
        @error = _double(@value[@key], array(range: array(0, 1)), @character)
        if (@error) {
            @error['at'] = @key
            return(@error)
        }
    }
    return(false)
}

proc _effects(@value, array @data, array @character) {
     if (!is_array(@value) || is_associative(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.array[not associative]', typeof(@value)))
        return(@error)
    }
    for(@i = 0, @i < array_size(@value), @i++) {
        @v = @value[@i]
        if (@e = _effect(@v, @data, @character)) {
            @e['at'] = if (@e['at'], "[@i].".@e['at'], "[@i]")
            return(@e)
        }
    }
    return(false)
}


proc _effect(array @value, array @data, array @character) {
    if (!is_array(@value) || is_associative(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.array[not associative]', typeof(@value)))
        return(@error)
    }
    if (array_size(@value) < 1 || array_size(@value) > 5) {
        @error = _init_exception('size_range_exception', array(array_size(@value), 1, 5))
        return(@error)
    }

    @error = _list(@value[0], @data, @character)
    if (@error) {
        @error['at'] = "[0]"
        return(@error)
    }
    if (array_size(@value) > 1) {
        @error = _int(@value[1], array(range: array(0, 107374182)), @character)
        if (@error) {
            @error['at'] = "[1]"
            return(@error)
        }
    } else {
        return(false)
    }

    if (array_size(@value) > 2) {
        @error = _int(@value[2], array(more: 0), @character)
        if (@error) {
            @error['at'] = "[2]"
            return(@error)
        }
    } else {
        return(false)
    }

    if (array_size(@value) > 3) {
        @error = _boolean(@value[3], null, @character)
        if (@error) {
            @error['at'] = "[3]"
            return(@error)
        }
    } else {
        return(false)
    }

    if (array_size(@value) > 4) {
        @error = _boolean(@value[4], null, @character)
        if (@error) {
            @error['at'] = "[4]"
            return(@error)
        }
    } else {
        return(false)
    }
    return(false)
}


proc _int(mixed @value, mixed @data, array @character) {
    if (!is_integer(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.integer', typeof(@value)))
        return(@error)
    }
    if ((@error = _private_number(@value, @data, @character))) {
        return(@error)
    }
    return(false)
}

proc _double(mixed @value, mixed @data, array @character) {
    if (!is_double(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.double', typeof(@value)))
        return(@error)
    }
    if ((@error = _private_number(@value, @data, @character))) {
        return(@error)
    }
    return(false)
}

proc _private_number(number @value, mixed @data, array @character) {
    if (@data == null) {
        return(false)
    }
    foreach(@mode: @info in @data) {
        switch(@mode) {
            case 'range':
                @less = _private_get_number(@info[0], @character)
                if (is_array(@less)) {
                    return(@less)
                }
                @more = _private_get_number(@info[1], @character)
                if (is_array(@more)) {
                    return(@more)
                }
                if (@value < @less || @value > @more) {
                    @error = _init_exception('range_exception', array(@info[0], @info[1], @value))
                    return(@error)
                }
                break()
            case 'less':
                @more = _private_get_number(@info, @character)
                if (is_array(@more)) {
                    return(@more)
                }
                if (@value > @more) {
                    @error = _init_exception('less_exception', array(@value, @info))
                    return(@error)
                }
                break()
             case 'more':
                @less = _private_get_number(@info, @character)
                if (is_array(@less)) {
                    return(@less)
                }
                if (@value < @less) {
                    @error = _init_exception('more_exception', array(@value, @info))
                    return(@error)
                }
                break()
        }
    }
    return(false)
}

proc _private_get_number(mixed @val, array @character) {
    if (is_number(@val)) {
        return(@val)
    } else if (is_string(@val)) {
        @paths = reg_split('[.]', @val)
        @attr = @character
        foreach(@path in @paths) {
            if (array_index_exists(@attr, @path)) {
                @attr = @attr[@path]
            } else {
                @error = _init_exception('key_path_exception', array(array_implode(@paths, '.'), @attr))
            }
        }
        if (!is_number(@attr)) {
            @error = _init_exception('ref_cast_exception', array(array_implode(@paths, '.'), 'ms.lang.number', typeof(@attr)))
        } 
        return(@attr)
    } else {
        _qerror('pass', array(to_upper(@character['main']['type'])))
    }
}

proc _boolean(mixed @value, mixed @data, array @character) {
    if (!is_boolean(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.boolean', typeof(@value)))
        return(@error)
    }
    return(false)
}

proc _string(mixed @value, mixed @data, array @character) {
    if (!is_string(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.string', typeof(@value)))
        return(@error)
    }
    return(false)
}

proc _list(mixed @value, array @data, array @character) {
    if (is_array(@value)) {
        foreach(@v in @value) {
            if (!array_contains(@data, to_lower(string(@v)))) {
                @error = _init_exception('contains_exception', array(@v, @data))
                return(@error)
            }
        }
    } else {
        if (!array_contains(@data, to_lower(string(@value)))) {
            @error = _init_exception('contains_exception', array(@value, @data))
            return(@error)
        }
    }
    return(false)
}

proc _local(@value, mixed @data, array @character) {
    if (!is_array(@value) && is_associative(@value)) {
        @error = _init_exception('cast_exception', array('ms.lang.array[not associative]', typeof(@value)))
        return(@error)
    }
    if (array_size(@value) != 3) {
        @error = _init_exception('size_exception', array(3, array_size(@value)))
        return(@error)
    }
    foreach(@coord in @value) {
        if (!is_number(@coord)) {
            @error = _init_exception('cast_exception', array('ms.lang.numer', typeof(@coord)), 'Coordinates must be the numbers')
            return(@error)
        }
    }
    return(false)
}

proc _nothink(mixed @value, mixed @data, array @character) {
    return(false)
}