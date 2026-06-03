# cmdlib:schedule/after_200t
# Schedules cmdlib:input cmd to run after 200 ticks (~10s).
# USAGE: same as schedule/after but fires at 200t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_200t 200t
