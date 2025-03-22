extends Node2D

var currentTarget = null
var currentTargetIndex = null

@onready var patrolMarkers: Array[Marker2D] = $"../..".patrolMarkers
@onready var nav: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var guardArea: Area3D = $"../../Area3D"
@onready var prisonGuard: CharacterBody3D = $"../.."
@onready var prisoner:Node3D = prisonGuard.prisoner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var nextMarker = selectNextMarker()
	moveTowardsMarker(nextMarker, _delta)

func selectNextMarker() -> Marker2D:
	if currentTargetIndex == null:
		currentTargetIndex = 0

	if nav.is_target_reached() or !nav.is_target_reachable():
		currentTargetIndex += 1
		if currentTargetIndex >= len(patrolMarkers):
			currentTargetIndex = 0

	return patrolMarkers[currentTargetIndex]
