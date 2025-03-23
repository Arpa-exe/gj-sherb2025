extends Node

var powers = []
var collectibleLeft = []
var collectibleCount = 0
var currentLevel
var currentHealth

var level1Scene = "res://jade-murtaza/Level1/World/Level1.tscn"
var level2Scene = "res://jade-murtaza/Level3/world/Level3.tscn"
var level3Scene = "res://jade-murtaza/Level2/world/Level2Water.tscn"
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
	collectibleCount = 0
	if currentLevel != null:
		if currentLevel == "1":
			collectibleLeft = ["key", "key", "key"]
		elif currentLevel == "2":
			collectibleLeft = ["card"]
		elif currentLevel == "3":
			collectibleLeft = ["mp3"]
