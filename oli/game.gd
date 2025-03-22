extends Node2D

@onready var nextLabel = $CanvasLayer/HBoxContainer/nextLabel
@onready var crystalUI = $CanvasLayer/HBoxContainer/TextureRect
@onready var crystal2UI = $CanvasLayer/HBoxContainer/TextureRect2


func _ready() -> void:
	if len(Global.powers) == 0:
		nextLabel.text = str("No power picked up")
	else:
		nextLabel.text = str("Next power: ")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.powers)
	if len(Global.powers) == 0:
		nextLabel.text = str("No power picked up")
	else:
		nextLabel.text = str("Next power: ")
		for power in Global.powers:
			if power == "bing":
				var currentItem = crystal2UI
				var currentIndex = crystal2UI.get_index()
				moveChild(currentItem, currentIndex)
			elif  power == "boing":
				var currentItem = crystalUI
				var currentIndex = crystalUI.get_index()
				moveChild(currentItem, currentIndex)

func moveChild(currentItem, currentIndex):
	move_child(currentItem, currentIndex + 1)
	currentItem.visible = true
	pass
