array proc _group_repo_init(string @path) {
    array @self = associative_array()
    @self['class'] = 'GroupRepo'

    @self['map_UUID_GROUP'] = associative_array()
    @self['map_GROUP_UUID'] = associative_array()

    @self['file'] = 'group_map.yml'
    @self['io'] = _iof_init(@path, _util_sdn())
    if (!_method(@self['io'], 'has', @self['file'])) {
        _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
    } else {
        @map_UUID_GROUP = _method(@self['io'], 'readYML', @self['file'])
        foreach(@uuid: @groups in @map_UUID_GROUP) {
            @self['map_UUID_GROUP'][@uuid] = array()
            foreach(@group in @groups) {
                if (array_index_exists(@self['map_GROUP_UUID'], @group)) {
                    @self['map_GROUP_UUID'][@group][] = @uuid
                } else {
                    @self['map_GROUP_UUID'][@group] = array(@uuid)
                }
                @self['map_UUID_GROUP'][@uuid][] = @group
            }
        }
    }

    foreach(@key: @method in import('org.cadabra.msquest.group_repo')) {
        @self[@key] = @method
    }
    return(@self)
}

execute(closure() {
    array @methods = associative_array()

    @methods['write'] = closure(array @self) {
        _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
    }

    @methods['save'] = closure(array @self, array @uuids, array @groups, boolean @save = true) {
        @_uuid = null
        foreach(@uuid in @uuids) {
            foreach(@group in @groups) {
                if (array_index_exists(@self['map_GROUP_UUID'], @group)) {
                    if (!array_contains( @self['map_GROUP_UUID'][@group], @uuid)) {
                        @self['map_GROUP_UUID'][@group][] = @uuid
                    }
                } else {
                    @self['map_GROUP_UUID'][@group] = array(@uuid)
                }
                if (array_index_exists(@self['map_UUID_GROUP'], @uuid)) {
                    if (!array_contains(@self['map_UUID_GROUP'][@uuid], @group)) {
                        @self['map_UUID_GROUP'][@uuid][] = @group
                    }
                } else {
                    @self['map_UUID_GROUP'][@uuid] = array(@group)
                }
            }
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
        }
    }

    @methods['hasGroup'] = closure(array @self, string @group) {
        return(boolean(_method(@self, 'getUUIDs', @group)))
    }

    @methods['hasUUID'] = closure(array @self, string @uuid) {
        return(boolean(_method(@self, 'getGroups', @uuid)))
    }

    @methods['getUUIDs'] = closure(array @self, @group) {
        if (array_index_exists(@self['map_GROUP_UUID'], @group)) {
            return(array_deep_clone(@self['map_GROUP_UUID'][@group]))
        } else {
            return(array())
        }
    }

    @methods['getGroups'] = closure(array @self, string @uuid) {
        if (array_index_exists(@self['map_UUID_GROUP'], @uuid)) {
            return(array_deep_clone(@self['map_UUID_GROUP'][@uuid]))
        } else {
            return(array())
        }
    }

    @methods['unbindGroups'] = closure(array @self, string @uuid, array @groups, boolean @save = true) {
        if (!array_index_exists(@self['map_UUID_GROUP'], @uuid)) {
            return()
        }
        foreach(@group in @groups) {
            array_remove_values(@self['map_UUID_GROUP'][@uuid], @group)
            if (array_index_exists(@self['map_GROUP_UUID'], @group)) {
                array_remove_values(@self['map_GROUP_UUID'][@group], @uuid)
                if (!@self['map_GROUP_UUID'][@group]) {
                    array_remove(@self['map_GROUP_UUID'], @group)
                }
            }
            if (!@self['map_UUID_GROUP'][@uuid]) {
                array_remove(@self['map_UUID_GROUP'], @uuid)
            }
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
        }
    }

    // @methods['unbindUUIDs'] = closure(array @self, string @group, array @uuids) {
    //     if (!array_index_exists(@self['map_GROUP_UUID'], @group)) {
    //         return(false)
    //     }
    //     foreach(@uuid in @uuids) {
    //         array_remove_values(@self['map_GROUP_UUID'][@group], @uuid)
    //         if (array_index_exists(@self['map_UUID_GROUP'], @uuid)) {
    //             array_remove_values(@self['map_UUID_GROUP'][@uuid], @group)
    //         }
    //     }
    //     _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
    //     return(true)
    // }

    @methods['deleteGroup'] = closure(array @self, string @group, boolean @save = true) {
        @uuids = array_remove(@self['map_GROUP_UUID'], @group)
        if (!@uuids) {
            return(false)
        }
        foreach(@uuid in @uuids) {
            array_remove_values(@self['map_UUID_GROUP'][@uuid], @group)
            if (!@self['map_UUID_GROUP'][@uuid]) {
                array_remove(@self['map_UUID_GROUP'], @uuid)
            }
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
        }
    }

    @methods['deleteUUID'] = closure(array @self, string @uuid, boolean @save = true) {
        @groups = array_remove(@self['map_UUID_GROUP'], @uuid)
        if (!@groups) {
            return(false)
        }
        foreach(@group in @groups) {
            array_remove_values(@self['map_GROUP_UUID'][@group], @uuid)
            if (!@self['map_GROUP_UUID'][@group]) {
                array_remove(@self['map_GROUP_UUID'], @group)
            }
        }
        if (@save) {
            _method(@self['io'], 'writeYML', @self['map_UUID_GROUP'], @self['file'])
        }
    }

    @methods['clear'] = closure(array @self) {
        @self['map_UUID_GROUP'] = associative_array()
        @self['map_GROUP_UUID'] = associative_array()

        if (_method(@self['io'], 'has', @self['file'])) {
            _method(@self['io'], 'delete', @self['file'])
        }
    }

    @methods['getAllUUID'] = closure(array @self) {
        return(array_keys(@self['map_UUID_GROUP']))
    }

    @methods['getAllGroup'] = closure(array @self) {
        return(array_keys(@self['map_GROUP_UUID']))
    }

    export('org.cadabra.msquest.group_repo', @methods)
})