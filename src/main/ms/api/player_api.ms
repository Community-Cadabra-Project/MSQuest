boolean proc _has_player() {
    @api_model = import('org.cadabra.msquest.api')
    return(boolean(@api_model['current']['player']))
}

string proc _get_player() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['current']['player'])
}

proc _say_to_player(string @msg, string @player = null) {
    if (@player == null) {
        @player = _get_player()
    }
    broadcast(@msg, array(@player))
}