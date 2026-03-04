extends CharacterBody2D
@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300
@export var bullet_scene : PackedScene
enum {IDLE, RUN, JUMP, HURT, DEAD}
var state = IDLE
signal life_changed
signal died


func _ready():
	change_state(IDLE)
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("walk")
		JUMP:
			$AnimationPlayer.play("jump")
		HURT:
			$AnimationPlayer.play("hurt")
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
	
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
		DEAD:
			died.emit()
			hide()
func get_input():
	#if state == HURT:
		#return
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	# movement occurs in all states
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	# only allow jumping when on the ground
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	# IDLE transitions to RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN transitions to IDLE when standing still
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# transition to JUMP when in the air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	if Input.is_action_pressed("shoot"):
		shoot()
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump")
func shoot():
	

	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)









#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
#func get_input():
	##if state == HURT:
		##return
#
	#var right = Input.is_action_pressed("right")
	#var left = Input.is_action_pressed("left")
	#var jump = Input.is_action_just_pressed("jump")
	## movement occurs in all states
	#velocity.x = 0
	#if right:
		#velocity.x += SPEED
		#$Sprite2D.flip_h = false
	#if left:
		#velocity.x -= SPEED
		#$Sprite2D.flip_h = true
	## only allow jumping when on the ground
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#$AnimationPlayer.play("jump")
		#velocity.y = JUMP_VELOCITY
		#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#move_and_slide()
