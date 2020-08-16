void proc _api_model_init(array @params) {

    @api_model = associative_array()

    @model = @params['model']
    @event = @params['event']

    @action = if (array_index_exists(@params, 'action'), @params['action'], null)
    @quest = if (array_index_exists(@params, 'quest'), @params['quest'], null)
    @player = if (array_index_exists(@params, 'player'), @params['player'], null)
    @entity = if (array_index_exists(@params, 'entity'), @params['entity'], null)
    @dialog = if (array_index_exists(@params, 'dialog'), @params['dialog'], null)
    @pprogress = if ((@quest && @player), _method(@model, 'getPProgress', @quest, @player), null)

    @current = associative_array()
    @current['event'] = @event
    @current['quest'] = @quest
    @current['action'] = @action
    @current['player'] = @player
    @current['entity'] = @entity
    @current['progress'] = @pprogress
    @current['dialog'] = @dialog
    @api_model['current'] = @current

    @binding = associative_array()
    if (array_index_exists(@params, 'bind')) {
        if (@params['bind']) {
            @binding['cancel'] = is_cancelled()
            @binding['consume'] = false
            @binding['event_meta'] = event_meta()
        } else {
            @binding['cancel'] = false
            @binding['consume'] = false
            @binding['event_meta'] = null
        }
    } else {
        @binding['cancel'] = is_cancelled()
        @binding['consume'] = false
        @binding['event_meta'] = event_meta()
    }
    @api_model['bind'] = @binding

    @user = associative_array()
    @user['touched_quests'] = array()
    @api_model['user'] = @user

    @api_model['main_model'] = @model

    export('org.cadabra.msquest.api', @api_model)
}

proc _after_event() {

    @api_model = import('org.cadabra.msquest.api')

    if (@api_model['bind']['cancel']) {
        cancel()
    }
    if (@api_model['bind']['consume']) {
        consume()
    }

    @model = @api_model['main_model']
    foreach(@quest in @api_model['user']['touched_quests']) {
        if (@quest != null) {
            _method(@model, 'saveQProgress', @quest)
        }
    }
}