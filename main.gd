extends Node

const Settings = preload("res://settings.gd")
var settings_container: Settings

@export var mob_scene: PackedScene
var score
var score_increment

var LEVEL_1 = GameLevel.new(1, Color("a8afbf"), Vector2(480, 720), Vector2(240, 450))
var LEVEL_2 = GameLevel.new(1, Color("769f5f"), Vector2(600, 900), Vector2(300, 500))
var LEVEL_3 = GameLevel.new(1, Color("59a4ce"), Vector2(720, 1080), Vector2(360, 540))

var current_level: GameLevel = LEVEL_1
var hit_color = Color("#e6806a")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to settings menu
	settings_container = Settings.new($HUD)
	score_increment = 10
	
	settings_container.difficulty_changed.connect(_on_difficulty_changed)
	settings_container.volume_changed.connect(_on_hud_volume_changed)
	
	settings_container.load_configuration()
	settings_container.open_level_selector.connect(open_level_selector_window)


func _on_player_hit() -> void:
	$ColorRect.color = hit_color
	$ColorRect/ColorTimer.start()
	score -= score_increment
	$HUD.update_score(score)
	$HUD.update_lifebar($Player.life)


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	# Stop the music
	$Music.stop()
	$DeathSound.play()


func new_game():
	# Clear enemies from the previous games
	get_tree().call_group("mobs", "queue_free")
	
	# Setup the new game
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# Update HUD
	$HUD.update_score(score)
	$HUD.update_lifebar($Player.life)
	$HUD.show_message("Get Ready")
	$HUD.get_node("MenuButton").hide()
	# Start the music
	$Music.play()

# Mob spawning
func _on_mob_timer_timeout() -> void:
	#print(Time.get_ticks_msec())
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	

func _on_score_timer_timeout() -> void:
	# Increment score
	score += score_increment
	$HUD.update_score(score)
	

func _on_start_timer_timeout() -> void:
	# Start other timers
	$MobTimer.start()
	$ScoreTimer.start()


func _on_difficulty_changed(difficulty: Settings.GameDifficulty):
	print("Difficulty set to ", difficulty)
	match difficulty:
		Settings.GameDifficulty.EASY: 
			$MobTimer.wait_time = 1.0
			score_increment = 5
		Settings.GameDifficulty.NORMAL: 
			$MobTimer.wait_time = 0.5
			score_increment = 10
		Settings.GameDifficulty.HARD: 
			$MobTimer.wait_time = 0.3
			score_increment = 20


func _on_hud_volume_changed(new_value: float) -> void:
	settings_container.music_volume = new_value
	#print(new_value, " -> ", linear_to_db(new_value))
	#print($Music.volume_db, " -> ", db_to_linear($Music.volume_db))
	$Music.volume_linear = new_value
	$DeathSound.volume_linear = new_value


func _on_color_timer_timeout() -> void:
	$ColorRect/ColorTimer.stop()
	$ColorRect.color = current_level.background_color


func open_level_selector_window():
	$MenuLayer/LevelMenu.open_menu()


func _on_level_menu_level_selected(level_id: int) -> void:
	match level_id:
		1: 
			print("Loading level 1")
			current_level = LEVEL_1
		2: 
			print("Loading level 2")
			current_level = LEVEL_2
		3: 
			print("Loading level 3")
			current_level = LEVEL_3

	$ColorRect.color = current_level.background_color
	$ColorRect.size = current_level.size
	$StartPosition.position = current_level.starting_pos
	# Increase World border
	$ColorRect/WorldBorder.points[1].x = current_level.size.x
	$ColorRect/WorldBorder.points[2].x = current_level.size.x
	$ColorRect/WorldBorder.points[2].y = current_level.size.y
	$ColorRect/WorldBorder.points[3].y = current_level.size.y
	# Update mob spawn path
	$MobPath.curve.set_point_position(1, Vector2(current_level.size.x, 0.0))
	$MobPath.curve.set_point_position(2, Vector2(current_level.size.x, current_level.size.y))
	$MobPath.curve.set_point_position(3, Vector2(0.0, current_level.size.y))
	
	$WorldOutbound/Area2D/SouthWall.position.y = current_level.size.y + 100
	$WorldOutbound/Area2D/RightWall.position.x = current_level.size.x + 100
	$Player/PlayerCamera.update_limits()


class GameLevel:
	var id
	var background_color
	var size
	var starting_pos
	
	func _init(id, color, size, start_pos) -> void:
		self.id = id
		self.background_color = color
		self.size = size
		self.starting_pos = start_pos
