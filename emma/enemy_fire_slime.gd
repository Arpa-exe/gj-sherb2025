extends Node2D

var currentTarget = null
var currentTargetIndex = null

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var enemyFire: CharacterBody2D = $"."
@onready var animationSprite = $AnimatedSprite2D

@export var markers: Array[Marker2D] = []
@export var walkingSpeed = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nextMarker = selectNextMarker()
	moveTowardsMarker(nextMarker, delta)

func selectNextMarker() -> Marker2D:
	if currentTargetIndex == null:
		currentTargetIndex = 0

	if nav.is_target_reached() or !nav.is_target_reachable():
		print("hello")
		currentTargetIndex += 1
		if currentTargetIndex >= len(markers):
			currentTargetIndex = 0

	return markers[currentTargetIndex]

func moveTowardsMarker(marker, delta):
	var direction := Vector2()
	
	nav.target_position = marker.global_position
	
	direction = nav.get_next_path_position() - enemyFire.global_position
	direction = direction.normalized()
	if direction.x > 0:
		animationSprite.flip_h = true
	else:
		animationSprite.flip_h = false
	
	var speed = enemyFire.walkingSpeed
	var tween = get_tree().create_tween()
	enemyFire.velocity = enemyFire.velocity.lerp(direction * speed, 1)
	enemyFire.move_and_slide()
