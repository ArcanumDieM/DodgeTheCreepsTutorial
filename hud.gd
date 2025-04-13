extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

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

	show_message("Dodge the Creeps!", false)
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$MenuButton.show()
	

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("exit_fullscreen"):
		if settings_menu.is_item_checked(5):	# id and index match so far
			print("Exit fullscreen")
			settings_menu.id_pressed.emit(5)
