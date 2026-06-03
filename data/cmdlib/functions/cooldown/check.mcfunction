# cmdlib:cooldown/check
# If global cooldown is active, block execution.

execute if score #cmdlib.cd cmdlib.cool matches 1.. run scoreboard players set #cmdlib.ok cmdlib.sys 0
execute if score #cmdlib.cd cmdlib.cool matches 1.. run function cmdlib:log/write_cooldown_block
