# cmdlib

**Command execution framework for Minecraft Java Edition 1.18.2+**

Provides a safe, guarded command block tunnel with cooldown, mutex locking, denylist, debug logging, batch execution, and scheduled dispatch — all compatible with versions that predate `/return` and function macros.

---

## Requirements

| | |
|---|---|
| Minecraft | 1.18.2+ (pack_format 10) |
| No mods required | Vanilla datapack only |
| Macro support | Not required — 1.18.2 compatible |

---

## Installation

Drop the `cmdlib` folder into your world's `datapacks/` directory and run `/reload`.

On load, `cmdlib:core/init` runs automatically and sets up all scoreboards, forceloads the tunnel chunk, and resets state. A confirmation message is sent to any player tagged `cmdlib.debug`.

---

## Quick Start

```mcfunction
# Write the command you want to execute
data modify storage cmdlib:input cmd set value "say hello from cmdlib"

# Run it through the safe pipeline
function cmdlib:exec/run
```

The pipeline checks mutex → cooldown → denylist before firing. If any guard blocks execution, the input is cleared and the call is logged.

---

## Execution Pipeline

```
exec/run
  │
  ├─ [mutex busy?]    → exec/abort
  ├─ [cooldown active?] → exec/abort
  ├─ [denylist match?]  → exec/abort
  │
  └─ exec/fire
       │
       ├─ sets mutex = 1
       ├─ places command block at 0 -72 0
       ├─ injects command from storage
       ├─ triggers block (auto=1b)
       └─ schedules exec/cleanup (3t)
            │
            └─ removes block, clears input, releases mutex
```

All guards use scoreboard flags (`#cmdlib.ok`) — no `/return` required.

---

## Modules

### exec — Core execution

| Function | Description |
|---|---|
| `cmdlib:exec/run` | Main entry point. Runs all guards then fires. |
| `cmdlib:exec/fire` | Internal. Places and triggers the command block. |
| `cmdlib:exec/cleanup` | Internal. Scheduled 3t after fire. Removes block, releases mutex. |
| `cmdlib:exec/abort` | Internal. Called when any guard fails. Clears input. |

### mutex — Concurrent call protection

Prevents a second call from firing while the tunnel block is still active (cleanup hasn't run yet). Held for 3 ticks per execution.

| Score | Meaning |
|---|---|
| `#cmdlib.mutex cmdlib.sys = 0` | Tunnel free |
| `#cmdlib.mutex cmdlib.sys = 1` | Tunnel busy |

### cooldown — Rate limiting

```mcfunction
# Set cooldown before calling exec/run (applied after successful execution)
scoreboard players set #cmdlib.cd_set cmdlib.cool 20
data modify storage cmdlib:input cmd set value "say rate limited"
function cmdlib:exec/run
```

`#cmdlib.cd_set` is consumed on cleanup and loaded into `#cmdlib.cd`, which counts down each tick. While `#cmdlib.cd >= 1`, calls are blocked.

| Score | Meaning |
|---|---|
| `#cmdlib.cd_set cmdlib.cool` | Ticks to apply after next exec |
| `#cmdlib.cd cmdlib.cool` | Active cooldown countdown |

### denylist — Exact-match blocking

Edit `cmdlib:denylist/check` to add blocked commands:

```mcfunction
execute if data storage cmdlib:input {cmd:"op @a"} run function cmdlib:denylist/deny
```

**Limitation (1.18.2):** Exact string match only. No wildcards, no prefix matching. For prefix-based rules, upgrade to 1.20.2+ and use macro-based denylist.

### batch — Sequential multi-command execution

```mcfunction
# Queue commands
data modify storage cmdlib:input cmd set value "say step one"
function cmdlib:batch/add

data modify storage cmdlib:input cmd set value "say step two"
function cmdlib:batch/add

data modify storage cmdlib:input cmd set value "say step three"
function cmdlib:batch/add

# Execute all, one per 3 ticks
function cmdlib:batch/run_all
```

| Function | Description |
|---|---|
| `cmdlib:batch/add` | Appends `cmdlib:input cmd` to the queue |
| `cmdlib:batch/run_all` | Starts sequential execution of the queue |
| `cmdlib:batch/clear` | Discards the queue without executing |

Each batch step goes through the full `exec/run` pipeline — guards apply per command.

### schedule — Delayed execution

```mcfunction
data modify storage cmdlib:input cmd set value "say delayed"
function cmdlib:schedule/after_20t   # fires after 20 ticks (~1s)
```

Available preset delays:

| Function | Delay | Approx. time |
|---|---|---|
| `cmdlib:schedule/after_20t` | 20t | 1s |
| `cmdlib:schedule/after_40t` | 40t | 2s |
| `cmdlib:schedule/after_60t` | 60t | 3s |
| `cmdlib:schedule/after_100t` | 100t | 5s |
| `cmdlib:schedule/after_200t` | 200t | 10s |
| `cmdlib:schedule/after_600t` | 600t | 30s |
| `cmdlib:schedule/after_1200t` | 1200t | 60s |

> **Note:** Each preset uses a separate `_fire_Nt` function. Calling the same preset twice before it fires replaces the first schedule (vanilla `/schedule` behavior). For independent delayed calls, use `batch/add` + `batch/run_all` instead.

### log — Debug logging

Events are appended to `cmdlib:log entries` as NBT compounds with an event name and tick timestamp.

Logged events: `exec`, `cleanup`, `abort`, `mutex_busy`, `cooldown_block`, `denylist_hit`

```mcfunction
# View raw log in NBT
/data get storage cmdlib:log entries

# Print to debug-tagged players and clear
function cmdlib:log/flush
```

Logging is controlled by `#cmdlib.log_on cmdlib.sys`:

```mcfunction
scoreboard players set #cmdlib.log_on cmdlib.sys 0   # disable
scoreboard players set #cmdlib.log_on cmdlib.sys 1   # enable
```

To receive log flush messages in chat, tag yourself:

```mcfunction
tag @s add cmdlib.debug
```

---

## Storage Layout

| Storage | Key | Content |
|---|---|---|
| `cmdlib:input` | `cmd` | Command string pending execution |
| `cmdlib:batch` | `queue` | List of queued command strings |
| `cmdlib:schedule` | `pending` | Command string pending scheduled fire |
| `cmdlib:log` | `entries` | List of log event compounds |
| `cmdlib:state` | `mutex` | Reserved |
| `cmdlib:state` | `cooldown` | Reserved |

---

## Scoreboard Layout

| Objective | Purpose |
|---|---|
| `cmdlib.sys` | System flags (`#cmdlib.mutex`, `#cmdlib.ok`, `#cmdlib.log_on`, `#cmdlib.init`, `#cmdlib.tick`) |
| `cmdlib.cool` | Cooldown values (`#cmdlib.cd`, `#cmdlib.cd_set`) |
| `cmdlib.vars` | General-purpose vars |

All fake players use the `#` prefix.

---

## Known Limitations

- **Exact denylist only** — no wildcard or prefix match on 1.18.2. Upgrade to 1.20.2+ for macro-based pattern matching.
- **One command per 3 ticks** — mutex is held until cleanup fires. High-frequency batch calls have a minimum 3t gap per command.
- **Single tunnel coordinate** — hardcoded at `0 -72 0`. If your world uses this coordinate, change it in `exec/fire`, `exec/cleanup`, and `core/init`.
- **No `/return`** — guard logic uses scoreboard flag chaining. This is intentional for 1.18.2 compatibility.

---

## License

MIT — [runtoolkit](https://github.com/runtoolkit)