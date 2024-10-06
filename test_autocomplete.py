import unittest

from autocomplete import module_autocomplete


class TestValidPaths(unittest.TestCase):
    def test_empty(self):
        generated = module_autocomplete("")
        expected = {"testapp.", "autocomplete", "completions.", "test_autocomplete"}
        self.assertEqual(generated, expected)

    def test_relative_module(self):
        generated = module_autocomplete(".auto")
        expected = set()
        self.assertEqual(generated, expected)

    def test_hidden_module1(self):
        generated = module_autocomplete(".testapp")
        expected = set()
        self.assertEqual(generated, expected)

    def test_hidden_module2(self):
        generated = module_autocomplete(".testapp_hidden.")
        expected = set()
        self.assertEqual(generated, expected)

    def test_folder(self):
        generated = module_autocomplete("testapp.")
        expected = {
            "testapp.__dunder.",
            "testapp.dotfile.",
            "testapp.lol\\ lol.",
            "testapp.samename",
            "testapp.samename.",
            "testapp.__pycache__",
        }
        self.assertEqual(generated, expected)

    def test_subfolder1(self):
        generated = module_autocomplete("testapp.__dunder.")
        expected = {"testapp.__dunder.dunder"}
        self.assertEqual(generated, expected)

    def test_subfolder2(self):
        generated = module_autocomplete("testapp.dotfile.")
        expected = {"testapp.dotfile.bnuuy"}
        self.assertEqual(generated, expected)

    def test_subfolder3(self):
        generated = module_autocomplete("testapp.lol lol.")
        expected = {"testapp.lol\\ lol.lol\\ lol"}
        self.assertEqual(generated, expected)

    def test_subfolder4(self):
        generated = module_autocomplete("testapp.samename.")
        expected = set()
        self.assertEqual(generated, expected)

    def test_nonexistent(self):
        generated = module_autocomplete("testapp.hehe")
        expected = set()
        self.assertEqual(generated, expected)
