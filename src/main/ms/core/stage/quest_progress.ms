array proc _quest_progress_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'QuestsProgress'
    @o['map'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.quest_progress')) {
        @o[@key] = @method
    }
    return(@o)
}

execute(closure() {
    @methods = associative_array()

    @methods['get'] = closure(array @self, string @quest) {
        if (array_index_exists(@self['map'], @quest)) {
            return(@self['map'][@quest])
        }
        @path = "@quest.yml"
        if (!_method(@self['io'], 'has', @path)) {
            return(null)
        }
        @quest_progress = _method(@self['io'], 'readYML', @path)
        @self['map'][@quest] = @quest_progress
        return(@quest_progress)
    }

    @methods['save'] = closure(array @self, array @quest_progress) {
        @self['map'][@quest_progress['id']] = @quest_progress
        _method(@self['io'], 'writeYML', @quest_progress, @quest_progress['id'].'.yml')
    }

    @methods['delete'] = closure(array @self, string @quest) {
        string @path = "@quest.yml"
        boolean @status = true
        if (!_method(@self['io'], 'has', @path)) {
            @status = false
        } else {
            _method(@self['io'], 'delete', @path)
        }
        @self['map'][@quest] = null
        _log('INFO', "Delete a quest - '@quest' progress. Status: @status")
    }

    @methods['clear'] = closure(array @self) {
        @files = _method(@self['io'], 'list')
        foreach(@file in @files) {
            _method(@self['io'], 'delete', @file)
        }
        @self['map'] = associative_array()
    }

    export('org.cadabra.msquest.quest_progress', @methods)
})