# Security Policy

## Supported Versions

| Version | Supported |
|---|---|
| 1.x.x | ✅ |
| < 1.0.0 | ❌ |

## Scope

cmdlib is currently a **Minecraft Java Edition datapack**. Security considerations relevant to this project include:

- Command injection via the tunnel pipeline (unsanitized input reaching `cmdlib:input cmd`)
- Denylist bypass through exact-match limitations on 1.18.2
- Unauthorized access to cmdlib scoreboards or storage from external datapacks

> **Note:** cmdlib may be ported to a Fabric mod in the future. If that happens, this policy will be updated to cover additional attack surfaces (mixins, network packets, file I/O, etc.).

## Reporting a Vulnerability

Open a [GitHub Issue](https://github.com/runtoolkit/cmdlib/issues) on this repository.

Please include:

- A description of the vulnerability
- Steps to reproduce
- Affected version(s)
- Potential impact

You can expect an initial response within **7 days**. If the vulnerability is confirmed, a fix will be prioritized and released as a patch. If it is declined, the reasoning will be provided in the issue.

There is currently no bug bounty program.
