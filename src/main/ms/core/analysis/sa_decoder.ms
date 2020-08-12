array proc _sa_decoder(array @paths, @cslice) {
    array @exceptions = array()
    array @entries = array()
    foreach(@path in @paths) {
        @id = @path[@cslice]
        try {
            @entries[] = array(object: yml_decode(read(@path)), id: @id)
        } catch(FormatException @e) {
            @exceptions[] = array(
                'classType': @e['classType'],
                'message': "At file @path",
                'stackTrace': array()
        )
        } catch(IOException @e) {
            @exceptions[] = @e
        }
    }
    return(array(entries: @entries, exceptions: @exceptions))
}

string proc _sa_decoder_parse_exceptions(array @exceptions) {
    Resource @builder = res_create_resource('STRING_BUILDER')
    string_append(@builder, '\n############ DECODER ############\n\n')
    foreach(@e in @exceptions) {
        string_append(@builder, '- ')
        string_append(@builder, _util_parse_exception(@e))
        string_append(@builder, '\n\n')
    }
    return(string(@builder))
}   