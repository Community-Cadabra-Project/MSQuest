/*
Exceptions:
- unknown_section_excetion
    args: {sections}
- id_exception
    args: {id}
- unknown_key_exception
    args: {}
- key_not_found_exception
    args: {}
- type_undefined_exception
    args: {}
*/

proc _pck_entity_checker_import() {
    return(import('org.cadabra.msquest.entity_checker'))
}

proc _pr_entity_checker_get_main() {
    return(_pck_entity_checker_import()['templates']['main'])
}

proc _pr_entity_checker_get_spec() {
    return(_pck_entity_checker_import()['templates']['spec'])
}

proc _pr_entity_checker_get_entity() {
    return(_pck_entity_checker_import()['templates']['entity'])
}

proc _pr_entity_checker_get_mob() {
    return(_pck_entity_checker_import()['templates']['mob'])
}

proc _pr_entity_checker_get_sections() {
    return(_pck_entity_checker_import()['templates']['sections'])
}

proc _pr_entity_checker_get_env() {
    return(_pck_entity_checker_import()['env'])
}

proc _pr_entity_checker_get_commander() {
    return(_pck_entity_checker_import()['commander'])
}

Resource proc _entity_checker_parse_exceptions(array @logs, Resource @builder = res_create_resource('STRING_BUILDER')) {
    @npc_logs = array_filter(@logs, closure(@k, @v) {return(@v['is_npc'])})
    @temp_logs = array_filter(@logs, closure(@k, @v) {return(!@v['is_npc'])})

    if (array_size(@npc_logs) != 0) {
        string_append(@builder, '############ NPC ############')
        string_append(@builder, '\n')
        foreach(@log in @npc_logs) {
            @id = @log['id']
            string_append(@builder, '\n############\n')
            string_append(@builder, 'Entity at: ')
            string_append(@builder, @id)
            foreach(@entry in @log['exceptions']) {
                @attr = @entry['key']
                @e = @entry['e']
                string_append(@builder, '\n- attribute: ')
                string_append(@builder, @attr)
                string_append(@builder, '\n\t')
                string_append(@builder, _parse_exception(@e))
                string_append(@builder, '\n')
            }
        }
    }
    
    if (array_size(@temp_logs) != 0) {
        string_append(@builder, '######### TEMPLATES #########')
        string_append(@builder, '\n')
        foreach(@log in @temp_logs) {
            @id = @log['id']
            string_append(@builder, '\n############\n')
            string_append(@builder, 'Entity at: ')
            string_append(@builder, @id)
            foreach(@entry in @log['exceptions']) {
                @attr = @entry['key']
                @e = @entry['e']
                string_append(@builder, '\n- attribute: ')
                string_append(@builder, @attr)
                string_append(@builder, '\n\t')
                string_append(@builder, _parse_exception(@e))
                string_append(@builder, '\n')
            }
        }
    }
    return(@builder)
}

array proc _entity_checker_ids(array @entries) {
    @ids = array()
    foreach(@entry in @entries) {
        @entity = @entry['entity']
        if (array_index_exists(@entity, 'main') && array_index_exists(@entity['main'], 'id') && is_string(@entity['main']['id'])) {
            @_id = @entity['main']['id']
            if (array_contains(@ids, @_id)) {
                continue()
            } else {
                @ids[] = @_id
            }
        }
    }
    return(@ids)
}

array proc _entity_checker_analys(array @entities) {
    @logs = array()
    @ids = array()
    foreach(@info_entity in @entities) {
        @is_npc = @info_entity['is_npc']
        @id = @info_entity['id']
        @entity = @info_entity['entity']

        @exceptions = _pr_entity_checker_single(@entity, @is_npc)
        @log_exist = false
        if (array_size(@exceptions) != 0) {
            @logs[] = array(is_npc: @is_npc, id: @id, exceptions: @exceptions)
            @log_exist = true
        }
        if (array_index_exists(@entity, 'main') && array_index_exists(@entity['main'], 'id') && is_string(@entity['main']['id'])) {
            @_id = @entity['main']['id']
            if (array_contains(@ids, @_id)) {
                @e = _init_exception('id_exception', array(@_id))
                _pr_entity_checker_put_exception(@exceptions, @e, 'main.id')
                if (!@log_exist) {
                    @logs[] = array(is_npc: @is_npc, id: @id, exceptions: @exceptions)
                }
            } else {
                @ids[] = @_id
            }
        }
    }
    return(@logs)
}

