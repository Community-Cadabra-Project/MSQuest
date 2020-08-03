execute(closure() {

    proc _to_absolute_path(array @array) {
        foreach(@k: @v in @array) {
            if (is_array(@v) && is_associative(@v)) {
                _to_absolute_path(@v)
            } else {
                @array[@k] = get_absolute_path(@v)
            }
        }
    }

    @setting = yml_decode(read('setting.yml'))
    _to_absolute_path(@setting['paths'])
    @root = get_absolute_path()
    @setting['root'] = @root
    export('org.cadabra.msquest.setting', @setting)
})

array proc _get_setting() {
    return(import('org.cadabra.msquest.setting'))
}