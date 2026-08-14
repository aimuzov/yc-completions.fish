# CLAUDE.md — yc-completions.fish

## What this is

A fish plugin with one file of completions for the Yandex Cloud CLI. `yc` has no fish completions of
its own (`yc completion` knows only a `v0` generator), so candidates are parsed out of
`yc <path> --help` on demand and cached per command path for the life of the shell session.

It follows the shape of `keysight.fish` and `binsight.fish`: everything in one file, fixtures and a
stubbed CLI in the tests.

## Layout

```
completions/yc.fish   the whole plugin: __yc_cmd_path, __yc_candidates, __yc_complete
tests/                fishtape suites, help fixtures, the yc stub
```

Fish loads `completions/yc.fish` the first time a completion for `yc` is requested; the `__yc_*`
functions come with it. There is deliberately no `functions/` directory — moving them there would
load them into every session for no reason.

## Help format this parses

```
Groups:
  compute                      Manage Compute Cloud resources     ← name, then description
Commands:
  init                         Initialize the CLI
Flags:
      --format string                                             ← the flag …
          Output format: text (default), yaml, json, json-rest     ← … and its description below
Global Flags:
      --profile string
          Set the custom configuration file
```

Section headers are the only lines with no indent, which is how sections are detected. A flag may
have no description line at all (`--async` in the fixtures) — it is flushed when the next flag or
the end of the output arrives.

## Conventions

- Target fish 4.0+. Code, comments and `--description` strings are in English.
- Comment only what the code cannot say by itself.
- No dependency beyond fish itself: no jq, no awk, no python.

## Traps already hit (do not re-discover these)

- **`commandline` works under `complete --do-complete`.** That is what makes the completion testable
  without an interactive session; calling `__yc_complete` directly gives nothing, because
  `commandline -opc` is empty outside a real command line.
- **The cache lives in global variables named `__yc_cache_<path>`**, with every character outside
  `[A-Za-z0-9_]` replaced. A test that expects a fresh parse must erase them first
  (`_yc_reset_cache` in the helpers).
- **Global flags are only on `yc --help`.** A leaf command lists its own, so the two lists are
  concatenated — otherwise `--profile` disappears exactly where it is most often typed.
- **The stub counts its runs** into `$YC_STUB_CALLS`; that is how the cache test tells a cached
  lookup from a repeated one.

## Testing

```fish
fish --no-config -n completions/*.fish tests/*.fish
fishtape tests/*.test.fish
```

`tests/helpers.fish` puts `tests/stubs/yc` first in `PATH` and points it at `tests/fixtures/help`,
so no real `yc` is involved. Fixtures cover the three interesting shapes: a root with both `Groups:`
and `Commands:`, a group, and a leaf command whose last flag has no description.
