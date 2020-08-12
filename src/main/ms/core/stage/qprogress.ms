array proc _qprogress_default(array @template_progress) {
    array @o = associative_array()
    @o['quest'] = @template_progress['id']
    @o['data'] = if(array_index_exists(@template_progress, 'global'), @template_progress['global'], array())
    return(@o)
}