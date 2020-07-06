execute(closure() {
    @setting = array()
    @path = get_absolute_path()
    @setting['path'] = @path
    export('org.cadabra.msquest.setting', @setting)
})

array proc _get_setting() {
    return(import('org.cadabra.msquest.setting'))
}