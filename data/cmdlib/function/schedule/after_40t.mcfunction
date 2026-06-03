# cmdlib:schedule/after_40t
# Schedules cmdlib:input cmd to run after 40 ticks (~2s).
# USAGE: same as schedule/after but fires at 40t.

data modify storage cmdlib:schedule pending set from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
schedule function cmdlib:schedule/_fire_40t 40t
