extends CharacterBody2D

signal hit
signal dead

@export var speed: float = 400.0 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@export var lifesize = 10.0
@onready var life: float = lifesize

# Variable for PlayerCamera
@export var world_map: ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2.ZERO # The player's movement vector.
	
	vel.x += Input.get_axis("move_left", "move_right")
	vel.y += Input.get_axis("move_up", "move_down")

	if vel.length() > 0:
		var angle = vel.angle()
		vel.x *= abs(cos(angle))
		vel.y *= abs(sin(angle))
		vel *= speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#self.position += velocity * delta
	self.velocity = vel
	self.move_and_slide()
	if not debug.outbound_move:
		self.position = self.position.clamp(Vector2.ZERO, world_map.size)

	# Change animation
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func start(pos):
	position = pos
	life = lifesize
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		print("hit")
		hide() # Player disappears after being hit.
		life -= 1
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		if life <= 0:
			dead.emit()
		else:
			$InvincibleTimer.start()


func _on_invincible_timer_timeout() -> void:
	$InvincibleTimer.stop()
	$CollisionShape2D.disabled = false
	show()
