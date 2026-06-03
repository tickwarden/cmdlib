# cmdlib:schedule/_fire_100t
# Internal. Fires command scheduled via after_100t.

data modify storage cmdlib:input cmd set from storage cmdlib:schedule pending
data remove storage cmdlib:schedule pending
function cmdlib:exec/run
