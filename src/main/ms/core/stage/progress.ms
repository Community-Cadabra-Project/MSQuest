array proc _progress_init(array @template_progress, array @qprogress, array @pprogress) {
    array @o = associative_array()
    @o['class'] = 'PlayerStage'
    @o['quest'] = @template_progress['id']
    @o['player'] = @pprogress['player']
    @o['qprogress'] = @qprogress
    @branches = associative_array()
    try {
        foreach(@key: @branch_data in @template_progress['branches']) {
            @branches[@key] = _branch_init(@branch_data, @pprogress['branches'][@key])
        }
    } catch (NotFoundException @e) {
        throw(Exception, 'Mismatch of the recorded data with the template', @e)
    }
    @o['branches'] = @branches
    foreach(@key: @method in import('org.cadabra.msquest.progress')) {
        @o[@key] = @method
    }
    return(@o)
}

array proc _pprogress_default(string @player, array @template_progress) {
    array @pprogress = associative_array()
    @pprogress['player'] = @player
    @pprogress['quest'] = @template_progress['id']
    array @branches = associative_array()
    @pprogress['branches'] = @branches
    foreach(@key: @branch_data in @template_progress['branches']) {
        @branches[@key] = _branch_default_current(@branch_data['type'])
    }
    return(@pprogress)
}

array proc _qprogress_default(array @template_progress) {
    array @o = associative_array()
    @o['quest'] = @template_progress['id']
    @o['data'] = if(array_index_exists(@template_progress, 'global'), @template_progress['global'], null)
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
    @methods['getPProgress'] = closure(array @self) {
        @player_progress = associative_array(branches: associative_array())
        foreach(@key: @branch in @self['branches']) {
            @player_progress['branches'][@key] = _method(@branch, 'getCurrent')
        }
        @player_progress['player'] = _method(@self, 'getPlayer')
        @player_progress['quest'] = _method(@self, 'getQuest')
        return(@player_progress)
    }
    @methods['getQProgress'] = closure(array @self) {
        return(@self['qprogress'])
    }
    @methods['getQuest'] = closure(array @self) {
        return(@self['quest'])
    }
    @methods['getPlayer'] = closure(array @self) {
        return(@self['player'])
    }

    export('org.cadabra.msquest.progress', @methods)
})