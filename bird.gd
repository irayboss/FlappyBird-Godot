extends CharacterBody2D

class_name Bird

signal game_started

@export var gravity = 900.0
@export var jump_force = -300
@export var rotation_speed = 2 

@onready var animation_player = $AnimationPlayer

var max_speed = 400
var is_started = false
var should_process_input = true


func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && should_process_input:
		animation_player.play("flap_wings")
		jump()
		
	if !is_started:
		return
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y,max_speed)
	
	move_and_collide(velocity * delta) 
	
	rotate_bird()

func jump():
	if !is_started:
		is_started = true
		game_started.emit()
		
	velocity.y = jump_force
	rotation = deg_to_rad(-30)

func rotate_bird():
	if velocity.y > 0 && deg_to_rad(rotation) < 90:  
		rotation += rotation_speed * deg_to_rad(1)
	elif velocity.y < 0 && deg_to_rad(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)

func kill(): 
	should_process_input = false

func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
	
