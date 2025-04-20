extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_parent()
	self.limit_right = player.world_map.size.x
	self.limit_bottom = player.world_map.size.y
