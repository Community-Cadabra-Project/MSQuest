array proc _qprogress_repo_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'QuestsProgress'
    @o['cash'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.qprogress')) {
        @o[@key] = @method
    }
    return(@o)
}

execute(closure() {
    @methods = associative_array()

    @methods['get'] = closure(array @self, string @quest) {
        if (array_index_exists(@self['cash'], @quest) && @self['cash'][@quest]) {
            return(@self['cash'][@quest])
        }
        @path = "@quest.yml"
        if (!_method(@self['io'], 'has', @path)) {
            return(null)
        }
        @qprogress = _method(@self['io'], 'readYML', @path)
        @self['cash'][@quest] = @qprogress
        return(@qprogress)
    }

    @methods['save'] = closure(array @self, array @qprogress) {
        @self['cash'][@qprogress['quest']] = @qprogress
        _method(@self['io'], 'writeYML', @qprogress, @qprogress['quest'].'.yml')
    }

    @methods['delete'] = closure(array @self, string @quest) {
        string @path = "@quest.yml"
        boolean @status = true
        if (!_method(@self['io'], 'has', @path)) {
            @status = false
        } else {
            _method(@self['io'], 'delete', @path)
        }
        @self['cash'][@quest] = null
        _log('INFO', "Delete a quest - '@quest' progress. Status: @status")
        return(@status)
    }

    @methods['clearCash'] = closure(array @self) {
        @self['cash'] = associative_array()
    }

    export('org.cadabra.msquest.qprogress', @methods)
})