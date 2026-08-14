source (status dirname)/helpers.fish

set -l root (_yc_complete_for 'yc ')

@test "groups are offered at the root" (_yc_has compute $root) = yes
@test "plain commands are offered at the root" (_yc_has init $root) = yes
@test "a group keeps the description yc printed for it" \
    (_yc_description_of compute $root) = 'Manage Compute Cloud resources'
@test "flags are not offered while the token is a plain word" (_yc_has --format $root) = no

set -l leaf (_yc_complete_for 'yc compute instance ')

@test "subcommands of a nested command are offered" (_yc_has create $leaf) = yes
@test "the group above the leaf is not offered again" (_yc_has instance $leaf) = no

set -l flags (_yc_complete_for 'yc compute instance --')

@test "flags of the command itself are offered" (_yc_has --folder-id $flags) = yes
@test "global flags are offered on a leaf as well" (_yc_has --profile $flags) = yes
@test "a flag with no description of its own survives the parse" (_yc_has --async $flags) = yes
@test "commands are not offered while the token is a flag" (_yc_has create $flags) = no

# The flag and its description live on two separate lines of the help output
@test "a flag carries the description from the line below it" \
    (_yc_description_of --folder-id $flags) = 'Folder ID'

set -l unknown (_yc_complete_for 'yc nosuchgroup ')

@test "an unknown command path offers nothing" (count $unknown) = 0
