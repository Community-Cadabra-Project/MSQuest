array proc _pprogress_repo_init(string @path) {
    array @o = associative_array()
    @o['class'] = 'PlayersProgress'
    @o['cache'] = associative_array()
    @o['io'] = _iof_init(@path)
    foreach(@key: @method in import('org.cadabra.msquest.pprogress')) {
        @o[@key] = @method
    }
    return(@o)
}


execute(closure() {

    # private methods

    @pmethods = associative_array()

    @pmethods['addCache'] = closure(array @self, array @data) {
        if (!array_index_exists(@self['cache'], @data['player'])) {
            @self['cache'][@data['player']] = associative_array()
        }
        @self['cache'][@data['player']][@data['quest']] = @data
    }

    @pmethods['getCache'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['cache'], @player) && array_index_exists(@self['cache'][@player], @quest)) {
            return(@self['cache'][@player][@quest])
        }
        return(null)
    }

    @pmethods['deleteCache'] = closure(array @self, string @quest, string @player) {
        if (array_index_exists(@self['cache'], @player) && array_index_exists(@self['cache'][@player], @quest)) {
            @self['cache'][@player][@quest] = null
        }
    }

    @methods = associative_array(__private_methods__: @pmethods)

    @methods['get'] = closure(array @self, string @quest, string @player) {
        @cache = _private_method(@self, 'getCache', @quest, @player)
        if (@cache) {
            return(@cache)
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
        _private_method(@self, 'addCache', @player_progress)
        return(@player_progress)
    }

    @methods['save'] = closure(array @self, array @player_progress) {
        _private_method(@self, 'addCache', @player_progress)
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
        _private_method(@self, 'deleteCache', @quest, @player)
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
        _method(@self, 'deletePlayerCache', @player)
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
        _method(@self, 'deleteQuestCache', @quest)
        _log('INFO', "Delete the all players progress for quest - '@quest'. Status: @status")
        return(@status)
    }

    @methods['deletePlayerCache'] = closure(array @self, string @player) {
        @self['cache'][@player] = associative_array()
    }

    @methods['deleteQuestCache'] = closure(array @self, string @quest) {
        foreach(@player in array_keys(@self['cache'])) {
            _private_method(@self, 'deleteCache', @quest, @player)
        }
    }

    export('org.cadabra.msquest.pprogress', @methods)
})