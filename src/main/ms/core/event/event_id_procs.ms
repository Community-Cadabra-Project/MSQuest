proc _entity_event_get_id(string @id, string @action) {
    return("ENTITY$@id|@action")
}

proc _quest_event_get_id(string @action) {
    return("QUEST$@action")
}

proc _group_event_get_id(string @group, string @action) {
    return("GROUP$@group|@action")
}

proc _custom_event_get_id(string @id) {
    return("CUSTOM$@id")
}