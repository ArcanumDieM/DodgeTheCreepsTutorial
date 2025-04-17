extends Area2D

signal hit
signal dead

@export var speed: float = 400.0 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@export var lifesize = 10.0
@onready var life: float = lifesize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	velocity.x += Input.get_axis("move_left", "move_right")
	velocity.y += Input.get_axis("move_up", "move_down")

	if velocity.length() > 0:
		var angle = velocity.angle()
		velocity.x *= abs(cos(angle))
		velocity.y *= abs(sin(angle))
		velocity *= speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	self.position += velocity * delta
	self.position = self.position.clamp(Vector2.ZERO, screen_size)

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
