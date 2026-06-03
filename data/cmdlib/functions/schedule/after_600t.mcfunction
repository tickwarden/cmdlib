# cmdlib:schedule/after_600t
# Schedules cmdlib:input cmd to run after 600 ticks (~30s).
# USAGE: same as schedule/after but fires at 600t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_600t 600t
