extends Camera2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.player = get_parent()
	update_limits()
#region Outbound debug
	if debug.outbound_move:
		self.limit_left = -100000
		self.limit_top = -100000
#endregion


func update_limits():
	if not debug.outbound_move:
		self.limit_right = player.world_map.size.x
		self.limit_bottom = player.world_map.size.y
	#print("Camera limits: ", self.limit_right, self.limit_bottom)
