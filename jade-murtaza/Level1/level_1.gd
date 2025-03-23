extends Node2D


@onready var pauseMenu = $pauseMenu

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.currentLevel = "1"
	Global.reset()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	pauseMenu.visible = false
	paused = false


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Global.mainMenuScene)


func _on_quit_pressed() -> void:
	get_tree().quit()
