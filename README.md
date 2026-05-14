# python-module-fish-completion
`{python,python3,uv run} -m` fish completion.

# usage
Install with fisher. Supports `python`, `python3`, and `uv run`.
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
* Supports `uv run -m`.
* Supports nested modules, works similar to standard path completions. Just tab and enter.
* Supports dashed folder.
* Ignores hidden files and folders. Hidden folders are treated as relative module.
* Handles modules with spaces, automatically escapes and de-escapes to and from fish string.
* Detects runnable folders as modules, while ignoring plain folders.
* Skips commonly ignored folders such as `__pycache__/`, but does not ignore file named `__pycache__.py`, as that can still be a valid module.
* Suppresses the second-`-m` false positive: `python -m myapp -m <TAB>` does not offer local-module completions (the second `-m` is an argument to `myapp`, not a python flag). Same for `uv run -m`.
* Fast. Pure fish, no subprocess.

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
