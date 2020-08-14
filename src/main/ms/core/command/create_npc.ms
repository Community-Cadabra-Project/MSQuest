proc _update_npc(array @model) {
    foreach(@id: @entity in @model['npc']) {
        if (@uuid = _method(@model, 'addNPCIfAbsent', @entity)) {
            _log('INFO', "NPC @id - @uuid added")
        }
    }
}

proc _reset_npc(array @model) {
    foreach(@id: @entity in @model['npc']) {
        @uuid = _method(@model, 'setNPC', @entity)
        if (@uuid) {
            _log('INFO', "Set NPC @id - @uuid")
        }
    }
}