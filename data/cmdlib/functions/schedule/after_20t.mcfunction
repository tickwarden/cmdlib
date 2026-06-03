# cmdlib:schedule/after_20t
# Schedules cmdlib:input cmd to run after 20 ticks (~1s).
# USAGE: same as schedule/after but fires at 20t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_20t 20t
