# Pull in fish's upstream python completions so we don't shadow them, then
# stack our local-module completion on top of the existing -m completion.
# __fish_python_no_arg (defined upstream) is true while python is still
# accepting flags, false once a script / -c code / -m module has been given;
# this is what suppresses the false positive on `python -m foo -m <TAB>`.
test -f $__fish_data_dir/completions/python.fish; and source $__fish_data_dir/completions/python.fish

complete -c python -n __fish_python_no_arg -s m -f -d 'Local module' -xa '(_python_module_autocomplete (commandline -ct))'
