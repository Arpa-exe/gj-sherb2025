extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	Global.reset()
	if Global.currentLevel == "Level1": 
		get_tree().change_scene_to_file(Global.level1Scene)
	elif Global.currentLevel == "Level2": 
		get_tree().change_scene_to_file(Global.level2Scene)
	else:
		get_tree().change_scene_to_file(Global.level3Scene)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(Global.mainMenuScene)


func _on_quit_pressed() -> void:
	get_tree().quit()
