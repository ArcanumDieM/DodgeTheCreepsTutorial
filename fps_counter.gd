extends Label

var TEXT_VALUE = "FPS: {counter}"

func _process(delta: float) -> void:
	var fps = int(1.0 / delta)
	# Update frame counter
	self.text = TEXT_VALUE.format({"counter": fps})
