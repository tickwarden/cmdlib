# cmdlib:mutex/busy
# Tunnel is currently busy (previous command hasn't cleaned up yet).
# Sets ok=0 to block execution.

scoreboard players set #cmdlib.ok cmdlib.sys 0

execute if score #cmdlib.log_on cmdlib.sys matches 1 run function cmdlib:log/write_mutex_busy
