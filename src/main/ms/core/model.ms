proc _model_init(array @data) {
    array @model = associative_array()

    @model['data'] = @data

    @temp_rpogress = associative_array()
    foreach(@stage in array_map(@data['stages'], closure(@v) {return(@v['object'])})) {
        @id = @stage['id']
        @temp_rpogress[@id] = @stage
    }
    @model['template_progress'] = @temp_rpogress

    @templates_entity = associative_array()
    foreach(@temp in @data['entities']) {
        @templates_entity[_entity_get_id(@temp['object'])] = @temp['object']
    }
    @model['entities'] = @templates_entity

    @entities = associative_array()
    foreach(@entity in array_filter(@data['entities'], closure(@k, @v) {return(@v['is_npc'])})) {
        @entities[_entity_get_id(@entity['object'])] = @entity['object']
    }
    @model['npc'] = @entities

    @dialogs = associative_array()
    foreach(@dialog in array_map(@data['dialogs'], closure(@v) {return(@v['object'])})) {
        @id = @dialog['id']
        @dialogs[@id] = @dialog['message']
    }
    @model['dialogs']['mapID'] = @dialogs

    @repos = associative_array()
    
    @cache_path = _get_data('.cache')._util_sdn().'repo'._util_sdn().'quest'
    _util_make_folder(@cache_path, -3)
    @repos['quest'] = _qprogress_repo_init(@cache_path)
    
    @cache_path = _get_data('.cache')._util_sdn().'repo'._util_sdn().'player'
    _util_make_folder(@cache_path, -3)
    @repos['player'] = _pprogress_repo_init(@cache_path)
    
    @cache_path = _get_data('.cache')._util_sdn().'repo'._util_sdn().'entity'
    _util_make_folder(@cache_path, -3)
    @repos['entity'] = _entity_repo_init(@cache_path)
    
    @cache_path = _get_data('.cache')._util_sdn().'repo'._util_sdn().'group'
    _util_make_folder(@cache_path, -3)
    @repos['group'] = _group_repo_init(@cache_path)
   
    @model['repo'] = @repos

    @entity = associative_array()
    @entity['creater'] = _entity_creater_init()
    @model['entity'] = @entity

    @event = associative_array()
    @event['map'] = _map_events_init()
    @model['event'] = @event

    foreach(@key: @method in import('org.cadabra.msquest.model')) {
        @model[@key] = @method
    }

    return(@model)
}

execute(closure() {
    @methods = associative_array()

    @methods['addNPCIfAbsent'] = closure(array @self, array @npc) {
        @creater = @self['entity']['creater']
        @entity_repo = @self['repo']['entity']
        @group_repo = @self['repo']['group']
        if (!_method(@entity_repo, 'hasID', _entity_get_id(@npc))) {
            @uuid = _method(@creater, 'create', @npc)
            if (@groups = _entity_get_group(@npc)) {
                _method(@group_repo, 'save', array(@uuid), @groups)
            }
            _method(@entity_repo, 'save', @uuid, _entity_get_id(@npc))
            return(@uuid)
        }
        return(null)
    }

    @methods['setNPC'] = closure(array @self, array @npc) {
        @creater = @self['entity']['creater']
        @entity_repo = @self['repo']['entity']
        @group_repo = @self['repo']['group']
        @id = _entity_get_id(@npc)
        @uuid = _method(@entity_repo, 'getUUID', @id)
        if (!@uuid) {
            @uuid = _method(@creater, 'create', @npc)
            if (@groups = _entity_get_group(@npc)) {
                _method(@group_repo, 'save', array(@uuid), @groups)
            }
            _method(@entity_repo, 'save', @uuid, @id)
            return(@uuid)
        } else {
            @_id = _method(@entity_repo, 'getID', @uuid)
            if (is_entity_living(@uuid)) {
                entity_remove(@uuid)
            }
            _method(@entity_repo, 'deleteUUID', @uuid, false)
            _method(@group_repo, 'deleteUUID', @uuid)
            @uuid = _method(@creater, 'create', @npc)
            if (@groups = _entity_get_group(@npc)) {
                _method(@group_repo, 'save', array(@uuid), @groups)
            }
            _method(@entity_repo, 'save', @uuid, @id)
            return(@uuid)
        }
    }

    @methods['removeNPC'] = closure(array @self, string @id) {
        @entity_repo = @self['repo']['entity']
        @group_repo = @self['repo']['group']
        @uuid = _method(@entity_repo, 'getUUID', @id)
        if (@uuid) {
            if (is_entity_living(@uuid)) {
                entity_remove(@uuid)
            }
            _method(@entity_repo, 'deleteUUID', @uuid)
            _method(@group_repo, 'deleteUUID', @uuid)
        }
        return(@uuid)
    }

    @methods['removeGroup'] = closure(array @self, string @group) {
        @entity_repo = @self['repo']['entity']
        @group_repo = @self['repo']['group']
        @uuids = _method(@group_repo, 'getUUIDs', @group)
        foreach(@uuid in @uuids) {
            if (is_entity_living(@uuid)) {
                entity_remove(@uuid)
            }
            _method(@entity_repo, 'deleteUUID', @uuid, false)
        }
        _method(@entity_repo, 'write')
        _method(@group_repo, 'deleteGroup', @group)
        return(@uuids)
    }

    @methods['getPProgress'] = closure(array @self, string @quest, string @player) {
        @temp = @self['template_progress'][@quest]
        @pp = _method(@self['repo']['player'], 'get', @quest, @player)
        if (@pp == null) {
            @pp = _pprogress_default_data(@player, @temp)
        }
        @pprogress = _pprogress_init(@temp, @pp)
        return(@pprogress)
    }

    @methods['getQProgress'] = closure(array @self, string @quest) {
        @qp = _method(@self['repo']['quest'], 'get', @quest)
        if (@qp) {
            @temp = @self['template_progress'][@quest]
            @qp = _qprogress_default(@temp)
        }
        return(@qp)
    }

    @methods['savePProgress'] = closure(array @self, array @pprogress) {
        _method(@self['repo']['player'], 'save', _method(@pprogress, 'getData'))
    }

    @methods['saveQProgress'] = closure(array @self, array @qprogress) {
        _method(@self['repo']['quest'], 'save', @qprogress)
    } 

    export('org.cadabra.msquest.model', @methods)
})