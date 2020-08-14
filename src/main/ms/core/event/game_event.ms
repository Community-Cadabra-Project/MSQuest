array proc _init_game_event(array @params) {
    array @event = associative_array()
    @event['type'] = @params['type']
    @event['id'] = @params['id']

    array @info = associative_array()
    @info['game'] = associative_array()
    @info['time'] = associative_array()
    
    @info['game']['world'] = @params['world']
    @info['game']['biome'] = @params['biome']
    @info['game']['time'] = get_world_time(@params['world'])
    // @info['time']['year'] = integer(simple_date('yyyy'))
    // @info['time']['month'] = integer(simple_date('MM.dd'))
    // @info['time']['day'] = integer(simple_date('dd'))
    // @info['time']['hour'] = integer(simple_date('HH'))
    // @day = null
    // switch(simple_date('EEEE', time(), 'CET', 'en')) {
    //     case 'Monday':
    //         @day = 1
    //         break();
    //     case 'Tuesday':
    //         @day = 2
    //         break();
    //     case 'Wednesday':
    //         @day = 3
    //         break();
    //     case 'Thursday':
    //         @day = 4
    //         break();
    //     case 'Friday':
    //         @day = 5
    //         break();
    //     case 'Saturday':
    //         @day = 6
    //         break();
    //     case 'Sunday':
    //         @day = 7
    //         break();
    // }
    // @info['time']['week'] = @day

    @event['info'] = @info
    return(@event)
}