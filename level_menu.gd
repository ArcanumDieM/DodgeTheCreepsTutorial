extends Control

signal level_selected(level_id: int)

var closing = false


func _ready() -> void:
	hide()


func open_menu():
	show()
	$AnimationPlayer.play("opening")

func close_menu():
	closing = true
	$AnimationPlayer.play("opening", -1.0, -2.0, true)


func _on_animation_finished(anim_name: StringName) -> void:
	if closing and anim_name == "opening":
		closing = false
		hide()
	
	
func _on_close_button_pressed() -> void:
	close_menu()


#region Level buttons clicks
func _on_level_1_pressed() -> void:
	print("Level 1")
	level_selected.emit(1)
	close_menu()

func _on_level_2_pressed() -> void:
	print("Level 2")
	level_selected.emit(2)
	close_menu()

func _on_level_3_pressed() -> void:
	print("Level 3")
	level_selected.emit(3)
	close_menu()
#endregion
