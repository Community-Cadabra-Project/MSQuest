array proc _iof_init(string @root, string @path_del = '\\') {
    array @self = associative_array()
    _util_make_folder(@root, '\\', 3)
    @self['class'] = 'IOFile'
    @self['root'] = @root
    @self['del'] = @path_del
    _iof_include_methods(@self)
    return(@self)
}

void proc _iof_include_methods(array @self) {
    foreach(@key: @method in import('org.cadabra.msquest.iof')) {
        @self[@key] = @method
    }
}

execute(closure() {
    @methods = associative_array()
    @methods['read'] = closure(array @self, string @path) {
        return(read(@self['root'].@self['del'].@path))
    }
    
    @methods['write'] = closure(array @self, string @s, string @path) {
        write_file(@self['root'].@self['del'].@path, @s, 'OVERWRITE')
    }
    
    @methods['writeYML'] = closure(array @self, array @o, string @path) {
        @s = yml_encode(_util_delete_closures(@o))
        write_file(@self['root'].@self['del'].@path, @s, 'OVERWRITE')
    }

    @methods['createDir'] = closure(array @self, string @dir) {
        create_dir(@self['root'].@self['del'].@dir)
    }
    
    @methods['readYML'] = closure(array @self, string @path) {
        return(yml_decode(_method(@self, 'read', @path)))
    }
    
    @methods['to'] = closure(array @self, string @path) {
        return(_iof_init(@self['root'].@self['del'].@path, @self['del']))
    }
    
    @methods['list'] = closure(array @self) {
        return(list_files(@self['root']))
    }
    
    @methods['has'] = closure(array @self, string @path) {
        return(file_exists(@self['root'].@self['del'].@path))
    }

    @methods['delete'] = closure(array @self, string @path) {
        delete_file(@self['root'].@self['del'].@path)
    }

    export('org.cadabra.msquest.iof', @methods)
})