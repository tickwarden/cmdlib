# cmdlib:core/tick
# Per-tick systems.

# --- Tick counter (log timestamps) ---
function cmdlib:core/tick_counter

# --- Cooldown decrement ---
# Global cooldown counter: counts down to 0, stops there.
execute if score #cmdlib.cd cmdlib.cool matches 1.. run scoreboard players remove #cmdlib.cd cmdlib.cool 1
