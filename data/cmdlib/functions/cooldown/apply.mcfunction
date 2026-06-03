# cmdlib:cooldown/apply
# Copies #cmdlib.cd_set into #cmdlib.cd, then resets cd_set.
# Called from exec/cleanup only if cd_set >= 1.

scoreboard players operation #cmdlib.cd cmdlib.cool = #cmdlib.cd_set cmdlib.cool
scoreboard players set #cmdlib.cd_set cmdlib.cool 0
