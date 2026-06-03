# cmdlib:exec/run
# Main entry point. Safe command execution with all guards.
#
# USAGE:
#   1. Write command to storage:
#        data modify storage cmdlib:input cmd set value "say hello"
#   2. (Optional) set cooldown ticks:
#        scoreboard players set #cmdlib.cd_set cmdlib.cool 20
#   3. Call this function:
#        function cmdlib:exec/run
#
# PIPELINE (1.18.2 compatible, no /return):
#   mutex check -> cooldown check -> denylist check -> exec -> cleanup

scoreboard players set #cmdlib.ok cmdlib.sys 1

# Step 1: Mutex guard
execute if score #cmdlib.mutex cmdlib.sys matches 1 run function cmdlib:mutex/busy
execute if score #cmdlib.ok cmdlib.sys matches 0 run function cmdlib:exec/abort

# Step 2: Cooldown guard
execute if score #cmdlib.ok cmdlib.sys matches 1 run function cmdlib:cooldown/check

# Step 3: Denylist check
execute if score #cmdlib.ok cmdlib.sys matches 1 run function cmdlib:denylist/check

# Step 4: Execute
execute if score #cmdlib.ok cmdlib.sys matches 1 run function cmdlib:exec/fire

# Step 5: Reset ok flag
scoreboard players set #cmdlib.ok cmdlib.sys 0
