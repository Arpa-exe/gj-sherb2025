extends Node

var powers = []
var collectibleLeft = []
var currentLevel

var level1Scene = "res://emma/gameTest.tscn"
var level2Scene = "res://emma/gameTest.tscn"
var level3Scene = "res://emma/gameTest.tscn"
var endScene = "res://emma/gameTest.tscn"

var controlScene = "res://emma/controls.tscn"
var mainMenuScene = "res://emma/main_menu.tscn"
var gameOverScene = "res://emma/gameOver.tscn"
var pauseScene = "res://emma/pause_menu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	powers = []
	if currentLevel != null:
		if currentLevel == "1":
			collectibleLeft = ["id"]
		elif currentLevel == "2":
			collectibleLeft = ["key"]
		elif currentLevel == "3":
			collectibleLeft = ["mp3"]
