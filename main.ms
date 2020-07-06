proc _quest_init_module(array @setting = array(msunit: false)) {
    include('setting.ms')
    include('src/main/ms/main.ms')

    if (@setting['msunit']) {
        _unit_register_module(
            'msquest',
            _get_path('src.test.ms'),
            _get_path('src.test.setting.properties'),
            _unit_get_default_outs(_get_path('src.test.logs'))
        )
    }
}