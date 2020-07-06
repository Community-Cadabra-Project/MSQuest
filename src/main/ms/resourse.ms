execute(closure() {
    @root = _get_setting()['path']

    proc _init_paths(string @id, string @path, array @model) {
        if (is_file(@path)) {
            return()
        }
        @files = list_files(@path)
        foreach(@file in @files) {
            @full_path = @path.'\\'.@file
            @key = if (@id, "@id.@file", @file)
            @model[@key] = @full_path
            _init_paths(@key, @full_path, @model)
        }
    }

    @model = array()
    _init_paths('', @root, @model)
    export('org.cadabra.msquest.resourse', @model)
})

string proc _get_data(string @path) {
    @path = if (@path, "data.@path", "data")
    @model = import('org.cadabra.msquest.resourse')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resourse: @path")
    }
    return(@model[@path])
}

string proc _get_resourse(string @path) {
    @path = if (@path, "src.main.resourse.@path", "src.main.resourse")
    @model = import('org.cadabra.msquest.resourse')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resourse: @path")
    }
    return(@model[@path])
}

string proc _get_path(string @path) {
    @path = if (@path, @path, '')
    @model = import('org.cadabra.msquest.resourse')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resourse: @path")
    }
    return(@model[@path])
}

string proc _get_src(string @path) {
    @path = if (@path, "src.main.ms.@path", "src.main.ms")
    @model = import('org.cadabra.msquest.resourse')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resourse: @path")
    }
    return(@model[@path])
}