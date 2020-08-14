void proc _consume() {
    @api_model = import('org.cadabra.msquest.api')
    @api_model['bind']['consume'] = true
}

void proc _cancel() {
    @api_model = import('org.cadabra.msquest.api')
    @api_model['bind']['cancel'] = true
}

boolean proc _is_consumed() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['bind']['consume'])
}

boolean proc _is_cancelled() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['bind']['cancel'])
}

array proc _get_event_meta() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['bind']['event_meta'])
}

array proc _get_event() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['current']['event'])
}

array proc _get_action() {
    @api_model = import('org.cadabra.msquest.api')
    return(@api_model['current']['action'])
}