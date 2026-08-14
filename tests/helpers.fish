# Shared setup for every suite: load the completions out of this checkout and put the
# yc stub first in PATH, so the tests never touch a real yc or a real cloud.

set --global yc_tests (realpath (status dirname))

set --global --export YC_STUB_FIXTURES $yc_tests/fixtures/help
set --global --export PATH $yc_tests/stubs $PATH

source $yc_tests/../completions/yc.fish

function _yc_reset_cache --description 'Forget everything the parser cached in this session'
    for name in (set --names | string match '__yc_cache_*')
        set --erase $name
    end
end

# `complete -C` runs the completion the same way the shell does — including
# `commandline -opc` inside it — which is what makes the picker testable without
# an interactive session.
function _yc_complete_for --description 'The completions offered for a command line'
    complete --do-complete "$argv[1]"
end

function _yc_names --description 'Candidate names, without their descriptions'
    for line in $argv
        string split \t -- $line | head -1
    end
end

function _yc_description_of --description 'The description offered for one candidate'
    set -l wanted $argv[1]

    for line in $argv[2..]
        set -l fields (string split \t -- $line)
        test "$fields[1]" = "$wanted"; and echo "$fields[2]"
    end
end

function _yc_has --description 'yes when the needle is one of the candidate names'
    set -l wanted $argv[1]

    contains -- $wanted (_yc_names $argv[2..]); and echo yes; or echo no
end
