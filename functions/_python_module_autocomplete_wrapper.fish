function _python_module_autocomplete_wrapper -d "Fish wrapper for python module generation"
    set -l tokens (commandline -ct)
    _python_module_autocomplete $tokens
end
