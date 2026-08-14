# The fish profile the README recording runs in: none of the recorder's own prompt,
# bindings or colours, but the real `yc` of the machine behind every completion.

set -g fish_greeting

set -l here (dirname (status filename))

# The completions are loaded straight out of this checkout, not from an installed copy
set -p fish_complete_path (realpath $here/../../..)/completions

# No autosuggestions while recording: they pull entries out of the shell history, and
# a yc command line usually carries a cloud or folder id that has no business in a gif.
set -g fish_autosuggestion_enabled 0

# Catppuccin Mocha, to match the theme vhs records with
set -g fish_color_normal cdd6f4
set -g fish_color_command 89b4fa
set -g fish_color_param f2cdcd
set -g fish_color_comment 7f849c
set -g fish_color_autosuggestion 6c7086
set -g fish_pager_color_prefix f5e0dc --bold
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description 9399b2
set -g fish_pager_color_selected_background --background=313244

function fish_prompt
    set_color brblack
    echo -n '~ '
    set_color normal
end
