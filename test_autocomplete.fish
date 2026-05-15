#!/usr/bin/env fish
# Run from the repo root: fish test_autocomplete.fish

set -g script_dir (path resolve (status dirname))
cd $script_dir

# Make this repo's functions/ autoloadable, the way fisher would in real use.
set -p fish_function_path $script_dir/functions

source functions/_python_module_autocomplete.fish

set -g failures 0

function _normalize
    # Sort + join lines so two unordered result sets are directly comparable.
    if test (count $argv) -eq 0
        echo -n ''
    else
        printf '%s\n' $argv | sort | string collect
    end
end

function check
    set -l label $argv[1]
    set -l input $argv[2]
    set -l expected $argv[3..-1]

    set -l got (_python_module_autocomplete $input)
    set -l exp_norm (_normalize $expected)
    set -l got_norm (_normalize $got)

    if test "$exp_norm" = "$got_norm"
        echo "PASS  $label"
    else
        echo "FAIL  $label"
        echo "  input:    '$input'"
        echo "  expected: $expected"
        echo "  got:      $got"
        set -g failures (math $failures + 1)
    end
end

check test_empty ''  \
    'testapp.' \
    'completions.' \
    'functions.'

check test_relative_module     '.auto'
check test_hidden_module1      '.testapp'
check test_hidden_module2      '.testapp_hidden.'

check test_folder 'testapp.' \
    'testapp.__dunder.' \
    'testapp.dash-folder-hehe.' \
    'testapp.dotfile.' \
    'testapp.lol lol.' \
    'testapp.samename' \
    'testapp.samename.' \
    'testapp.__pycache__'

check test_subfolder1 'testapp.__dunder.'   'testapp.__dunder.dunder'
check test_subfolder2 'testapp.dotfile.'    'testapp.dotfile.bnuuy'
check test_subfolder3 'testapp.lol lol.'    'testapp.lol lol.lol lol'
check test_subfolder4 'testapp.samename.'
check test_nonexistent 'testapp.hehe'

# === completion condition tests ===
# These probe the -n guards (__fish_python_no_arg for python,
# _python_module_uv_run_no_module for uv) that suppress a false-positive
# completion when -m is repeated, e.g. `python -m foo -m <TAB>`.
#
# Each test spawns a clean sub-fish (--no-config) so a previously-installed
# version of this plugin in ~/.config/fish can't interfere. The sub-fish
# only sees this repo's completions/ and functions/.

function check_local_fires
    set -l label $argv[1]
    set -l cmdline $argv[2]
    set -l expect $argv[3]

    set -l matches (fish --no-config -c "
        set -p fish_function_path $script_dir/functions
        set -p fish_complete_path $script_dir/completions
        cd $script_dir
        source $script_dir/completions/python.fish 2>/dev/null
        source $script_dir/completions/python3.fish 2>/dev/null
        source $script_dir/completions/uv.fish 2>/dev/null
        complete -C '$cmdline' 2>/dev/null | string match -e 'Local module'
    " 2>/dev/null)

    set -l got no
    test (count $matches) -gt 0; and set got yes

    if test "$got" = "$expect"
        echo "PASS  $label"
    else
        echo "FAIL  $label: cmdline=[$cmdline] expected=$expect got=$got"
        set -g failures (math $failures + 1)
    end
end

check_local_fires test_python_first_m   'python -m '           yes
check_local_fires test_python_second_m  'python -m foo -m '    no
check_local_fires test_python3_first_m  'python3 -m '          yes
check_local_fires test_python3_second_m 'python3 -m foo -m '   no
check_local_fires test_uv_first_m       'uv run -m '           yes
check_local_fires test_uv_second_m      'uv run -m foo -m '    no

# === side-effect contract ===
# Completion must never trigger a Python interpreter download.
if string match -q '*--no-python-downloads*' < completions/uv.fish
    echo "PASS  test_uv_no_python_download_flag"
else
    echo "FAIL  test_uv_no_python_download_flag"
    set -g failures (math $failures + 1)
end

if test $failures -eq 0
    echo "all tests passed"
    exit 0
else
    echo "$failures test(s) failed"
    exit 1
end
