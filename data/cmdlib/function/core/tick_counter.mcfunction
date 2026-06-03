# cmdlib:core/tick_counter
# Increments global tick counter. Used for log timestamps.
# Overflow at 2^31-1 (~1 year continuous) — resets to 0 via scoreboard wrap.

scoreboard players add #cmdlib.tick cmdlib.sys 1
