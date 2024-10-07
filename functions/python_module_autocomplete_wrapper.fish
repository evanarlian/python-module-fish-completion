function python_module_autocomplete_wrapper -d "Fish wrapper for python module generation"
    set -l tokens (commandline -ct)
    python_module_autocomplete $tokens
end
