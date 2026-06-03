# cmdlib:schedule/after_100t
# Schedules cmdlib:input cmd to run after 100 ticks (~5s).
# USAGE: same as schedule/after but fires at 100t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_100t 100t
