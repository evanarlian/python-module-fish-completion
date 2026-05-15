# Same pattern as completions/python.fish — pull in fish's upstream python3
# completions, then stack our local-module completion on top. python3.fish
# defines its own __fish_python_no_arg which we reuse to suppress the
# second-`-m` false positive.
test -f $__fish_data_dir/completions/python3.fish; and source $__fish_data_dir/completions/python3.fish

complete -c python3 -n __fish_python_no_arg -s m -f -d 'Local module' -xa '(_python_module_autocomplete (commandline -ct))'
