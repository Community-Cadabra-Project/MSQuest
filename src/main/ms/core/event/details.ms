execute(closure() {
    @methods = array()
    
    // @methods['GAME_TIME'] = closure(array @o, array @info_event) {
    //     return(@info_event['game']['region'] == @o['region'])
    // }
    @methods['WORLD'] = closure(array @o, array @info_event) {
        return(@info_event['game']['world'] == @o['world'])
    }
    @methods['BIOME'] = closure(array @o, array @info_event) {
        return(@info_event['game']['biome'] == @o['biome'])
    }
    @methods['GAME_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['game']['time'] >= @o['from'] && @info_event['game']['time'] <= @o['to'])
    }
    @methods['YEAR_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['time']['year'] >= @o['from'] && @info_event['time']['year'] <= @o['to'])
    }
    @methods['MONTH_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['time']['month'] >= @o['from'] && @info_event['time']['month'] <= @o['to'])
    }
    @methods['WEEK_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['time']['week'] >= @o['from'] && @info_event['time']['week'] <= @o['to'])
    }
    @methods['DAY_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['time']['day'] >= @o['from'] && @info_event['time']['day'] <= @o['to'])
    }
    @methods['HOUR_TIME'] = closure(array @o, array @info_event) {
        return(@info_event['time']['hour'] >= @o['from'] && @info_event['time']['hour'] <= @o['to'])
    }
    export('org.cadabra.msquest.details', @methods)
})

proc _world(string @world) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'WORLD'
    @o['priority'] = 1
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['world'] = @world
    return(@o)
}

proc _biome(string @biome) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'BIOME'
    @o['priority'] = 2
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['biome'] = @biome
    return(@o)
}

proc _game_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'GAME_TIME'
    @o['priority'] = 4
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _year_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'YEAR_TIME'
    @o['priority'] = 5
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _month_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'MONTH_TIME'
    @o['priority'] = 6
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _day_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'DAY_TIME'
    @o['priority'] = 7
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _week_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'WEEK_TIME'
    @o['priority'] = 8
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}

proc _hour_time(int @from, int @to) {
    @o = associative_array()
    @o['class'] = 'DetailEvent'
    @o['type'] = 'HOUR_TIME'
    @o['priority'] = 9
    @o['test'] = import('org.cadabra.msquest.details')[@o['type']]

    @o['from'] = @from
    @o['to'] = @to
    return(@o)
}