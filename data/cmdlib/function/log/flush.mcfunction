# cmdlib:log/flush
# Prints all log entries to players tagged cmdlib.debug, then clears the list.
# Call manually: function cmdlib:log/flush
#
# NOTE: This shows entry count only. Full NBT inspection via:
#   /data get storage cmdlib:log entries

execute if score #cmdlib.log_on cmdlib.sys matches 1 run tellraw @a[tag=cmdlib.debug] [{"text":"[cmdlib] Log flush: ","color":"aqua"},{"nbt":"entries","storage":"cmdlib:log","interpret":false}]
data remove storage cmdlib:log entries
