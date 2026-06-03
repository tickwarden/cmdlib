# cmdlib:batch/add
# Appends cmdlib:input cmd to the batch queue.
#
# USAGE:
#   data modify storage cmdlib:input cmd set value "say first"
#   function cmdlib:batch/add
#   data modify storage cmdlib:input cmd set value "say second"
#   function cmdlib:batch/add
#   function cmdlib:batch/run_all

data modify storage cmdlib:batch queue append from storage cmdlib:input cmd
data remove storage cmdlib:input cmd
