function _python_module_autocomplete -d "Generate autocompletions for python local modules"
    set -l target (string replace -a -- '\\ ' ' ' "$argv[1]")
    # command substitution of empty output yields an empty list; force a single empty element
    set -q target[1]; or set target ""

    # python -m does not support relative module names
    if string match -q -- '.*' $target
        return
    end

    set -l cwd_str ''
    set -l tail ''
    set -l has_tail 0

    if string match -q -- '*.' $target
        # ends with "." → list inside that directory, no prefix filter
        set cwd_str (string replace -a -- '.' '/' $target)
    else
        set has_tail 1
        if string match -q -- '*.*' $target
            # split on the last dot
            set -l tail_match (string match -r -- '[^.]*$' $target)
            set -l target_len (string length -- $target)
            set -l match_len (string length -- $tail_match)
            set -l left_len (math $target_len - $match_len - 1)
            set -l left (string sub -l $left_len -- $target)
            set tail $tail_match
            set cwd_str (string replace -a -- '.' '/' $left)
        else
            set tail $target
        end
    end

    set -l search_dir '.'
    set -l prefix ''
    if test -n "$cwd_str"
        set search_dir (string trim -r -c '/' -- $cwd_str)
        set prefix (string replace -a -- '/' '.' $search_dir).
    end

    if not test -d "$search_dir"
        return
    end

    for entry in $search_dir/*
        set -l name (path basename -- $entry)

        # skip __pycache__ directory (but keep __pycache__.py file)
        if test -d "$entry"; and test "$name" = '__pycache__'
            continue
        end

        # skip __init__.py / __main__.py
        if test -f "$entry"; and contains -- $name __init__.py __main__.py
            continue
        end

        # if not a directory, require .py suffix
        if not test -d "$entry"
            if not string match -q -- '*.py' $name
                continue
            end
        end

        # prefix filter (skipped when tail is empty — matches everything)
        if test $has_tail -eq 1; and test -n "$tail"
            set -l head (string sub -l (string length -- $tail) -- $name)
            if test "$head" != "$tail"
                continue
            end
        end

        if test -d "$entry"
            echo $prefix$name'.'
        else
            set -l stripped_len (math (string length -- $name) - 3)
            echo $prefix(string sub -l $stripped_len -- $name)
        end
    end
end
