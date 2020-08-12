boolean proc _has_player() {
    @api_model = import('org.cadabra.msquest.api')
    return(boolean(@api_model['current']['player']))
}

string proc _get_player() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['current']['player'])
}