import unittest

from autocomplete import module_autocomplete


class TestValidPaths(unittest.TestCase):
    def test_empty(self):
        generated = module_autocomplete("")
        expected = ["testapp.", "autocomplete", "test_autocomplete"]
        self.assertEqual(generated, expected)

    def test_relative_module(self):
        generated = module_autocomplete(".auto")
        expected = []
        self.assertEqual(generated, expected)

    def test_hidden_module1(self):
        generated = module_autocomplete(".testapp")
        expected = []
        self.assertEqual(generated, expected)

    def test_hidden_module2(self):
        generated = module_autocomplete(".testapp_hidden.")
        expected = []
        self.assertEqual(generated, expected)

    def test_folder(self):
        generated = module_autocomplete("testapp.")
        expected = [
            "testapp.__dunder.",
            "testapp.dotfile.",
            "testapp.lol\\ lol.",
            "testapp.samename.",  # TODO sus
        ]
        self.assertEqual(generated, expected)

    # TODO more tests for each subfolders
