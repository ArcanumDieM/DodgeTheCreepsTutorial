extends Node

func _on_outbound_body_entered(body: Node2D) -> void:
	#print(typeof(body))
	body.queue_free()
