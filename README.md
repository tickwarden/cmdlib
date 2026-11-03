# cmdlib

`cmdlib` is a Minecraft Java datapack prototype for dispatching command
strings through a command block. The repository includes mutex, cooldown,
exact-string denylist, batching, scheduled dispatch and logging functions. It
uses pre-macro `.mcfunction` syntax and declares `pack_format: 9` in
[`pack.mcmeta`](pack.mcmeta).

> **Do not treat this as a security sandbox or use it in a valuable world.**
> The executor is designed to run arbitrary supplied commands with command-block
> authority. Its denylist only checks seven exact strings and can be bypassed
> by other commands or variants. The source also contains initialization,
> coordinate and scheduling concerns described below. Runtime behavior has not
> been verified; back up the world and use an isolated disposable copy for any
> experiment.

## Declared version and important compatibility limits

- The pack describes Minecraft 1.18.2+, and its actual `pack_format` is **9**.
  Mojang identifies 9 as the [1.18.2 datapack version](https://www.minecraft.net/en-us/article/minecraft-java-edition-1-18-2).
  A format value is not proof that every version after 1.18.2 is supported.
- Paths use the older `data/<namespace>/functions/` and
  `data/minecraft/tags/functions/` layout. Minecraft 1.21 renamed these to
  singular `function` and `tags/function`; see the [1.21 technical changes](https://www.minecraft.net/en-us/article/minecraft-java-edition-1-21).
  The checked-in pack is not automatically adapted for modern versions.
- `exec/fire` and `exec/cleanup` use the absolute block position
  **`0 -72 0`**. In a normal 1.18 Overworld, the bottom build limit is `y=-64`,
  so that Y coordinate is outside the ordinary buildable range; custom
  dimensions can differ. See [Mojang's 1.18 world-generation notes](https://feedback.minecraft.net/hc/en-us/articles/4415128577293-Minecraft-Java-Edition-1-18).
  Even in a dimension where the position is valid, `setblock ... replace`
  replaces the existing block and cleanup replaces it with air.
- `core/init` uses `forceload add 0 -72`. That command takes **X and Z**, so
  it targets `(x=0, z=-72)`, not the command block's `(x=0, z=0)` chunk.
  Force-loading also changes persistent world state.

## Source-observed concerns to resolve before relying on it

These are static observations, not a successful game test:

1. `core/init` first tries to add a player score in `cmdlib.sys`, then guards
   creation of the `cmdlib.sys` objective behind a score check on that same
   objective. In a fresh world where the objective does not already exist,
   that ordering can prevent initialization. The pack's comments describe
   one-time initialization, but it has not been demonstrated here.
2. In `exec/run`, the explicit `exec/abort` call follows the mutex guard.
   Cooldown and denylist checks can set the `ok` flag to zero later, but the
   file does not call `exec/abort` again for those cases. Do not assume that
   every rejected command clears the input or emits the same abort log.
3. All delay wrappers store their command in the **same**
   `cmdlib:schedule pending` slot. Even different delay presets can overwrite
   one another's pending command; separate `_fire_Nt` function names do not
   provide independent payload storage. The general `schedule/after` also
   schedules a fixed `3t`, despite mentioning a score in its header.
4. Initialization removes `cmdlib:batch queue` and `cmdlib:log entries`, while
   later functions append to those paths. Whether the desired lists have been
   created must be checked before expecting batch/log operations to work.
   `batch/_step` removes an item before calling the guarded executor, so a
   rejected step should not be assumed to retry automatically.
5. The package has no tracked in-game test suite. The comments and examples
   express intent, not verified execution, compatibility or security.

No source, workflow or game behavior was changed by this documentation update.

## Intended execution flow

The following illustrates the source interface; it is **not** a recommendation
to run the pack in an existing world:

```mcfunction
# Example input; commands here execute with command-block privileges.
data modify storage cmdlib:input cmd set value "say hello from cmdlib"
function cmdlib:exec/run
```

`exec/run` sets `#cmdlib.ok`, checks mutex, cooldown and the exact denylist,
and calls `exec/fire` only if the flag remains set. `exec/fire` sets the mutex,
places a command block at `0 -72 0`, copies the storage string into its
`Command` field, sets `auto:1b` and schedules `exec/cleanup` in `3t`.
`cleanup` attempts to replace the block with air, removes the input, releases
the mutex and applies any configured cooldown. Success is not checked at every
step; see the limitations above.

### Mutex and cooldown

| Score | Intended role |
| --- | --- |
| `#cmdlib.mutex cmdlib.sys` | `0` free, `1` busy while execution awaits cleanup. |
| `#cmdlib.ok cmdlib.sys` | Guard flag controlling later stages. |
| `#cmdlib.cd_set cmdlib.cool` | Requested cooldown to apply after cleanup. |
| `#cmdlib.cd cmdlib.cool` | Active cooldown, decremented by the tick function. |

An illustrative cooldown setting is:

```mcfunction
scoreboard players set #cmdlib.cd_set cmdlib.cool 20
data modify storage cmdlib:input cmd set value "say rate limited"
function cmdlib:exec/run
```

### Denylist

[`denylist/check.mcfunction`](data/cmdlib/functions/denylist/check.mcfunction)
compares the input to these exact strings: `op @a`, `op @p`, `deop @a`,
`stop`, `ban @a`, `kick @a` and `whitelist off`. It has no pattern or prefix
matching. The file contains an example of adding an exact entry, but modifying
it does not turn the executor into a safe privilege boundary.

## Batch and delay interfaces

The intended batch sequence is `batch/add` for each storage input, followed by
`batch/run_all`; `batch/clear` removes the queued list. Each `_step` attempts
the ordinary guarded pipeline and schedules the next step at `3t`. The queue
and timing concerns above apply.

```mcfunction
data modify storage cmdlib:input cmd set value "say step one"
function cmdlib:batch/add
data modify storage cmdlib:input cmd set value "say step two"
function cmdlib:batch/add
function cmdlib:batch/run_all
```

Delay wrappers are `schedule/after_20t`, `_40t`, `_60t`, `_100t`, `_200t`,
`_600t` and `_1200t`: at 20 ticks per second these nominally represent 1, 2,
3, 5, 10, 30 and 60 seconds. Actual timing depends on the server's tick rate.
Each wrapper schedules a corresponding function but **all share the pending
storage slot**, so concurrent calls are not isolated.

```mcfunction
data modify storage cmdlib:input cmd set value "say delayed"
function cmdlib:schedule/after_20t
```

## Storage, scores and logs

| Storage / objective | Source purpose |
| --- | --- |
| `cmdlib:input cmd` | Current command string. |
| `cmdlib:batch queue` | Queued command strings. |
| `cmdlib:schedule pending` | Single shared pending command. |
| `cmdlib:log entries` | Intended event list with tick timestamps. |
| `cmdlib:state mutex`, `cooldown` | Removed by initialization; reserved in the existing layout. |
| `cmdlib.sys` | System flags, initialization and tick counter. |
| `cmdlib.cool` | Cooldown scores. |
| `cmdlib.vars` | General-purpose scores. |

Most logging calls check `#cmdlib.log_on cmdlib.sys`; the cooldown check calls
its `cooldown_block` writer without that flag check. Writers exist for `exec`,
`cleanup`, `abort`, `mutex_busy`, `cooldown_block` and `denylist_hit`.
`cmdlib:log/flush` emits output to players tagged `cmdlib.debug` only when
logging is enabled, then **removes `entries` even if logging is disabled**.
Logs and queues are not tamper-proof audit records. Preserve any data you need
before initialization or flushing.

```mcfunction
# Illustrative inspection/configuration commands
/data get storage cmdlib:log entries
scoreboard players set #cmdlib.log_on cmdlib.sys 0
scoreboard players set #cmdlib.log_on cmdlib.sys 1
tag @s add cmdlib.debug
function cmdlib:log/flush
```

## Repository and release workflow

- [`data/cmdlib/functions/`](data/cmdlib/functions/) — implementation by module.
- [`data/minecraft/tags/functions/`](data/minecraft/tags/functions/) — load and tick tags.
- [`pack.mcmeta`](pack.mcmeta) — declared pack metadata.
- [`.github/workflows/build.yml`](.github/workflows/build.yml) — a tag-push
  workflow that packages `data` and `pack.mcmeta` and publishes a release. It
  does not define a pull-request test job.
- [`CONTRIBUTING.md`](CONTRIBUTING.md), [`SECURITY.md`](SECURITY.md) and
  [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) — contribution and reporting policies.

No Minecraft world or server was started for this README update. A static
review is not a substitute for testing in a disposable world or independently
reviewing a command execution framework.

## License

[MIT](LICENSE.txt); preserve the copyright notice and license terms.
