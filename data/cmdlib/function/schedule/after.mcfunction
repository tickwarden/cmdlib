# cmdlib:schedule/after
# Schedules cmdlib:input cmd to run after #cmdlib.sched_ticks ticks.
#
# USAGE:
#   data modify storage cmdlib:input cmd set value "say delayed!"
#   scoreboard players set #cmdlib.sched_ticks cmdlib.vars 100
#   function cmdlib:schedule/after
#
# NOTE: Uses /schedule. If the same schedule is called again before
# it fires, the previous one is replaced (vanilla /schedule behavior).
# For independent delayed calls, use batch/add + batch/run_all instead.

# Copy input to schedule storage slot
data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd

# Schedule the dispatcher
# Delay is fixed at runtime — vanilla /schedule does not accept dynamic tick values.
# Default: 1t. Caller must use one of the preset wrappers below if they need other delays.
# See schedule/after_Nt.mcfunction files for preset delays.
schedule function cmdlib:schedule/_fire 3t
