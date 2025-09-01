extends Lever

func _ready() -> void:
	if GlobalSapphire.player_savedata.dimension != 1:
		queue_free()
