#!/usr/bin/env fish

function __python_module_autocomplete
    set module_path $argv[1]

    # Handle fish weird space escape TODO fullcheck all
    # set module_path (string replace -a "\\ " " " -- $module_path)

    if string match -q ".*" -- $module_path
        # Python does not support relative module name using python -m
        return
    end

    if string match -q "*." -- $module_path
        # "app.core." can be autocompleted to "app.core.engine"
        set cwd (string replace -a "." "/" -- $module_path)
        set tail ""
    else
        # "app.core" can be autocompleted to "app.coreboot"
        set parts (string split -r -m1 "." -- $module_path)
        if test (count $parts) -eq 2
            set module_path (string replace -a "." "/" -- $parts[1])
            set tail $parts[2]
        else
            set module_path ""
            set tail $parts[1]
        end
        set cwd $module_path
    end
    # Generate valid paths that might be able to be run using python -m
    # TODO this part is still broken (loop)
    for path in testapp/__dunder/*
        set filename (basename $path)
        if string match -q ".*" -- $filename
            continue
        end
        if test -d $path; and test $filename = __pycache__
            continue
        end
        if test -f $path; and contains $filename "__main__.py" "__init__.py"
            continue
        end
        if not test -d $path; and not string match -q "*.py" -- $path
            continue
        end
        if test -n "$tail"; and not string match -q "$tail*" -- $filename
            continue
        end
        if test -d $path
            echo (string replace -a "/" "." -- $path)"."
        else
            echo (string replace -a "/" "." -- (string replace -r '\.py$' '' -- $path))
        end
    end
end

function __wrapper
    set target_path $argv[1]
    for path in (__python_module_autocomplete $target_path | sort)
        echo $path
    end
end

__wrapper 