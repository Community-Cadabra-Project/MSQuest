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
- id_exception
    args: { 0 : id }
*/

//return (false) means that validation is successful


proc _package_quest_character_check_int(mixed @value, mixed @data, array @character) {
    if (!is_integer(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.integer', typeof(@value)))
        return(@error)
    }
    if ((@error = _private_quest_character_check_number(@value, @data, @character))) {
        return(@error)
    }
    return(false)
}

proc _package_quest_character_check_double(mixed @value, mixed @data, array @character) {
    if (!is_double(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.double', typeof(@value)))
        return(@error)
    }
    if ((@error = _private_quest_character_check_number(@value, @data, @character))) {
        return(@error)
    }
    return(false)
}

proc _private_quest_character_check_number(number @value, mixed @data, array @character) {
    if (@data == null) {
        return(false)
    }
    foreach(@mode: @info in @data) {
        switch(@mode) {
            case 'range':
                @less = _private_quest_character_check_get_number(@info[0], @character)
                if (is_array(@less)) {
                    return(@less)
                }
                @more = _private_quest_character_check_get_number(@info[1], @character)
                if (is_array(@more)) {
                    return(@more)
                }
                if (@value < @less || @value > @more) {
                    @error = _quest_init_exception('range_exception', array(@info[0], @info[1], @value))
                    return(@error)
                }
                break()
            case 'less':
                @more = _private_quest_character_check_get_number(@info, @character)
                if (is_array(@more)) {
                    return(@more)
                }
                if (@value > @more) {
                    @error = _quest_init_exception('less_exception', array(@value, @info))
                    return(@error)
                }
                break()
             case 'more':
                @less = _private_quest_character_check_get_number(@info, @character)
                if (is_array(@less)) {
                    return(@less)
                }
                if (@value < @less) {
                    @error = _quest_init_exception('more_exception', array(@value, @info))
                    return(@error)
                }
                break()
        }
    }
    return(false)
}

proc _private_quest_character_check_get_number(mixed @val, array @character) {
    if (is_number(@val)) {
        return(@val)
    } else if (is_string(@val)) {
        @paths = reg_split('[.]', @val)
        @attr = @character
        foreach(@path in @paths) {
            if (array_index_exists(@attr, @path)) {
                @attr = @attr[@path]
            } else {
                @error = _quest_init_exception('key_path_exception', array(array_implode(@paths, '.'), @attr))
            }
        }
        if (!is_number(@attr)) {
            @error = _quest_init_exception('ref_cast_exception', array(array_implode(@paths, '.'), 'ms.lang.number', typeof(@attr)))
        } 
        return(@attr)
    } else {
        _quest_error('pass', array(to_upper(@character['type'])))
    }
}

proc _package_quest_character_check_boolean(mixed @value, mixed @data, array @character) {
    if (!is_boolean(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.boolean', typeof(@value)))
        return(@error)
    }
    return(false)
}

proc _package_quest_character_check_string(mixed @value, mixed @data, array @character) {
    if (!is_string(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.string', typeof(@value)))
        return(@error)
    }
    return(false)
}

proc _package_quest_character_check_list(mixed @value, array @data, array @character) {
    if (is_array(@value)) {
        foreach(@v in @value) {
            if (!array_contains(@data, to_lower(string(@v)))) {
                @error = _quest_init_exception('contains_exception', array(@v, @data))
                return(@error)
            }
        }
    } else {
        if (!array_contains(@data, to_lower(string(@value)))) {
            @error = _quest_init_exception('contains_exception', array(@value, @data))
            return(@error)
        }
    }
    return(false)
}

proc _package_quest_character_check_local(@value, mixed @data, array @character) {
    if (!is_array(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.array', typeof(@value)))
        return(@error)
    }
    if (array_size(@value) != 3) {
        @error = _quest_init_exception('size_exception', array(3, array_size(@value)))
        return(@error)
    }
    foreach(@coord in @value) {
        if (!is_number(@coord)) {
            @error = _quest_init_exception('cast_exception', array('ms.lang.numer', typeof(@coord)), 'Coordinates must be the numbers')
            return(@error)
        }
    }
    return(false)
}

proc _package_quest_character_check_uuid(mixed @value, mixed @data, array @character) {
    if (!is_string(@value)) {
        @error = _quest_init_exception('cast_exception', array('ms.lang.string', typeof(@value)))
        return(@error)
    }
    return(false)
}

proc _package_quest_character_check_nothink(mixed @value, mixed @data, array @character) {
    return(false)
}