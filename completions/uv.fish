complete -c uv -n "__fish_uv_using_subcommand run" -s m -f -d 'Run library module as a script (terminates option list)' -xa '(uv run python -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'
complete -c uv -n "__fish_uv_using_subcommand run" -s m -f -d 'Local module' -xa '(_uv_python_module_autocomplete_wrapper)'
