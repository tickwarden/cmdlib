# cmdlib:core/init
# One-time initialization. Called on load.
# Guard: skip if already initialized this session.
scoreboard players add #cmdlib.init cmdlib.sys 0
execute unless score #cmdlib.init cmdlib.sys matches 0 run function cmdlib:core/_init_skip

# --- Scoreboards ---
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard objectives add cmdlib.sys dummy "cmdlib: system"
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard objectives add cmdlib.cool dummy "cmdlib: cooldowns"
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard objectives add cmdlib.vars dummy "cmdlib: vars"

# --- Forceload tunnel chunk ---
execute if score #cmdlib.init cmdlib.sys matches 0 run forceload add 0 -72

# --- Tunnel block: ensure clean state ---
execute if score #cmdlib.init cmdlib.sys matches 0 run setblock 0 -72 0 minecraft:air replace

# --- Storage: clear all cmdlib namespaces ---
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:input cmd
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:state mutex
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:state cooldown
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:log entries
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:batch queue
execute if score #cmdlib.init cmdlib.sys matches 0 run data remove storage cmdlib:batch index

# --- System scores: reset ---
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard players set #cmdlib.mutex cmdlib.sys 0
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard players set #cmdlib.ok cmdlib.sys 1
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard players set #cmdlib.log_on cmdlib.sys 1

# --- Done ---
execute if score #cmdlib.init cmdlib.sys matches 0 run scoreboard players set #cmdlib.init cmdlib.sys 1
execute if score #cmdlib.init cmdlib.sys matches 1 run tellraw @a[tag=cmdlib.debug] {"text":"[cmdlib] Initialized.","color":"green"}
