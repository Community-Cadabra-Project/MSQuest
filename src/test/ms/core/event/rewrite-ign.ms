array proc _bind_import() {
    return(import('org.cadabra.msquest.bind-test'))
}
proc _bind_export(array @model) {
    export('org.cadabra.msquest.bind-test', @model)
}
proc _map_events_export(array @model) {
    export('org.cadabra.msquest.event_map-test', @model)
}
array proc _map_events_import() {
    return(import('org.cadabra.msquest.event_map-test'))
}
