# yc-completions.fish

Tab completions for the [Yandex Cloud CLI](https://yandex.cloud/docs/cli/) in
[fish](https://fishshell.com).

`yc` has no fish completions of its own — `yc completion` offers a single `v0` generator, and fish is
not one of the shells it knows. This plugin fills that gap, and it does so without a table of
commands that would go stale: candidates come from `yc --help` itself.

```fish
yc <TAB>                          # groups and commands, with the descriptions yc prints
yc compute instance <TAB>         # create, delete, get, list …
yc compute instance --<TAB>       # flags of the command, plus the global ones
```

![yc completions in action](docs/demo.gif)

## Install

With [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install aimuzov/yc-completions.fish
```

Manually — copy `completions/yc.fish` into `~/.config/fish/completions/`.

## How it works

`yc` describes itself: every group, command and flag is listed by `yc <path> --help`. This plugin
parses that output on demand for whatever you are typing, and keeps the result in a shell variable
until the session ends.

Two consequences worth knowing:

- **The suggestions always match the installed version.** Upgrade `yc` and the completions follow —
  there is nothing here to update.
- **The first completion for a command path runs `yc --help` once.** That is a local call with no
  network traffic; repeated completions for the same path are served from the cache.

To drop the cache without restarting the shell:

```fish
set --names | string match '__yc_cache_*' | while read name; set --erase $name; end
```

## Notes

- The help output is not cobra's: groups and commands live under `Groups:` and `Commands:`, and
  flags are two lines each — the flag, then its description indented below. Both shapes are handled,
  including a flag that has no description at all.
- Flags are offered only when the word being completed already starts with `-`; otherwise you get
  commands. Global flags are added on leaf commands, because `yc` lists them only at the top.
- A command path `yc` does not know completes to nothing rather than to an error.

## Tests

```fish
fish --no-config -n completions/*.fish tests/*.fish
fishtape tests/*.test.fish
```

The suite runs against `tests/stubs/yc`, which prints fixtures instead of talking to the cloud, so
it needs neither an installed `yc` nor an account, and says the same thing on any machine.

The recording above is scripted, so it can be redone on any machine that has
[vhs](https://github.com/charmbracelet/vhs) and `ttyd`:

```fish
cd docs; and vhs demo.tape
```

It runs in the throwaway fish profile under `docs/demo-profile`, with every XDG directory pointed
inside it — the recorder's own history stays out of frame, and so do the cloud and folder ids in it.
The completions themselves come from the real `yc` of whoever records it.

## License

[MIT](LICENSE)
