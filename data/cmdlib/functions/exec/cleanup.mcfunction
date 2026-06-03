# cmdlib:exec/cleanup
# Called 1 tick after exec/fire.
# Removes command block, clears input storage, releases mutex.

# Remove tunnel block
setblock 0 -72 0 minecraft:air replace

# Clear input
data remove storage cmdlib:input cmd

# Release mutex
scoreboard players set #cmdlib.mutex cmdlib.sys 0

# Apply cooldown if set
execute if score #cmdlib.cd_set cmdlib.cool matches 1.. run function cmdlib:cooldown/apply

# Log: cleanup done
execute if score #cmdlib.log_on cmdlib.sys matches 1 run function cmdlib:log/write_cleanup
