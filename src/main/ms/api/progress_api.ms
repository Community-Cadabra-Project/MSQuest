int proc _time_stage(string @branch) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    return(time() - _method(@progress, 'getTime', @branch))
}

int proc _last_time(boolean @reset = false) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    @last_time = _method(@progress, 'getLastTime', @reset)
    if (@reset) {
        @model = @api_model['main_model']
        _method(@model, 'savePProgress', @progress)
    }
    return(time() - @last_time)
}

void proc _set_stage(string @branch, string @stage) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    _method(@progress, 'set', @branch, @stage)
    @model = @api_model['main_model']
    _method(@model, 'savePProgress', @progress)
}

void proc _to_next_stage(string @branch) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    _method(@progress, 'toNext', @branch)
    @model = @api_model['main_model']
    _method(@model, 'savePProgress', @progress)
}

void proc _to_prev_stage(string @branch) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    _method(@progress, 'toPrev', @branch)
    @model = @api_model['main_model']
    _method(@model, 'savePProgress', @progress)
}

mixed proc _get_stage(string @branch) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    return(_method(@progress, 'get', @branch))
}

boolean proc _is_stage(string @branch, mixed @stage) {
    @api_model = import('org.cadabra.msquest.api')
    @progress = @api_model['current']['progress']
    if (!@progress) {
        throw(NotFoundException, 'Progress not found')
    }
    return(_method(@progress, 'isStage', @branch, @stage))
}

mixed proc _get_quest_progress(string @quest = null, boolean @touched = true) {
    @api_model = import('org.cadabra.msquest.api')
    if (@quest == null) {
        @quest = @api_model['current']['quest']
    }
    if (!@quest) {
        throw(NotFoundException, 'Progress not found')
    }
    @qp = _method(@api_model['main_model'], 'getQProgress', @quest)
    if (@touched) {
        @api_model['user']['touched_quests'][] = @qp
    }
    return(@qp['data'])
}

void proc _switch_progress(string @quest, string @player) {
    @api_model = import('org.cadabra.msquest.api')
    @model = @api_model['main_model']
    @api_model['current']['progress'] = _method(@model, 'getPProgress', @quest, @player) 
    @api_model['current']['player'] = @player
    @api_model['current']['quest'] = @quest
}