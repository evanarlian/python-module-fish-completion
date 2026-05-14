function _python_module_uv_run_no_module -d "True if `uv run` has not yet been given a module to execute"
    # Returns true while the user is still completing the FIRST -m's argument;
    # false on the second -m (which is an argument to the module, not a uv flag).
    set -l tokens (commandline -opc)
    set -l count 0
    for t in $tokens
        if test "$t" = -m; or test "$t" = --module
            set count (math $count + 1)
        end
    end
    test $count -le 1
end
