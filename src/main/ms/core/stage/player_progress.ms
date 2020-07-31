array proc _player_progress_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'PlayersProgress'
    @o['map'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.player_progress')) {
        @o[@key] = @method
    }
    return(@o)
}


execute(closure() {    
    @methods = associative_array()

    @methods['get'] = closure(array @self, string @quest, string @player) {
        @cash = _method(@self, 'getCash', @quest, @player)
        if (@cash) {
            return(@cash)
        }
        @path = @player.'\\'.@quest.'.yml'
        if (!_method(@self['io'], 'has', @path)) {
            return(null)
        }
        @player_progress = _method(@self['io'], 'readYML', @path)
        if ((@p = @player_progress['player']) != @player) {
            throw(Exception, "Mismatch of the player with the requested. Expect: @player, actually: @p")
        }
        if ((@q = @player_progress['quest']) != @quest) {
            throw(Exception, "Mismatch of the player with the requested. Expect: @quest, actually: @q")
        } 
        _method(@self, 'addCash', @player_progress)
        return(@player_progress)
    }

    @methods['addCash'] = closure(array @self, array @data) {
        if (!array_index_exists(@self['map'], @data['player'])) {
            @self['map'][@data['player']] = associative_array()
        }
        @self['map'][@data['player']][@data['quest']] = @data
    }

    @methods['getCash'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['map'], @player) && array_index_exists(@self['map'][@player], @quest)) {
            return(@self['map'][@player][@quest])
        }
        return(null)
    }

    @methods['deleteCash'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['map'], @player) && array_index_exists(@self['map'][@player], @quest)) {
            @self['map'][@player][@quest] = null
        }
    }

    @methods['save'] = closure(array @self, array @player_progress) {
        _method(@self, 'addCash', @player_progress)
        if (!_method(@self['io'], 'has', @player_progress['player'])) {
            _method(@self['io'], 'createDir', @player_progress['player'])
        }
        _method(@self['io'], 'writeYML', @player_progress, @player_progress['player'].'\\'.@player_progress['quest'].'.yml')
    }

    @methods['delete'] = closure(array @self, string @quest, string @player) {
        string @path = @player.'\\'.@quest.'.yml'
        boolean @status = true
        if (!_method(@self['io'], 'has', @path)) {
            @status = false
        } else {
            _method(@self['io'], 'delete', @path)
            _method(@self, 'deleteCash', @quest, @player)
        }
        _method(@self, 'deleteCash', @quest, @player)
        _log('INFO', "Delete a player - '@player' progress in a quest - '@quest'. Status: @status")
        return(@status)
    }

    @methods['deletePlayer'] = closure(array @self, string @player) {
        boolean @status = true
        if (!_method(@self['io'], 'has', @player)) {
            @status = false
        } else {
            _method(@self['io'], 'delete', @player)
        }
        @self['map'][@player] = associative_array()
        _log('INFO', "Delete a player - '@player' progress in all quests. Status: @status")
        return(@status)
    }

    @methods['deleteQuest'] = closure(array @self, string @quest) {
        boolean @status = false
        foreach(@player in _method(@self['io'], 'list')) {
            @path = @player.'\\'.@quest.'.yml'
            if (@status || _method(@self['io'], 'has', @path)) {
                _method(@self['io'], 'delete', @path)
                @status = true
            }
        }
        foreach(@player in array_keys(@self['map'])) {
            _method(@self, 'deleteCash', @quest, @player)
        }
        _log('INFO', "Delete the all players progress for quest - '@quest'. Status: @status")
        return(@status)
    }

    export('org.cadabra.msquest.player_progress', @methods)
})