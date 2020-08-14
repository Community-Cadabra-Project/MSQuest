array proc _entity_repo_init(string @path) {
    array @self = associative_array()
    @self['class'] = 'EntityRepo'

    @self['map_UUID_ID'] = associative_array()
    @self['map_ID_UUID'] = associative_array()

    @self['file'] = 'entity_map.yml'
    @self['io'] = _iof_init(@path, _util_sdn())
    if (!_method(@self['io'], 'has', @self['file'])) {
        _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
    } else {
        @map_UUID_ID = _method(@self['io'], 'readYML', @self['file'])
        foreach(@uuid: @id in @map_UUID_ID) {
            @self['map_ID_UUID'][@id] = @uuid
            @self['map_UUID_ID'][@uuid] = @id
        }
    }

    foreach(@key: @method in import('org.cadabra.msquest.entity_repo')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    array @methods = associative_array()

    @methods['write'] = closure(array @self) {
        _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
    }

    @methods['save'] = closure(array @self, string @uuid, string @id, boolean @save = true) {
        if (array_index_exists(@self['map_UUID_ID'], @uuid)) {
            throw(IllegalArgumentException, "This uuid @uuid already saved")
        }
        if (array_index_exists(@self['map_ID_UUID'], @id)) {
            throw(IllegalArgumentException, "This id @id already saved")
        }
        @self['map_UUID_ID'][@uuid] = @id
        @self['map_ID_UUID'][@id] = @uuid
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
        }
    }

    @methods['hasID'] = closure(array @self, string @id) {
        return(boolean(_method(@self, 'getUUID', @id)))
    }

    @methods['hasUUID'] = closure(array @self, string @uuid) {
        return(boolean(_method(@self, 'getID', @uuid)))
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

    @methods['deleteID'] = closure(array @self, string @id, boolean @save = true) {
        @uuid = array_remove(@self['map_ID_UUID'], @id)
        if (!@uuid) {
            return(false)
        }
        @_id = array_remove(@self['map_UUID_ID'], @uuid)
        if (@id != @_id) {
            throw(Exception, "Table mismatch: @id -> @uuid -> @_id")
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
        }
        return(true)
    }

    @methods['deleteUUID'] = closure(array @self, string @uuid, boolean @save = true) {
        @id = array_remove(@self['map_UUID_ID'], @uuid)
        if (!@id) {
            return(false)
        }
        @_uuid = array_remove(@self['map_ID_UUID'], @id)
        if (@_uuid != @uuid) {
            throw(Exception, "Table mismatch: @uuid -> @id -> @_uuid")
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_ID'], @self['file'])
        }
        return(true)
    }

    @methods['clear'] = closure(array @self) {
        @self['map_UUID_ID'] = associative_array()
        @self['map_ID_UUID'] = associative_array()

        if (_method(@self['io'], 'has', @self['file'])) {
            _method(@self['io'], 'delete', @self['file'])
        }
    }

    @methods['getAllUUID'] = closure(array @self) {
        return(array_keys(@self['map_UUID_ID']))
    }

    @methods['getAllID'] = closure(array @self) {
        return(array_keys(@self['map_ID_UUID']))
    }

    export('org.cadabra.msquest.entity_repo', @methods)
})