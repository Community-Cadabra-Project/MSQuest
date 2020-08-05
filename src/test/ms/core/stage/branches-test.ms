proc _before_each() {
    @path = _unit_resource('stage.stage.yml')
    @temp = yml_decode(read(@path))
    @progress = _progress_init(@temp, _qprogress_default(@temp), _pprogress_default('player', @temp))
    return(@progress)
}

proc _test_getBranch(@progress) {
    @branch = _method(@progress, 'getBranch', 'main')
    _assert_equals(@branch['class'], 'FlagBranch')
}

proc _test_flagBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'main')
    _assert_equals(@br['class'], 'FlagBranch')

    _method(@br, 'set', 'one')
    _assert_equals(array('one'), _method(@br, 'get'))

    _method(@br, 'set', 'three')
    _assert_equals(array('one', 'three'), _method(@br, 'get'))

    _method(@br, 'set', 'two')
    _assert_equals(array('one', 'two', 'three'), _method(@br, 'get'))

    _assert_equals(range(3), _method(@br, 'getCurrent'))

    _method(@br, 'set', 'one')
    _assert_equals(array('two', 'three'), _method(@br, 'get'))

    _method(@br, 'set', 'three')
    _assert_equals(array('two'), _method(@br, 'get'))

    _method(@br, 'set', 'two')
    _assert_equals(array(), _method(@br, 'get'))

    _assert_execute_array_throw(
        NotFoundException,
        @br['set'], array(@br, 'four')
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toNext'], array(@br)
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toPrev'], array(@br)
    )
}

proc _test_linearBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'linear')
    _assert_equals(@br['class'], 'LinearBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('before', _method(@br, 'get'))

    _method(@br, 'toNext')
    _assert_equals('after', _method(@br, 'get'))

    _method(@br, 'toPrev')
    _assert_equals('before', _method(@br, 'get'))

    _assert_proc_array_throw(
        Exception,
        '_method', array(@br, 'toPrev'), @br
    )

    _method(@br, 'toNext')

    _assert_proc_array_throw(
        Exception,
        '_method', array(@br, 'toNext'), @br
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['set'], array(@br)
    )
}

proc _test_cycleBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'cycle')
    _assert_equals(@br['class'], 'CycleBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('before', _method(@br, 'get'))

    _method(@br, 'toNext')
    _assert_equals('after', _method(@br, 'get'))

    _method(@br, 'toPrev')
    _assert_equals('before', _method(@br, 'get'))

    _method(@br, 'toPrev')
    _assert_equals('after', _method(@br, 'get'))

    _method(@br, 'toNext')

    _method(@br, 'toNext')
    _assert_equals('after', _method(@br, 'get'))

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['set'], array(@br)
    )
}

proc _test_orienLinearBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'orien_linear')
    _assert_equals(@br['class'], 'OrienLinearBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('before', _method(@br, 'get'))

    _method(@br, 'toNext')
    _assert_equals('after', _method(@br, 'get'))

    _assert_proc_array_throw(
        Exception,
        '_method', array(@br, 'toNext'), @br
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toPrev'], array(@br)
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['set'], array(@br)
    )
}

proc _test_orienCycleBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'orien_cycle')
    _assert_equals(@br['class'], 'OrienCycleBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('before', _method(@br, 'get'))

    _method(@br, 'toNext')
    _assert_equals('after', _method(@br, 'get'))

    _method(@br, 'toNext')
    _assert_equals('before', _method(@br, 'get'))

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['set'], array(@br)
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toPrev'], array(@br)
    )
}

proc _test_graphBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'graph')
    _assert_equals(@br['class'], 'GraphBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('one', _method(@br, 'get'))

    _method(@br, 'set', 'two')
    _assert_equals('two', _method(@br, 'get'))

    _method(@br, 'set', 'four')
    _assert_equals('four', _method(@br, 'get'))

    _method(@br, 'set', 'five')
    _assert_equals('five', _method(@br, 'get'))

    _assert_execute_array_throw(
        NotFoundException,
        @br['set'], array(@br, 'zero')
    )

    _assert_execute_array_throw(
        IllegalArgumentException,
        @br['set'], array(@br, 'one')
    )

    _assert_execute_array_throw(
        IllegalArgumentException,
        @br['set'], array(@br, 'four')
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toNext'], array(@br)
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toPrev'], array(@br)
    )
}

proc _test_setBranch(@progress) {
    @br = _method(@progress, 'getBranch', 'set')
    _assert_equals(@br['class'], 'SetBranch')
    _assert_equals(0, _method(@br, 'getCurrent'))
    _assert_equals('one', _method(@br, 'get'))

    _method(@br, 'set', 'two')
    _assert_equals('two', _method(@br, 'get'))

    _method(@br, 'set', 'four')
    _assert_equals('four', _method(@br, 'get'))

    _method(@br, 'set', 'three')
    _assert_equals('three', _method(@br, 'get'))

    _assert_execute_array_throw(
        NotFoundException,
        @br['set'], array(@br, 'zero')
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toNext'], array(@br)
    )

    _assert_execute_array_throw(
        UnsupportedOperationException,
        @br['toPrev'], array(@br)
    )
}