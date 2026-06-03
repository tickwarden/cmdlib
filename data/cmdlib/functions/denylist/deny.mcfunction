# cmdlib:denylist/deny
# A denylist entry matched. Block execution.

scoreboard players set #cmdlib.ok cmdlib.sys 0

execute if score #cmdlib.log_on cmdlib.sys matches 1 run function cmdlib:log/write_denied
