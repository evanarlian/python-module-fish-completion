#!/usr/bin/env fish
# Run from the repo root: fish test_autocomplete.fish

set -l script_dir (path resolve (status dirname))
cd $script_dir

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

if test $failures -eq 0
    echo "all tests passed"
    exit 0
else
    echo "$failures test(s) failed"
    exit 1
end
