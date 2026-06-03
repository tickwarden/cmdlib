# cmdlib:denylist/check
# Exact-match denylist. Checks cmdlib:input cmd against known denied strings.
# If match found: sets #cmdlib.ok = 0.
#
# HOW TO ADD ENTRIES:
#   Add a line:
#     execute if data storage cmdlib:input {cmd:"<exact command>"} run function cmdlib:denylist/deny
#
# LIMITATION (1.18.2): No wildcard, no prefix match. Exact string only.
# For prefix matching, upgrade to 1.20.2+ and use macro-based denylist.

# --- Denied commands ---
execute if data storage cmdlib:input {cmd:"op @a"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"op @p"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"deop @a"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"stop"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"ban @a"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"kick @a"} run function cmdlib:denylist/deny
execute if data storage cmdlib:input {cmd:"whitelist off"} run function cmdlib:denylist/deny

# Add your entries below this line:
