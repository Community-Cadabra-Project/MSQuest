array proc _bind_import() {
    return(import('org.cadabra.msquest.bind-test'))
}
proc _bind_export(array @model) {
    export('org.cadabra.msquest.bind-test', @model)
}
