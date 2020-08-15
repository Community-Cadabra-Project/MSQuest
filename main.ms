proc _quest_init_module(array @setting = array(msunit: false)) {
    include('setting.ms')
    include('src/main/ms/main.ms')

    if (@setting['msunit'] && is_proc('_unit_register_module')) {
        _unit_register_module(associative_array(
            id: 'msquest',
            root: _get_path('src.test'),
            tests: 'ms',
            groups: 'setting.properties',
            filter: '-ign'
        ))
    }
}