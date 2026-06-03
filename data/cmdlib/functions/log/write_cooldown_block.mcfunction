# cmdlib:log/write_cooldown_block
data modify storage cmdlib:log entries append value {event:"cooldown_block",tick:0}
execute store result storage cmdlib:log entries[-1].tick int 1 run scoreboard players get #cmdlib.tick cmdlib.sys
