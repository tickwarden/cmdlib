# cmdlib:log/write_cleanup
data modify storage cmdlib:log entries append value {event:"cleanup",tick:0}
execute store result storage cmdlib:log entries[-1].tick int 1 run scoreboard players get #cmdlib.tick cmdlib.sys
