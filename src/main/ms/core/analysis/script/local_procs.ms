proc _bind_events() {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    @context['used_bind'] += 1
    if (array_size(@arguments) == 0) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': 'No argument passed',
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    foreach(@o in @arguments) {
        if (!is_associative(@o) || @o['class'] != 'Event' && @o['class'] != 'DetailEvent') {
            @context['exceptions'][] = array(
                'classType': IllegalArgumentException,
                'message': 'The passed argument is not an object of class: Event, DetailEvent',
                'stackTrace': get_stack_trace()[1..1]
            )
        }
    }
}

proc _bind_dialog(string @dialog) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@context['used_dialog']) {
        @context['exceptions'][] = array(
            'classType': Exception,
            'message': 'Reusing _bind_dialog(string dialog)',
            'stackTrace': get_stack_trace()[1..1]
        )
    } else {
        @context['used_dialog'] = true
    }
    if (!array_contains(@context['dialogs'], @dialog)) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': "Unknown dialog - @dialog",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
}

proc _bind_import() {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    @context['exceptions'][] = array(
        'classType': UnsupportedOperationException,
        'message': 'Illegal use _bind_import()',
        'stackTrace': get_stack_trace()[1..1]
    )
}

array proc _entity_event(string @entity, string @action, string @quest = null) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (!array_contains(@context['entities'], @entity)) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': "Unknown entity - @entity",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@quest != null && !array_contains(@context['quests'], @quest)) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': "Unknown quest - @quest",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeEvent'])
}

array proc _quest_event(string @action, string @quest = null) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@quest != null && !array_contains(@context['quests'], @quest)) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': "Unknown quest - @quest",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeEvent'])
}

array proc _world(string @world) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    try {
        world_info(@world)
    } catch(Exception @e) {
        @context['exceptions'][] = array(
                    'classType': @e['classType'],
                    'message': @e['message'],
                    'stackTrace': @e['stackTrace'][1..1]
                )
    } finally {
        return(@context['fakeDetail'])
    }
}

array proc _biome(string @biome) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (!array_contains(@context['bioms'], to_lower(@biome))) {
        @context['exceptions'][] = array(
            'classType': IllegalArgumentException,
            'message': "Unknown biom - @biome",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _game_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0 || @from > 24) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Game time must be in [0, 24], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0 || @to > 24) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Game time must be in [0, 24], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _year_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Year time must be in [0, +infinity], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Year time must be in [0, +infinity], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _month_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0 || @from > 12) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Month time must be in [0, 12], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0 || @to > 12) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Month time must be in [0, 12], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _day_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0 || @from > 31) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Day time must be in [0, 31], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0 || @to > 31) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Day time must be in [0, 31], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _week_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0 || @from > 7) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Week time must be in [0, 7], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0 || @to > 7) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Week time must be in [0, 7], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}

array proc _hour_time(int @from, int @to) {
    @context = import(x_get_current_thread().' - '.'org.cadabra.msquest.script_checker.local_procs')
    if (@from < 0 || @from > 24) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Hour time must be in [0, 24], but 'from' is @from",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@to < 0 || @to > 24) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "Hour time must be in [0, 24], but 'to' is @to",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    if (@from > @to) {
        @context['exceptions'][] = array(
            'classType': RangeException,
            'message': "'from' more that 'to'",
            'stackTrace': get_stack_trace()[1..1]
        )
    }
    return(@context['fakeDetail'])
}
