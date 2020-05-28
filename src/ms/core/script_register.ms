proc _private_quest_script_analyzer(@procs) {
    @setting = _quest_get_setting()
}

execute(closure() {
    @scripts = import('QUEST_PARAM_SCRIPT')
})

proc _quest_script_check_syntax(string @script) {
    @procs_before = get_procedures()
    include(@script)
    @procs_after = get_procedures()
    _util_arrai_minus(@procs_after, @procs_before)
}

