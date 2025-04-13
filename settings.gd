extends Node

enum GameDifficulty {
	EASY, NORMAL, HARD
}

# Menu object
var settings_menu: PopupMenu
var difficulty_callback: Callable

# Settings variable
var music_volume: int
var difficulty: GameDifficulty

func _init(
	settings_menu: PopupMenu, difficulty_callback: Callable,
	default_volume: int = 100, 
	default_difficulty: GameDifficulty = GameDifficulty.NORMAL
) -> void:
	self.settings_menu = settings_menu
	self.difficulty_callback = difficulty_callback
	self.music_volume = default_volume
	self.difficulty = default_difficulty
	
	self.settings_menu.id_pressed.connect(manage_settings)

	
func manage_settings(id: int):
	#print("ID: ", id)
	var index = settings_menu.get_item_index(id)
	if id > 1 and id < 5:
		settings_menu.set_item_checked(settings_menu.get_item_index(2), false)
		settings_menu.set_item_checked(settings_menu.get_item_index(3), false)
		settings_menu.set_item_checked(settings_menu.get_item_index(4), false)
		match id:
			2: difficulty = GameDifficulty.EASY
			3: difficulty = GameDifficulty.NORMAL
			4: difficulty = GameDifficulty.HARD
		settings_menu.set_item_checked(index, true)
		self.difficulty_callback.call(difficulty)
	elif id == 5:
		var is_previously_checked = settings_menu.is_item_checked(index)
		settings_menu.set_item_checked(index, not is_previously_checked)
		if settings_menu.is_item_checked(index):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
