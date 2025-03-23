extends Node2D

var currentTarget = null
var currentTargetIndex = null

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var enemySlime: CharacterBody2D = $"."
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var markers: Array[Marker2D] = []
@export var walkingSpeed = 30.0

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("roll")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive == true:
		var nextMarker = selectNextMarker()
		moveTowardsMarker(nextMarker, delta)

func selectNextMarker() -> Marker2D:
	if currentTargetIndex == null:
		currentTargetIndex = 0

	if nav.is_target_reached() or !nav.is_target_reachable():
		currentTargetIndex += 1
		if currentTargetIndex >= len(markers):
			currentTargetIndex = 0

	return markers[currentTargetIndex]

func moveTowardsMarker(marker, delta):
	var direction := Vector2()
	
	nav.target_position = marker.global_position
	
	direction = nav.get_next_path_position() - enemySlime.global_position
	direction = direction.normalized()
	if direction.x > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	var speed = enemySlime.walkingSpeed
	var tween = get_tree().create_tween()
	enemySlime.velocity = enemySlime.velocity.lerp(direction * speed, 1)
	enemySlime.move_and_slide()

func die():
	$Area2D.queue_free()
	$hitboxArea2D.queue_free()
	alive = false
	animated_sprite_2d.animation = "die"


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.get_animation() == "die":
		queue_free()
