execute(closure() {
    @setting = _get_setting()
    foreach(@path in @setting['paths']['data']) {
        _util_make_folder(@path, _util_sdn(), _util_ign())
    }

    @root = @setting['root']

    proc _init_paths(string @id, string @path, array @model) {
        if (is_file(@path)) {
            return()
        }
        @files = list_files(@path)
        foreach(@file in @files) {
            @full_path = @path._util_sdn().@file
            @key = if (@id, "@id.@file", @file)
            @model[@key] = @full_path
            _init_paths(@key, @full_path, @model)
        }
    }

    @model = array()
    _init_paths('', @root, @model)
    export('org.cadabra.msquest.resource', @model)
})

string proc _get_data(string @path) {
    @path = if (@path, "data.@path", "data")
    @model = import('org.cadabra.msquest.resource')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resource: @path")
    }
    return(@model[@path])
}

string proc _get_resource(string @path) {
    @path = if (@path, "src.main.resource.@path", "src.main.resource")
    @model = import('org.cadabra.msquest.resource')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resource: @path")
    }
    return(@model[@path])
}

string proc _get_path(string @path) {
    @path = if (@path, @path, '')
    @model = import('org.cadabra.msquest.resource')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resource: @path")
    }
    return(@model[@path])
}

string proc _get_src(string @path) {
    @path = if (@path, "src.main.ms.@path", "src.main.ms")
    @model = import('org.cadabra.msquest.resource')
    if (!array_index_exists(@model, @path)) {
        throw(IllegalArgumentException, "Unknown resource: @path")
    }
    return(@model[@path])
}