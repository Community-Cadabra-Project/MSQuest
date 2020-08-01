array proc _pprogress_repo_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'PlayersProgress'
    @o['cash'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.pprogress')) {
        @o[@key] = @method
    }
    return(@o)
}


execute(closure() {

    # private methods

    @pmethods = associative_array()

    @pmethods['addCash'] = closure(array @self, array @data) {
        if (!array_index_exists(@self['cash'], @data['player'])) {
            @self['cash'][@data['player']] = associative_array()
        }
        @self['cash'][@data['player']][@data['quest']] = @data
    }

    @pmethods['getCash'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['cash'], @player) && array_index_exists(@self['cash'][@player], @quest)) {
            return(@self['cash'][@player][@quest])
        }
        return(null)
    }

    @pmethods['deleteCash'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['cash'], @player) && array_index_exists(@self['cash'][@player], @quest)) {
            @self['cash'][@player][@quest] = null
        }
    }

    @methods = associative_array(__private_methods__: @pmethods)

    @methods['get'] = closure(array @self, string @quest, string @player) {
        @cash = _private_method(@self, 'getCash', @quest, @player)
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
        _private_method(@self, 'addCash', @player_progress)
        return(@player_progress)
    }

    @methods['save'] = closure(array @self, array @player_progress) {
        _private_method(@self, 'addCash', @player_progress)
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
        }
        _private_method(@self, 'deleteCash', @quest, @player)
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
        _method(@self, 'deletePlayerCash', @player)
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
        _method(@self, 'deleteQuestCash', @quest)
        _log('INFO', "Delete the all players progress for quest - '@quest'. Status: @status")
        return(@status)
    }

    @methods['deletePlayerCash'] = closure(array @self, string @player) {
        @self['cash'][@player] = associative_array()
    }

    @methods['deleteQuestCash'] = closure(array @self, string @quest) {
        foreach(@player in array_keys(@self['cash'])) {
            _private_method(@self, 'deleteCash', @quest, @player)
        }
    }

    export('org.cadabra.msquest.pprogress', @methods)
})