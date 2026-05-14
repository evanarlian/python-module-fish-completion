# Pull in upstream uv completions (which just runs `uv --generate-shell-completion fish | source`)
# then add module completions for `uv run -m`. _python_module_uv_run_no_module suppresses
# false positives on a second -m, mirroring __fish_python_no_arg's role for python.
source $__fish_data_dir/completions/uv.fish

complete -c uv -n "__fish_uv_using_subcommand run; and _python_module_uv_run_no_module" -s m -f -d 'Run library module as a script (terminates option list)' -xa '(uv run --no-sync python -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'
complete -c uv -n "__fish_uv_using_subcommand run; and _python_module_uv_run_no_module" -s m -f -d 'Local module' -xa '(_python_module_autocomplete (commandline -ct))'
