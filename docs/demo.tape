# The recording in the README. It runs against the machine it is recorded on, so the
# groups, commands and flags on screen come from the yc that is actually installed.
#
#   brew install vhs ttyd
#   cd docs && vhs demo.tape
#
# Every XDG directory is redirected into the throwaway profile, history included: a
# recorder's fish history is full of cloud and folder ids, and an autosuggestion would
# put one on screen.
#
# The hidden warm-up matters: the first completion of a session parses `yc --help` and
# builds the session cache, which takes long enough to be visible as a stutter.

Output demo.gif

Set Shell "bash"
Set FontFamily "JetBrainsMonoNL Nerd Font"
Set FontSize 15
Set Width 1500
Set Height 620
Set Padding 18
Set Theme "Catppuccin Mocha"
Set TypingSpeed 90ms
Set Framerate 24

Hide
Type "env XDG_CONFIG_HOME=$PWD/demo-profile XDG_DATA_HOME=$PWD/demo-profile/data XDG_CACHE_HOME=$PWD/demo-profile/cache XDG_STATE_HOME=$PWD/demo-profile/state fish -i"
Enter
Sleep 3s

Type "yc "
Sleep 500ms
Tab
Sleep 4s
Escape
Ctrl+U
Type "yc compute instance list --"
Sleep 500ms
Tab
Sleep 4s
Escape
Ctrl+U
Type "clear"
Enter
Sleep 1s
Show

Sleep 1s

# every group and command yc knows, with the descriptions yc printed for them
Type "yc "
Sleep 800ms
Tab
Sleep 4s
Escape
Sleep 700ms

# the same one level down: what a nested command can actually do
Ctrl+U
Sleep 500ms
Type "yc compute instance "
Sleep 800ms
Tab
Sleep 4s
Escape
Sleep 700ms

# flags of the command, plus the global ones yc only lists at the top level
Ctrl+U
Sleep 500ms
Type "yc compute instance list --"
Sleep 800ms
Tab
Sleep 4s

Ctrl+U
Sleep 1s
