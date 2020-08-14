array proc _pprogress_init(array @template_progress, array @player_data) {
    array @o = associative_array()
    @o['class'] = 'PlayerStage'
    @o['quest'] = @template_progress['id']
    @o['last_time'] = @player_data['last_time']
    @o['player'] = @player_data['player']
    @branches = associative_array()
    try {
        foreach(@key: @branch_data in @template_progress['branches']) {
            @branches[@key] = _branch_init(@branch_data, @player_data['branches'][@key], @player_data['time'][@key])
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

array proc _pprogress_default_data(string @player, array @template_progress) {
    array @pprogress = associative_array()
    @pprogress['player'] = @player
    @pprogress['last_time'] = 0
    @pprogress['quest'] = @template_progress['id']
    array @time = associative_array()
    array @branches = associative_array()
    @pprogress['branches'] = @branches
    @pprogress['time'] = @time
    foreach(@key: @branch_data in @template_progress['branches']) {
        @branches[@key] = _branch_default_current(@branch_data['type'])
        @time[@key] = 0
    }
    return(@pprogress)
}

execute(closure() {

    array @pmethods = associative_array()

    @pmethods['getBranch'] = closure(array @self, string @branch) {
        try {
            return(@self['branches'][@branch])
        } catch (NotFoundException @e) {
            throw(Exception, 'This branch was not found: '.@branch, @e)
        }
    }

    array @methods = associative_array(__private_methods__: @pmethods)

    @methods['getTime'] = closure(array @self, string @name_branch) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        return(_method(@branch, 'getTime'))
    }

    @methods['isStage'] = closure(array @self, string @name_branch, mixed @stages) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        return(_method(@branch, 'isStage', @stages))
    }

    @methods['toNext'] = closure(array @self, string @name_branch) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        _method(@branch, 'toNext')
    }

    @methods['toPrev'] = closure(array @self, string @name_branch) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        _method(@branch, 'toPrev')
    }

    @methods['set'] = closure(array @self, string @name_branch, string @stage) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        _method(@branch, 'set', @stage)
    }

    @methods['get'] = closure(array @self, string @name_branch) {
        @branch = _private_method(@self, 'getBranch', @name_branch)
        return(_method(@branch, 'get'))
    }

    @methods['getData'] = closure(array @self) {
        @player_progress = associative_array(branches: associative_array())
        @times = associative_array()
        foreach(@key: @branch in @self['branches']) {
            @player_progress['branches'][@key] = _method(@branch, 'getCurrent')
            @times[@key] = _method(@branch, 'getTime')
        }
        @player_progress['time'] = @times
        @player_progress['player'] = _method(@self, 'getPlayer')
        @player_progress['quest'] = _method(@self, 'getQuest')
        @player_progress['last_time'] = _method(@self, 'getLastTime', false)
        return(@player_progress)
    }
    @methods['getQuest'] = closure(array @self) {
        return(@self['quest'])
    }
    @methods['getPlayer'] = closure(array @self) {
        return(@self['player'])
    }

    @methods['getLastTime'] = closure(array @self, boolean @reset) {
        @last_time = @self['last_time']
        if (@reset) {
            @self['last_time'] = time()
        }
        return(@last_time)
    }

    export('org.cadabra.msquest.progress', @methods)
})