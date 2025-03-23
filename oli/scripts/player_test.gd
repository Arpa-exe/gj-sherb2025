extends CharacterBody2D

var SPEED = 130.0
@export var walkSpeed = 130.0
@export var runSpeed = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var nextLabel = $"../CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer/nextLabel"
@onready var missing1 = $"../CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer/TextureRect"
@onready var missing2 = $"../CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer/TextureRect2"

@onready var missingLabel = $"../CanvasLayer/VBoxContainer/HBoxContainer/missingContainer/Label"
@onready var collectiblenode = $"../CanvasLayer/VBoxContainer/HBoxContainer/missingContainer"
@onready var collectibleUI = $"../CanvasLayer/VBoxContainer/HBoxContainer/missingContainer/TextureRect"
@onready var collectibleUI2 = $"../CanvasLayer/VBoxContainer/HBoxContainer/missingContainer/TextureRect2"
@onready var collectibleUI3 = $"../CanvasLayer/VBoxContainer/HBoxContainer/missingContainer/TextureRect3"

@onready var progressBar = $"../CanvasLayer/VBoxContainer/ProgressBar"
@onready var progressBarLabel = $"../CanvasLayer/VBoxContainer/ProgressBar/Label"

@onready var jump_ray: RayCast2D = $jump_ray
@onready var left_ray: RayCast2D = $left_ray
@onready var right_ray: RayCast2D = $right_ray

@onready var pauseMenu = $"../pauseMenu"

var paused = false
var is_boing = false
var alive = true
var damage = true
var can_wall = 0
var cooldown = 2 # 2 seconds before being able to be hit again
var timer_cooldown = 0
var collectibles

func _ready() -> void:
	Global.reset()
	Global.currentHealth = 4
	progressBarLabel.text = str("Health: ", Global.currentHealth, "/4")
	collectibles = [collectibleUI, collectibleUI2, collectibleUI3]
	SPEED = walkSpeed

func catch_crystal():
	Global.powers.push_back("boing")
	missing1.visible = true
	
func catch_dash_crystal():
	Global.powers.push_back("bing")
	missing2.visible = true

func _physics_process(delta: float) -> void:
	if timer_cooldown > 0:
		timer_cooldown -= delta
		if timer_cooldown <= 0:
			damage = true
	if alive:
		var on_wall = is_on_wall() and not is_on_floor()
		if on_wall:
			animated_sprite_2d.play("wall")
		if len(Global.collectibleLeft) == Global.collectibleCount:
			missingLabel.visible = false
		else:
			missingLabel.visible = true
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta * 1.5
		
		if Input.is_action_pressed("run"):
			SPEED = runSpeed
		else:
			SPEED = walkSpeed

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
			elif on_wall and can_wall <= 0:
				can_wall = 10
				velocity = Vector2(300 * get_wall_normal().x, -200)

		if Input.is_action_just_pressed("pause"):
			if paused == false:
				paused = true
				pauseMenu.visible = true
				get_tree().paused = true
			else:
				paused = false
				pauseMenu.visible = false
				get_tree().paused = false

		if Input.is_action_just_pressed("use_item") and len(Global.powers) > 0 and not is_boing:
			is_boing = true
			var next_power = Global.powers.pop_front()
			match next_power:
				"boing":
					spawn_beam()
					var tween = create_tween()
					if jump_ray.is_colliding():
						var dist = jump_ray.get_collision_point()
						dist = global_position.y - dist.y
						if dist > 0:
							print(dist)
							tween.tween_property(self, "global_position:y", global_position.y - dist, 0.1)
					else:
						tween.tween_property(self, "global_position:y", global_position.y - 48, 0.1)
					velocity.y = JUMP_VELOCITY
					missing1.visible = false
					is_boing = false
				"bing":
					var direction := Input.get_axis("move_left", "move_right")
					if direction == 0:
						Global.powers.push_front("bing")
						is_boing = false
						missing2.visible = false
						missing2.visible = true
					else:
						spawn_dash(direction)
						var tween = create_tween()
						if direction > 0:
							if right_ray.is_colliding():
								var dist = right_ray.get_collision_point()
								dist = global_position.x + dist.x
								tween.tween_property(self, "global_position:x", global_position.x + dist * direction, 0.2)
						elif left_ray.is_colliding():
							var dist = left_ray.get_collision_point()
							dist = global_position.x - dist.x
							tween.tween_property(self, "global_position:x", global_position.x + dist * direction, 0.2)
						else:
							tween.tween_property(self, "global_position:x", global_position.x + 80 * direction, 0.2)
						is_boing = false
						missing2.visible = false
				_:
					pass
			
		# Movement
		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite_2d.flip_h = false
		elif direction < 0:
			animated_sprite_2d.flip_h = true
		
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("IdleRight")
			else:
				animated_sprite_2d.play("Run")
		else:
			animated_sprite_2d.play("Jump")
		if can_wall > 0:
			can_wall -= 1
		elif direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
