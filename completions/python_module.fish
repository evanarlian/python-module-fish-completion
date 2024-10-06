# complete -c python3 -s B -d 'Don\'t write .py[co] files on import'
# complete -c python3 -s c -x -d "Execute argument as command"
# complete -c python3 -s d -d "Debug on"
# complete -c python3 -s E -d "Ignore environment variables"
# complete -c python3 -s h -s '?' -l help -d "Display help and exit"
# complete -c python3 -s i -d "Interactive mode after executing commands"
# complete -c python3 -s O -d "Enable optimizations"
# complete -c python3 -o OO -d "Remove doc-strings in addition to the -O optimizations"
# complete -c python3 -s s -d 'Don\'t add user site directory to sys.path'
# complete -c python3 -s S -d "Disable import of site module"
# complete -c python3 -s u -d "Unbuffered input and output"
# complete -c python3 -s v -d "Verbose mode"
# complete -c python3 -s V -l version -d "Display version and exit"
# complete -c python3 -s W -x -d "Warning control" -a "ignore default all module once error"
# complete -c python3 -s x -d 'Skip first line of source, allowing use of non-Unix forms of #!cmd'
# complete -c python3 -n "__fish_is_nth_token 1" -k -fa "(__fish_complete_suffix .py)"
# complete -c python3 -f -n "__fish_is_nth_token 1" -a - -d 'Read program from stdin'
# complete -c python3 -s q -d 'Don\'t print version and copyright messages on interactive startup'
# complete -c python3 -s X -x -d 'Set implementation-specific option' -a 'faulthandler showrefcount tracemalloc showalloccount importtime dev utf8 pycache_prefex=PATH:'
# complete -c python3 -s b -d 'Issue warnings for possible misuse of `bytes` with `str`'
# complete -c python3 -o bb -d 'Issue errors for possible misuse of `bytes` with `str`'
# complete -c python3 -l check-hash-based-pycs -d 'Set pyc hash check mode' -xa "default always never"
# complete -c python3 -s I -d 'Run in isolated mode'




# complete -c python3 -s m -d 'Run library module as a script (terminates option list)' -xa '(python3 -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'
# -t --current-token
# -c --cut-at-cursor

function __python_module_autocomplete -d "Generate autocompletions for python modules in pwd"
    set -l target_path $argv[1]
    set -l autocompleter '
from pathlib import Path


def module_autocomplete(module_path: str) -> set[str]:
    if module_path.startswith("."):
        # python does not support relative module name using python -m
        return set()
    if module_path.endswith("."):
        # "app.core." can be autocompleted to "app.core.engine"
        cwd = Path(module_path.replace(".", "/"))
        tail = None
    else:
        # "app.core" can be autocompleted to "app.coreboot"
        try:
            module_path, tail = f"{module_path}".rsplit(".", maxsplit=1)
        except ValueError:
            module_path, tail = "", module_path
        cwd = Path(module_path)

    # generate valid path that might be able to be run using python -m
    # some python -m behavior:
    # * does not support relative module invocation, e.g. python -m .meme
    # * if the same filename and folder found, this is the precedence of execution
    #   * package, e.g. app/check/ (must have __init__.py and __main__.py)
    #   * file module, e.g. app/check.py
    #   * folder module, e.g. app/check/ (must have only __main__.py)
    # * note that __init__.py is only needed to mark a folder as package, but python will still run the __main__.py
    valid_paths: set[str] = set()
    for path in Path(cwd).iterdir():
        if path.name.startswith("."):
            continue
        if path.is_dir() and path.name == "__pycache__":
            continue
        if path.is_file() and path.name in {"__main__.py", "__init__.py"}:
            continue
        if not (path.is_dir() or path.suffix == ".py"):
            continue
        if tail is not None and not path.name.startswith(tail):
            continue
        if path.is_dir():
            cleaned = str(path).replace("/", ".").replace(" ", "\ ") + "."
        else:
            assert path.suffix == ".py"
            cleaned = str(path).replace("/", ".").replace(" ", "\ ")[:-3]
        valid_paths.add(cleaned)
    return valid_paths


def main():
    paths = module_autocomplete('"\"$target_path\""')
    for path in sorted(paths):
        print(path)


if __name__ == "__main__":
    main()
    '
    python -c "$autocompleter"
end

function __python_module_autocomplete_wrapper -d "Custom shit"
    set -l tokens (commandline -ct)
    __python_module_autocomplete $tokens
end

# complete -c python -s m -f -d 'my custom injector' -xa '(python3 -c "print(3342)")'
complete -c python -s m -f -d 'my custom injector' -xa '(__python_module_autocomplete_wrapper)'
complete -c python3 -s m -f -d 'my custom injector' -xa '(__python_module_autocomplete_wrapper)'




# set -l __commands merge list delete use shell help
# set -l __shells fish

# complete -c dockvault -n "not __fish_seen_subcommand_from $__commands" -a "$__commands"
# complete -c dockvault -n "__fish_seen_subcommand_from shell" -n "not __fish_seen_subcommand_from $__shells" -a "$__shells"
# complete -c dockvault -n "__fish_seen_subcommand_from use" -n "not __fish_seen_subcommand_from (dockvault completion)" -a "(dockvault completion)"

# set -e __commands
# set -e __shells
