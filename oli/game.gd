extends Node2D

@onready var nextLabel = $CanvasLayer/HBoxContainer/HBoxContainer/nextLabel
@onready var crystalUI = $CanvasLayer/HBoxContainer/HBoxContainer/TextureRect
@onready var crystal2UI = $CanvasLayer/HBoxContainer/HBoxContainer/TextureRect2
@onready var pauseMenu = $pauseMenu
var paused = false

func _ready() -> void:
	pauseMenu.visible = false
	if len(Global.powers) == 0:
		nextLabel.text = str("No power picked up")
	else:
		nextLabel.text = str("Next power: ")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused == false:
			paused = true
			pauseMenu.visible = true
			get_tree().paused = true
		else:
			paused = false
			pauseMenu.visible = false
			get_tree().paused = false

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


func _on_continue_pressed() -> void:
	get_tree().paused = false
	pauseMenu.visible = false
	paused = false

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://emma/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pauseMenu.visible = true
	paused = true
