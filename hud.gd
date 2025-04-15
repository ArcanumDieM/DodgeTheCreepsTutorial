extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

var game_started: bool = false
var settings_menu: PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu = $MenuButton.get_popup()
	settings_menu.set_hide_on_checkable_item_selection(false)


func show_message(text, start_timer: bool = true):
	$Message.text = text
	$Message.show()
	if start_timer:
		$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$MessageTimer.stop()

	show_message("Dodge the Creeps!", false)
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$MenuButton.show()
	game_started = false
	

func update_score(score):
	$ScoreLabel.text = str(score)


func update_lifebar(current_value: float):
	$LifeBar.value = current_value


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	game_started = true


func _on_message_timer_timeout() -> void:
	$Message.hide()
	$MessageTimer.stop()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("exit_fullscreen"):
		if settings_menu.is_item_checked(5):	# id and index match so far
			print("Exit fullscreen")
			settings_menu.id_pressed.emit(5)
		
		if event.is_pressed() and $MenuButton.visible:
			if settings_menu.visible:
				settings_menu.hide()
			else:
				settings_menu.popup()
	
	if game_started and event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			show_message("PAUSE", false)
		else:
			$Message.hide()
