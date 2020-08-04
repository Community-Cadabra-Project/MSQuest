array proc _entity_repo_init(string @path) {
    array @self = associative_array()
    @self['class'] = 'EntityRepo'

    @self['map_UUID_ID'] = associative_array()
    @self['map_ID_UUID'] = associative_array()

    @self['file'] = 'entity_map.yml'
    @self['io'] = _iof_init(@path)
    if (!_method(@self['io'], 'has', @self['file'])) {
        _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
    } else {
        @map_UUID_ID = _method(@self['io'], 'readYML', @self['file'])
        foreach(@uuid: @id in @map_UUID_ID) {
            @self['map_ID_UUID'][@id] = @uuid
        }
    }

    foreach(@key: @method in import('org.cadabra.msquest.entity_repo')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    array @methods = associative_array()

    @check_id_uuid = closure(array @self, string @uuid, string @id) {
        if (array_index_exists(@self['map_UUID_ID'], @uuid)) {
            throw(IllegalArgumentException, "This uuid @uuid already exists")
        }
        if (array_index_exists(@self['map_ID_UUID'], @id)) {
            throw(IllegalArgumentException, "This id @id already exists")
        }
    }

    @save_map = closure(array @io, string @file, array @map) {
        _method(@io, 'writeYML', @map, @file)
    }

    @methods['save'] = closure(array @self, string @uuid, string @id) {
        execute(@self, @uuid, @id, @check_id_uuid)
        @self['map_UUID_ID'][@uuid] = @id
        @self['map_ID_UUID'][@id] = @uuid
        execute(@self['io'], @self['file'], @self['map_UUID_ID'], @save_map)
    }

    @methods['getUUID'] = closure(array @self, string @id) {
        if (array_index_exists(@self['map_ID_UUID'], @id)) {
            return(@self['map_ID_UUID'][@id])
        } else {
            return(null)
        }
    }

    @methods['getID'] = closure(array @self, string @uuid) {
        if (array_index_exists(@self['map_UUID_ID'], @uuid)) {
            return(@self['map_UUID_ID'][@uuid])
        } else {
            return(null)
        }
    }

    @methods['deleteID'] = closure(array @self, string @id) {
        @uuid = array_remove(@self['map_ID_UUID'], @id)
        if (!@uuid) {
            return(false)
        }
        @_id = array_remove(@self['map_UUID_ID'], @uuid)
        if (@id != @_id) {
            throw(Exception, "Table mismatch: @id -> @uuid -> @_id")
        }
        execute(@self['io'], @self['file'], @self['map_UUID_ID'], @save_map)
    }

    @methods['deleteUUID'] = closure(array @self, string @uuid) {
        @id = array_remove(@self['map_UUID_ID'], @uuid)
        if (!@id) {
            return(false)
        }
        @_uuid = array_remove(@self['map_ID_UUID'], @id)
        if (@_uuid != @uuid) {
            throw(Exception, "Table mismatch: @uuid -> @id -> @_uuid")
        }
        execute(@self['io'], @self['file'], @self['map_UUID_ID'], @save_map)
    }

    export('org.cadabra.msquest.entity_repo', @methods)
})