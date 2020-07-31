array proc _progress_init(string @player, array @quest_progress, array @player_progress) {
    array @o = associative_array()
    @o['class'] = 'PlayerStage'
    @o['quest'] = @quest_progress['id']
    @o['player'] = @player
    @branches = associative_array()
    if (@player_progress) {
        try {
            foreach(@key: @branch_data in @quest_progress['branches']) {
                @branches[@key] = _branch_init(@branch_data, @player_progress[@key])
            }
        } catch (NotFoundException @e) {
            throw(Exception, 'Mismatch of the recorded data with the template', @e)
        }
    } else {
        foreach(@key: @branch_data in @quest_progress['branches']) {
            @branches[@key] = _branch_init(@branch_data, _branch_default_current(@branch_data['type']))
        }
    }
    @o['branches'] = @branches
    foreach(@key: @method in import('org.cadabra.msquest.progress')) {
        @o[@key] = @method
    }
    return(@o)
}

execute(closure() {
    array @methods = associative_array()
    @methods['getBranch'] = closure(array @self, string @branch) {
        try {
            return(@self['branches'][@branch])
        } catch (NotFoundException @e) {
            throw(Exception, 'This branch was not found: '.@branch, @e)
        }
    }
    @methods['getPlayerProgress'] = closure(array @self) {
        @player_progress = associative_array(branches: associative_array())
        foreach(@key: @branch in @self['branches']) {
            @player_progress['branches'][@key] = _method(@branch, 'getCurrent')
        }
        @player_progress['player'] = _method(@self, 'getPlayer')
        @player_progress['quest'] = _method(@self, 'getQuest')
        return(@player_progress)
    }
    @methods['getQuest'] = closure(array @self) {
        return(@self['quest'])
    }
    @methods['getPlayer'] = closure(array @self) {
        return(@self['player'])
    }

    export('org.cadabra.msquest.progress', @methods)
})