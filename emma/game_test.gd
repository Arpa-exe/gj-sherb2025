extends Node2D

@onready var container = $CanvasLayer/HBoxContainer/HBoxContainer
@onready var nextLabel = $CanvasLayer/HBoxContainer/HBoxContainer/nextLabel
@onready var crystalUI = $CanvasLayer/HBoxContainer/HBoxContainer/TextureRect
@onready var crystal2UI = $CanvasLayer/HBoxContainer/HBoxContainer/TextureRect2
@onready var pauseMenu = $pauseMenu
var paused = false

func _ready() -> void:
	Global.currentLevel = "1"
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
				var currentArrayIndex = Global.powers.find("bing")
				moveChild(currentItem, currentArrayIndex)
			elif  power == "boing":
				var currentItem = crystalUI
				var currentArrayIndex = Global.powers.find("boing")
				moveChild(currentItem, currentArrayIndex)

func moveChild(currentItem, currentArrayIndex):
	currentArrayIndex = currentArrayIndex + 1
	container.move_child(currentItem, currentArrayIndex)
	currentItem.visible = true
	pass


func _on_continue_pressed() -> void:
	get_tree().paused = false
	pauseMenu.visible = false
	paused = false

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Global.mainMenuScene)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pauseMenu.visible = true
	paused = true
