extends Node

var powers = []
var powersLeft = ["bing", "boing"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	powers = []
	powersLeft = ["bing", "boing"]
