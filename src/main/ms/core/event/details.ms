execute(closure() {
    @methods = array()

    @methods['world'] = closure(array @info_event, array @o) {
        return(@info_event['game']['world'] == @o['world'])
    }
    @methods['biome'] = closure(array @info_event, array @o) {
        return(@info_event['game']['biome'] == @o['biome'])
    }
    @methods['region'] = closure(array @info_event, array @o) {
        return(@info_event['game']['region'] == @o['region'])
    }
    @methods['game_time'] = closure(array @info_event, array @o) {
        return(@info_event['game']['time'] >= @o['from'] && @info_event['game']['time'] <= @o['to'])
    }
    @methods['year_time'] = closure(array @info_event, array @o) {
        return(@info_event['time']['year'] >= @o['from'] && @info_event['time']['year'] <= @o['to'])
    }
    @methods['month_time'] = closure(array @info_event, array @o) {
        return(@info_event['time']['month'] >= @o['from'] && @info_event['time']['month'] <= @o['to'])
    }
    @methods['week_time'] = closure(array @info_event, array @o) {
        return(@info_event['time']['week'] >= @o['from'] && @info_event['time']['week'] <= @o['to'])
    }
    @methods['day_time'] = closure(array @info_event, array @o) {
        return(@info_event['time']['day'] >= @o['from'] && @info_event['time']['day'] <= @o['to'])
    }
    @methods['hour_time'] = closure(array @info_event, array @o) {
        return(@info_event['time']['hour'] >= @o['from'] && @info_event['time']['hour'] <= @o['to'])
    }

    export('org.cadabra.msquest.details', @methods)
})

proc _world(string @world) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'WORLD'
    @o['priority'] = 1
    @o['test'] = import('org.cadabra.msquest.details')['world']

    @o['world'] = @world
    return(@o)
}

proc _biome(string @biome) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'BIOME'
    @o['priority'] = 2
    @o['test'] = import('org.cadabra.msquest.details')['biome']

    @o['biome'] = @biome
    return(@o)
}

proc _game_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'GAME_TIME'
    @o['priority'] = 4
    @o['test'] = import('org.cadabra.msquest.details')['game_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _year_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'YEAR_TIME'
    @o['priority'] = 5
    @o['test'] = import('org.cadabra.msquest.details')['year_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _month_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'MONTH_TIME'
    @o['priority'] = 6
    @o['test'] = import('org.cadabra.msquest.details')['month_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _day_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'DAY_TIME'
    @o['priority'] = 7
    @o['test'] = import('org.cadabra.msquest.details')['day_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _week_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'WEEK_TIME'
    @o['priority'] = 8
    @o['test'] = import('org.cadabra.msquest.details')['week_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _hour_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'HOUR_TIME'
    @o['priority'] = 9
    @o['test'] = import('org.cadabra.msquest.details')['hour_time']

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}