# cmdlib:batch/run_all
# Starts sequential execution of the batch queue.
# Each command runs one per tick (mutex constraint).
#
# Copies queue[0] to cmdlib:input cmd, calls exec/run, schedules next step.
# Continues until queue is empty.

# If queue is empty, nothing to do
execute unless data storage cmdlib:batch {queue:[]} run function cmdlib:batch/_step
execute if data storage cmdlib:batch {queue:[]} run data remove storage cmdlib:batch queue
