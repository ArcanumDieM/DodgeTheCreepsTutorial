class_name MobScene

extends CharacterBody2D

const VERY_LOW_SPEED = 0.01
const MAX_LIFE_TIME = 60000

var mob_type: String

var initial_velocity: Vector2
var initial_direction: float
var spawned = false
var spawn_time: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	self.mob_type = mob_types.pick_random()
	$AnimatedSprite2D.animation = self.mob_type
	$AnimatedSprite2D.play()
	if mob_type == "fly":
		self.set_collision_layer_value(3, false)
		self.set_collision_mask_value(1, false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass


func _physics_process(delta: float) -> void:
	if self.velocity.length() < VERY_LOW_SPEED:
		print("ERROR: Very low speed!")
		
	if spawned:
		var collision = move_and_collide(self.velocity * delta)
		if collision != null and collision.get_collider().is_in_group("obstacles"):
			var previous_velocity = self.velocity
			self.velocity = self.velocity.bounce(collision.get_normal())
			var difference = self.velocity - previous_velocity
			if difference.length() < 10:
				print("WARN: Direction not changed so much. ", previous_velocity, self.velocity)
			self.rotation = self.velocity.angle()
		# Safety kill in case of blocked mob
		if Time.get_ticks_msec() - spawn_time > MAX_LIFE_TIME:
			queue_free()
