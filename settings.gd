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
var music_volume: float
var difficulty: GameDifficulty
var framerate_cap: int = 0
var config: ConfigFile


func _init(hud: Node) -> void:
	self.settings_hud = hud
	self.settings_menu = self.settings_hud.settings_menu
	self.volume_popup = self.settings_hud.get_node("VolumePopup")
	
	self.settings_menu.id_pressed.connect(manage_settings)
	self.volume_popup.get_node("ConfirmVolumeButton").pressed.connect(_on_confirm_volume_button_pressed)


func load_configuration():
	var saved_config = ConfigFile.new()
	var load_err = saved_config.load("user://settings.cfg")
	
	if load_err != OK:
		print("Missing save file. Creating a new one.")
		# Default values
		self.config = ConfigFile.new()
		self.config.set_value("music", "volume", 0.8)
		self.config.set_value("game", "difficulty", GameDifficulty.NORMAL)
		self.config.save("user://settings.cfg")
	else:
		print("Loading save file.")
		# Load file
		self.config = saved_config
	self.music_volume = self.config.get_value("music", "volume")
	self.difficulty = self.config.get_value("game", "difficulty")
	if self.difficulty not in GameDifficulty.values():
		print_rich("[color=red]Invalid game setting! Difficulty = ", self.difficulty)
		self.difficulty = GameDifficulty.NORMAL
	
	self.framerate_cap = self.config.get_value("game", "framerate", 0)
	if self.framerate_cap != null and self.framerate_cap > 24:
		Engine.max_fps = self.framerate_cap
	
	volume_popup.get_node("VolumeSlider").value = self.music_volume * 100.0
	volume_changed.emit(self.music_volume)
	var id = self.difficulty + 2
	manage_difficulty_setting(id, id)


func save_configuration():
	self.config.set_value("music", "volume", self.music_volume)
	self.config.set_value("game", "difficulty", self.difficulty)
	self.config.set_value("game", "framerate", self.framerate_cap)
	var save_msg = "[color=green]Saving configuration: music: {mv}, difficulty: {gd}".format(
		{"mv": self.music_volume, "gd": self.difficulty}
	)
	print_rich(save_msg)
	self.config.save("user://settings.cfg")

	
func manage_settings(id: int):
	#print("ID: ", id)
	var index = settings_menu.get_item_index(id)
	if id == 0:
		volume_popup.show()
	elif id > 1 and id < 5:
		#region Difficulty settings
		manage_difficulty_setting(id, index)
		save_configuration()
		#endregion
	elif id == 5:
		#region Fullscreen settings
		var is_previously_checked = settings_menu.is_item_checked(index)
		settings_menu.set_item_checked(index, not is_previously_checked)
		if settings_menu.is_item_checked(index):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#endregion
	elif id == 6:
		#region Framerate settings
		var is_previously_checked = settings_menu.is_item_checked(index)
		settings_menu.set_item_checked(index, not is_previously_checked)
		if is_previously_checked:
			self.framerate_cap = 0		# disable framrate cap
		else:
			self.framerate_cap = 60		# set framerate cap
		Engine.max_fps = self.framerate_cap
		save_configuration()
		#endregion

func manage_difficulty_setting(id: int, index: int):
	settings_menu.set_item_checked(settings_menu.get_item_index(2), false)
	settings_menu.set_item_checked(settings_menu.get_item_index(3), false)
	settings_menu.set_item_checked(settings_menu.get_item_index(4), false)
	match id:
		2: self.difficulty = GameDifficulty.EASY
		3: self.difficulty = GameDifficulty.NORMAL
		4: self.difficulty = GameDifficulty.HARD
	settings_menu.set_item_checked(index, true)
	difficulty_changed.emit(self.difficulty)


func _on_confirm_volume_button_pressed():
	volume_popup.hide()
	self.music_volume = volume_popup.get_node("VolumeSlider").value / 100.0
	volume_changed.emit(self.music_volume)
	save_configuration()
