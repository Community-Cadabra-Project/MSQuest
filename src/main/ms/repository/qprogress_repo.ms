array proc _qprogress_repo_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'QuestsProgressRepo'
    @o['cache'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.qprogress')) {
        @o[@key] = @method
    }
    return(@o)
}

execute(closure() {
    @methods = associative_array()

    @methods['get'] = closure(array @self, string @quest) {
        if (array_index_exists(@self['cache'], @quest) && @self['cache'][@quest]) {
            return(@self['cache'][@quest])
        }
        @path = "@quest.yml"
        if (!_method(@self['io'], 'has', @path)) {
            return(null)
        }
        @qprogress = _method(@self['io'], 'readYML', @path)
        @self['cache'][@quest] = @qprogress
        return(@qprogress)
    }

    @methods['save'] = closure(array @self, array @qprogress) {
        @self['cache'][@qprogress['quest']] = @qprogress
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
        @self['cache'][@quest] = null
        return(@status)
    }

    @methods['clearCache'] = closure(array @self) {
        @self['cache'] = associative_array()
    }

    export('org.cadabra.msquest.qprogress', @methods)
})