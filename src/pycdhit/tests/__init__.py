# noqa: D104

from . import (
    test_cluster,
    test_doctest,
)


def load_tests(loader, suite, pattern):
    suite.addTests(loader.loadTestsFromModule(test_cluster))
    suite.addTests(loader.loadTestsFromModule(test_doctest))
    return suite
