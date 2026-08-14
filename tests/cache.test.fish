source (status dirname)/helpers.fish

# Every stub run appends its command path here, so the file counts how often yc
# was actually asked — a cached lookup adds nothing to it.
set --global --export YC_STUB_CALLS (mktemp -t yc-calls.XXXXXX)

_yc_reset_cache
_yc_complete_for 'yc compute ' >/dev/null
set -l first (count < $YC_STUB_CALLS)

_yc_complete_for 'yc compute ' >/dev/null
set -l second (count < $YC_STUB_CALLS)

@test "the first completion asks yc" (test $first -gt 0; and echo yes) = yes
@test "a repeated completion is served from the cache" $first = $second

_yc_reset_cache
_yc_complete_for 'yc compute ' >/dev/null

@test "clearing the cache makes the next completion ask again" \
    (test (count < $YC_STUB_CALLS) -gt $second; and echo yes) = yes

command rm --force $YC_STUB_CALLS
