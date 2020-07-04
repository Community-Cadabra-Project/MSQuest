execute(closure() {
    proc _load_paths(@paths) {
        @absolute_paths = array()
        foreach(@key: @val in @paths) {
            if (is_array(@val)) {
                @absolute_paths[@key] = _load_paths(@val)
            } else {
                @absolute_paths[@key] = get_absolute_path(@val)
            }
        }
        return(@absolute_paths)
    }

    @path_to_setting = 'setting.yml'

    if (!file_exists(@path_to_setting)) {
        @msg = "MSQuest: [FATAL] file '@path_to_setting' of setting doesn't exists."
        _util_error(@msg)
    }
    @setting = yml_decode(read(@path_to_setting))

    @KEY_PATH = 'paths'
    @setting[@KEY_PATH] = _load_paths(@setting[@KEY_PATH])

    export('org.cadabra.msquest.setting', @setting)
})

array proc _get_setting() {
    return(import('org.cadabra.msquest.setting'))
}