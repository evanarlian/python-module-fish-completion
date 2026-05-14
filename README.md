# python-module-fish-completion
`python -m` and `uv run -m` fish completion.

# usage
Install with fisher. Supports only `python` and `uv run` command, while `python3` and `python2` are not covered.
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
textwrap                 (Run library module as a script (terminates option list))
```

Features:
* NEW! Supports `uv run -m`.
* Supports nested modules, works similar to standard path completions. Just tab and enter.
* Supports dashed folder.
* Ignores hidden files and folders.
* Handles modules with spaces, automatically escapes and de-escapes to and from fish string.
* Detects runnable folders as modules, while ignoring plain folders.
* Skips commonly ignored folders such as `__pycache__/`, but does not ignore file named `__pycache__.py`, as that can still be a valid module.
* Fast. Pure fish, no subprocess — well under 1ms per invocation.
```bash
$ python -m testapp.<TAB>
# it will show:
testapp.dash-folder-hehe.  (Local module)
testapp.dotfile.           (Local module)
testapp.lol lol.           (Local module)
testapp.samename           (Local module)
testapp.samename.          (Local module)
testapp.__dunder.          (Local module)
testapp.__pycache__        (Local module)
```

# development
The local-module autocompleter is pure fish (see `functions/_python_module_autocomplete.fish`). The only python that still runs is the one-liner inside `completions/python.fish` and `completions/uv.fish` that asks `pkgutil` to list installed/builtin modules — fish has no way to enumerate site-packages.

Run tests.
```bash
fish test_autocomplete.fish
```

# TODO
* Wait for fish 4.0 rust update and revisit the reference for python autocomplete. This might be [the answer](https://github.com/fish-shell/fish-shell/issues/10943) for second `-m` false positive, e.g. `python -m myapp -m <TAB>`. This should not trigger autocomplete.
