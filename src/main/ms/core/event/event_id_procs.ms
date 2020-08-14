proc _entity_event_get_id(string @type, string @id, string @action) {
    return("@type$@id|@action")
}

proc _quest_event_get_id(string @type, string @action) {
    return("@type$@action")
}

proc _group_event_get_id(string @type, string @group, string @action) {
    return("@type$@group|@action")
}