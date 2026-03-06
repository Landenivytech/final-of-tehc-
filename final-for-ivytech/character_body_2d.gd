extends CharacterBody2D

@export var speed = 50
@export var gravity = 900

var facing = 1

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = facing * speed
	$Sprite2D.flip_h = velocity.x > 0
