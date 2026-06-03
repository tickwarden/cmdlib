# cmdlib:schedule/_fire
# Internal. Moves scheduled command to input and executes it.

data modify storage cmdlib:input cmd set from storage cmdlib:schedule pending
data remove storage cmdlib:schedule pending
function cmdlib:exec/run
