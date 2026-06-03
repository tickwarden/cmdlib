# cmdlib:batch/_step
# Internal. Executes the first item in the batch queue, then removes it.
# Schedules itself for next tick if more items remain.

# Copy first item to input
data modify storage cmdlib:input cmd set from storage cmdlib:batch queue[0]

# Remove first item from queue
data remove storage cmdlib:batch queue[0]

# Execute via normal pipeline (guards apply per-command)
function cmdlib:exec/run

# If queue still has items, schedule next step
execute if data storage cmdlib:batch queue[0] run schedule function cmdlib:batch/_step 3t
