extends Node

func _on_outbound_body_entered(body: Node2D) -> void:
	#print(typeof(body), " Entered outbound. Is mob:", body.is_in_group("mobs"))
	body.queue_free()
