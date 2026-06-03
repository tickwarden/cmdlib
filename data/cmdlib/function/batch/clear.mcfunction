# cmdlib:batch/clear
# Discards all queued commands without executing them.

data remove storage cmdlib:batch queue
execute if score #cmdlib.log_on cmdlib.sys matches 1 run tellraw @a[tag=cmdlib.debug] {"text":"[cmdlib] Batch queue cleared.","color":"yellow"}
