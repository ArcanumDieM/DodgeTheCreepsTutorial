extends Node

enum GameDifficulty {
	EASY, NORMAL, HARD
}

signal difficulty_changed(new_value: GameDifficulty)
signal volume_changed(new_value: float)

# Menu object
var settings_hud: Node
var settings_menu: PopupMenu
var volume_popup: Popup

# Settings variable
var music_volume: int
var difficulty: GameDifficulty

func _init(
	settings_hud: Node,
	default_volume: int = 100, 
	default_difficulty: GameDifficulty = GameDifficulty.NORMAL
) -> void:
	self.settings_hud = settings_hud
	self.settings_menu = self.settings_hud.settings_menu
	self.volume_popup = self.settings_hud.get_node("VolumePopup")
	
	self.music_volume = default_volume
	self.difficulty = default_difficulty
	
	self.settings_menu.id_pressed.connect(manage_settings)
	self.volume_popup.get_node("ConfirmVolumeButton").pressed.connect(_on_confirm_volume_button_pressed)
	

func manage_settings(id: int):
	#print("ID: ", id)
	var index = settings_menu.get_item_index(id)
	if id == 0:
		volume_popup.show()
	elif id > 1 and id < 5:
		settings_menu.set_item_checked(settings_menu.get_item_index(2), false)
		settings_menu.set_item_checked(settings_menu.get_item_index(3), false)
		settings_menu.set_item_checked(settings_menu.get_item_index(4), false)
		match id:
			2: difficulty = GameDifficulty.EASY
			3: difficulty = GameDifficulty.NORMAL
			4: difficulty = GameDifficulty.HARD
		settings_menu.set_item_checked(index, true)
		difficulty_changed.emit(difficulty)
	elif id == 5:
		var is_previously_checked = settings_menu.is_item_checked(index)
		settings_menu.set_item_checked(index, not is_previously_checked)
		if settings_menu.is_item_checked(index):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_confirm_volume_button_pressed():
	volume_popup.hide()
	var volume_value = volume_popup.get_node("VolumeSlider").value / 100.0
	volume_changed.emit(volume_value)
