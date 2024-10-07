# python-module-fish-completion
`python -m` fish completion.

# usage
Install with fisher. Supports only `python` command, while `python3` and `python2` are not covered.
```bash
fisher install evanarlian/python-module-fish-completion
```

This extension will add local modules as extra choices.
```bash
$ python -m te<TAB>
# it will show:
telnetlib                (Run library module as a script (terminates option list))
tempfile                 (Run library module as a script (terminates option list))
tensorboard              (Run library module as a script (terminates option list))
tensorboard_data_server  (Run library module as a script (terminates option list))
tensorboard_plugin_wit   (Run library module as a script (terminates option list))
termios                  (Run library module as a script (terminates option list))
test                     (Run library module as a script (terminates option list))
testapp.                                                            (Local module)
test_autocomplete                                                   (Local module)
textwrap                 (Run library module as a script (terminates option list))
```

Features:
* Supports nested modules, works similar to standard path completions. Just tab and enter.
* Ignores hidden files and folders.
* Handles modules with spaces, automatically escapes and de-escapes to and from fish string.
* Detects runnable folders as modules, while ignoring plain folders.
* Skips commonly ignored folders such as `__pycache__/`, but does not ignore file named `__pycache__.py`, as that can still be a valid module.
* Fast, only about 30ms per invocation (tab).
```bash
$ python -m testapp.<TAB>
# it will show:
testapp.dotfile.     (Local module)
testapp.lol lol.     (Local module)
testapp.samename     (Local module)
testapp.samename.    (Local module)
testapp.__dunder.    (Local module)
testapp.__pycache__  (Local module)
```

# development
The autocompleter is actually written in python, not fish. Fish is only used to run the python script.

Run tests.
```bash
python -m unittest test_autocomplete.py
```
