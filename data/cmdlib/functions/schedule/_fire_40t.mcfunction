# cmdlib:schedule/_fire_40t
# Internal. Fires command scheduled via after_40t.

data modify storage cmdlib:input cmd set from storage cmdlib:schedule pending
data remove storage cmdlib:schedule pending
function cmdlib:exec/run
