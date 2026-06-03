# cmdlib:log/write_exec
# Appends an exec entry to cmdlib:log entries list.
# Stores tick count as timestamp.

data modify storage cmdlib:log entries append value {event:"exec",tick:0}
execute store result storage cmdlib:log entries[-1].tick int 1 run scoreboard players get #cmdlib.tick cmdlib.sys