array proc _pr_entity_checker_single(array @entity, boolean @is_npc) {

    @commander = _pr_entity_checker_get_commander()
    
    @sections_temp = _pr_entity_checker_get_sections()
    @main_temp = _pr_entity_checker_get_main()
    @entity_temp = _pr_entity_checker_get_entity()
    @mob_temp = _pr_entity_checker_get_mob()
    @spec_temp = _pr_entity_checker_get_spec()

    @exceptions = array()

    if (@is_npc) {
        if (!array_index_exists(@entity, 'main')) {
            @e = _init_exception('key_not_found_exception')
            _pr_entity_checker_put_exception(@exceptions, @e, 'main')
            return(@exceptions)
        }
        array_push_all(@exceptions, _pr_entity_checker_sparams(
            @main_temp,
            @entity['main'],
            @entity,
            'main',
            @commander
        ))
    } else {
        if (array_index_exists(@entity, 'main')) {
            array_push_all(@exceptions, _pr_entity_checker_params(
                @main_temp,
                @entity['main'],
                @entity,
                'main',
                @commander
            ))
        }
    }

    @keys_entity = array_keys(@entity)
    @keys_sections = array_keys(@sections_temp)
    if (array_size(@unknown = _util_array_minus(@keys_entity, @keys_sections)) != 0) {
        @e = _init_exception('unknown_section_excetion', array(@unknown))
        _pr_entity_checker_put_exception(@exceptions, @e, './')
        return(@exceptions)
    }
    if (!array_index_exists(@entity['main'], 'type')) {
        @e = _init_exception('type_undefined_exception')
        _pr_entity_checker_put_exception(@exceptions, @e, 'main.type')
        return(@exceptions)
    } else {
        if (array_index_exists(@entity, 'entity')) {
            if (@e = _pr_entity_checker_param(
                @sections_temp['entity']['check'],
                @entity['main']['type'],
                @sections_temp['entity']['data'],
                @entity,
                @commander
            )) {
                _pr_entity_checker_put_exception(@exceptions, @e, 'entity')
            } else {
                array_push_all(@exceptions, _pr_entity_checker_params(
                    @entity_temp,
                    @entity['entity'],
                    @entity,
                    'entity',
                    @commander
                ))
            }
        }
        if (array_index_exists(@entity, 'mob')) {
            if (@e = _pr_entity_checker_param(
                @sections_temp['mob']['check'],
                @entity['main']['type'],
                @sections_temp['mob']['data'],
                @entity,
                @commander
            )) {
               _pr_entity_checker_put_exception(@exceptions, @e, 'mob')
            } else {
                array_push_all(@exceptions, _pr_entity_checker_params(
                    @mob_temp,
                    @entity['mob'],
                    @entity,
                    'mob',
                    @commander
                ))
            }
        }
        if (array_index_exists(@entity, 'spec')) {
            if (@e = _pr_entity_checker_param(
                @sections_temp['spec']['check'],
                @entity['main']['type'],
                @sections_temp['spec']['data'],
                @entity,
                @commander
            )) {
                _pr_entity_checker_put_exception(@exceptions, @e, 'spec')
            } else {
                array_push_all(@exceptions, _pr_entity_checker_params(
                    @spec_temp[@entity['main']['type']],
                    @entity['spec'],
                    @entity,
                    'spec',
                    @commander
                ))
            }
        }
    }
    return(@exceptions)
}

array proc _pr_entity_checker_params(array @temp, array @params, array @npc, string @section, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _init_exception('unknown_key_exception')
            _pr_entity_checker_put_exception(@exceptions, @e, "@section.@key")
        } else {
            @data = if (array_index_exists(@temp[@key], 'data'), @temp[@key]['data'], null)
            if (@e = _pr_entity_checker_param(
                @temp[@key]['check'],
                @value,
                @data,
                @npc,
                @commander
            )) {
                _pr_entity_checker_put_exception(@exceptions, @e, "@section.@key")
            }
        }
    }
    return(@exceptions)
}

array proc _pr_entity_checker_sparams(array @temp, array @params, array @npc, string @section, array @commander) {
    @exceptions = array()
    foreach(@key: @value in @temp) {
        if (!array_index_exists(@params, @key)) {
            @e = _init_exception('key_not_found_exception')
            _pr_entity_checker_put_exception(@exceptions, @e, "@section.@key")
        } else {
            @data = if (array_index_exists(@value, 'data'), @value['data'], null)
            if (@e = _pr_entity_checker_param(
                @value['check'],
                @params[@key],
                @data,
                @npc,
                @commander
            )) {
                _pr_entity_checker_put_exception(@exceptions, @e, "@section.@key")
            }
        }
    }
    foreach(@key: @value in @params) {
        if (!array_index_exists(@temp, @key)) {
            @e = _init_exception('unknown_key_exception')
            _pr_entity_checker_put_exception(@exceptions, @e, "@section.@key")
        }
    }
    return(@exceptions)
}

proc _pr_entity_checker_param(string @check, @value, @data, array @npc, array @commander) {
    return(_util_commander_execute(@commander, @check, @value, @data, @npc))
}

proc _entity_checker_init() {
    synchronized('org.cadabra.msquest.entity_checker') {
        if (_pck_entity_checker_import()) {
            return()
        }
        include('checks.ms')
        @commander = _util_commander_init_self()
    
        _util_commander_register_proc(@commander, 'int' , '_int')
        _util_commander_register_proc(@commander, 'double' , '_double')
        _util_commander_register_proc(@commander, 'boolean' , '_boolean')
        _util_commander_register_proc(@commander, 'string' , '_string')
        _util_commander_register_proc(@commander, 'list' , '_list')
        _util_commander_register_proc(@commander, 'local' , '_local')
        _util_commander_register_proc(@commander, 'uuid' , '_uuid')
        _util_commander_register_proc(@commander, '*' , '_nothink')
    
        @npc_samples = _util_get_all_files(_get_resource('template.npc.spec'))
        @npc_mob = yml_decode(read(_get_resource('template.npc.mob.yml')))
        @npc_entity = yml_decode(read(_get_resource('template.npc.entity.yml')))
        @npc_main = yml_decode(read(_get_resource('template.npc.main.yml')))
        @npc_sections = yml_decode(read(_get_resource('template.npc.sections.yml')))
    
        @npc_spec = array()
        foreach(@sample in @npc_samples) {
            if (string_contains(@sample, '.yml')) {
                @o = yml_decode(read(@sample))
                @npc_spec[@o['id']] = @o['spec'] 
            }
        }
        @templates = array()
        @templates['main'] = @npc_main
        @templates['sections'] = @npc_sections
        @templates['entity'] = @npc_entity
        @templates['spec'] = @npc_spec
        @templates['mob'] = @npc_mob
    
        @o = array(init: true, commander: @commander, templates: @templates)
        export('org.cadabra.msquest.entity_checker', @o)
    }
}

proc _pr_entity_checker_put_exception(@exceptions, @e, @key) {
    @exceptions[] = array(key: @key, e: @e)
}