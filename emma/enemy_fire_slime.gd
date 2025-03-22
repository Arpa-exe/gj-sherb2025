extends Node2D

var currentTarget = null
var currentTargetIndex = null

@onready var nav: NavigationAgent2D = $"../../NavigationAgent3D"
@onready var guardArea: Area2D = $"../../Area2D"
@onready var prisonGuard: CharacterBody3D = $"../.."

@export var patrolMarkers: Array[Marker2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var direction := Vector3()
	
	nav.target_position = marker.global_position
	
	direction = nav.get_next_path_position() - prisonGuard.global_position
	direction = direction.normalized()
	
	var speed = prisonGuard.walkingSpeed
	prisonGuard.velocity = prisonGuard.velocity.lerp(direction * speed, delta)
	prisonGuard.move_and_slide()
