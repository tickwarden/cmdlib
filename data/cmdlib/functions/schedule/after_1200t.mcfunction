# cmdlib:schedule/after_1200t
# Schedules cmdlib:input cmd to run after 1200 ticks (~60s).
# USAGE: same as schedule/after but fires at 1200t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_1200t 1200t
