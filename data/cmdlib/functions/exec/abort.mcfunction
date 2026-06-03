# cmdlib:exec/abort
# Called when exec/run is blocked (mutex, cooldown, or denylist).
# Clears input so it doesn't persist.

data remove storage cmdlib:input cmd

# Log: aborted
execute if score #cmdlib.log_on cmdlib.sys matches 1 run function cmdlib:log/write_abort
