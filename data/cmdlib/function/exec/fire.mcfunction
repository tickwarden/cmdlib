# cmdlib:exec/fire
# Fires the command block tunnel.
# Called only when all guards have passed (#cmdlib.ok = 1).

# Lock mutex
scoreboard players set #cmdlib.mutex cmdlib.sys 1

# Log: pre-exec
execute if score #cmdlib.log_on cmdlib.sys matches 1 run function cmdlib:log/write_exec

# Place command block, inject command, trigger
setblock 0 -72 0 minecraft:command_block{Command:"",auto:0b} replace
data modify block 0 -72 0 Command set from storage cmdlib:input cmd
data modify block 0 -72 0 auto set value 1b

# Schedule cleanup for next tick (command block fires at end of tick)
schedule function cmdlib:exec/cleanup 3t
