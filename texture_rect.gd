extends TextureRect


var mouse_in = false
var speed_rotation = PI / 3.0


func _on_menu_button_mouse_entered() -> void:
	self.self_modulate = Color("#4f4f4f")
	mouse_in = true


func _on_menu_button_mouse_exited() -> void:
	self.self_modulate = Color("#ffffff")
	mouse_in = false


func _process(delta: float) -> void:
	if mouse_in:
		# rotate the icon when mouse hover it	
		self.rotation += speed_rotation * delta
	else:
		self.rotation = 0.0
