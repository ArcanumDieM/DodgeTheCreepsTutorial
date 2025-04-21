class_name MobScene

extends CharacterBody2D


var initial_velocity: Vector2
var initial_direction: float
var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass


func _physics_process(delta: float) -> void:
	if spawned:
		move_and_slide()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("obstacles"):
		var direction = self.initial_direction + (PI / 4)
		var velocity = self.initial_velocity.rotated(direction)
		#print("Mob {mob} from {rot} to {dir} with velocity {vel}".format(
			#{"mob": self, "rot": rad_to_deg(self.rotation), "dir": rad_to_deg(direction), "vel": self.linear_velocity}
		#))
		self.rotation = direction
		self.linear_velocity = velocity
		
