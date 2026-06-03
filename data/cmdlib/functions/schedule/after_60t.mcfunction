# cmdlib:schedule/after_60t
# Schedules cmdlib:input cmd to run after 60 ticks (~3s).
# USAGE: same as schedule/after but fires at 60t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_60t 60t
