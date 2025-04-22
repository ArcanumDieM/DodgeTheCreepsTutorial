extends CheckButton

signal light_change(light_on: bool)

var sun
var moon
var transparency_value = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sun = get_tree().root.get_node("Main/HUD/LightPanel/SunIcon")
	moon = get_tree().root.get_node("Main/HUD/LightPanel/MoonIcon")
	change_icons()


func change_icons():
	if self.button_pressed:
		#print("Moon ", moon.material)
		moon.material.set_shader_parameter("transparency", 1.0)
		sun.material.set_shader_parameter("transparency", transparency_value)
	else:
		#print("Sun ", sun.material)
		sun.material.set_shader_parameter("transparency", 1.0)
		moon.material.set_shader_parameter("transparency", transparency_value)
	
	light_change.emit(not self.button_pressed)


func _on_toggled(toggled_on: bool) -> void:
	change_icons()