func spawn_beam():
	var beam = preload("res://oli/vertical_beam.tscn").instantiate()
	get_parent().add_child(beam)
	beam.global_position = global_position - Vector2(0, 20)
	
func spawn_dash(direction):
	var dash = preload("res://oli/light_dash.tscn").instantiate()
	get_parent().add_child(dash)
	dash.global_position = global_position - Vector2(40, 0)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("player hitbox ", area.get_parent())
	print("area: ", area)
	if (area.get_parent().get_parent().name == "Sign"):
		if Global.currentLevel == "1": # changed level 1 to 2 
			get_tree().change_scene_to_file(Global.level2Scene) # changed level 2 to 1
		elif Global.currentLevel == "2": # changed level 2 to 1
			get_tree().change_scene_to_file(Global.level3Scene)
		elif Global.currentLevel == "3":
			get_tree().change_scene_to_file(Global.endScene)
	elif area.get_parent().name == "Keys":
		print('collectibleCount: ', Global.collectibleCount)
		var count = Global.collectibleCount - 1
		collectibles[count].visible = false
		print('key')
	elif area.get_parent().name == "id":
		print('collectibleCount: ', Global.collectibleCount)
		var count = Global.collectibleCount - 1
		collectibles[count].visible = false
		print('id')
	elif area.get_parent().name == "mp3":
		print('collectibleCount: ', Global.collectibleCount)
		var count = Global.collectibleCount - 1
		collectibles[count].visible = false
		print('mp3')
	elif (area.get_parent().name == "enemyFireSlime"):
		takeHit(2)
	elif (area.get_parent().name == "enemySlime"):
		takeHit(1)
	elif area.get_parent().get_parent().get_parent() != null:
		if area.get_parent().get_parent().get_parent().name == "Spikes":
			takeHit(1)
	pass # Replace with function body.

func die():
	Global.currentHealth = 0
	var healthTween = create_tween()
	healthTween.tween_property(progressBar, "value", Global.currentHealth, 1)
	progressBarLabel.text = str("Health: ", Global.currentHealth, "/4")
	alive = false
	animated_sprite_2d.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.get_animation() == "die":
		get_tree().change_scene_to_file(Global.gameOverScene)


func _on_stomp_area_area_entered(area: Area2D) -> void:
	if (area.get_parent().name == "enemySlime"):
		area.get_parent().die()
	elif (area.get_parent().name == "enemyFireSlime"):
		takeHit(2)

func takeHit(damageLevel):
	if damage: 
		Global.currentHealth -= damageLevel
		var healthTween = create_tween()
		healthTween.tween_property(progressBar, "value", Global.currentHealth, 1)
		progressBarLabel.text = str("Health: ", Global.currentHealth, "/4")
		
		var redTween = create_tween()
		for n in 4:
			redTween.tween_property(animated_sprite_2d, "modulate", Color.MEDIUM_VIOLET_RED, 0.25)
			redTween.tween_property(animated_sprite_2d, "modulate", Color(1,1,1,1), 0.25)
			n = n+1
		if Global.currentHealth <= 0:
			animated_sprite_2d.animation = "Die"
			die()
		# Cooldown after hit gives player - 3 seconds before hit again 
		damage = false
		timer_cooldown = cooldown
		
func ending():
	animated_sprite_2d.play("end")
	alive = false
