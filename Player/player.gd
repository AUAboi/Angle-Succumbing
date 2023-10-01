extends CharacterBody2D

class_name Player

@export var speed: float = 80
@export var acceleration: float = 400.0
@export var friction: float = 600.0

@onready var weapon: Node = $Staff
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox

var movement: Vector2 = Vector2.ZERO

var stats  = PlayerStats

var dash: Node = load_skill("dash")

func _ready():
	Global.Player = self
	animatedSprite.play("default")
	stats.no_health.connect(queue_free)
	

func _physics_process(delta: float):
	var mouse_position: Vector2 = get_global_mouse_position()
	handle_movement(delta)
	handle_shooting(mouse_position)
	
	if Input.is_action_just_pressed("dash"):
		dash.execute(self, mouse_position)
		
	move_and_slide()

func handle_movement(delta: float):
	var input_vector: Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
				

func handle_shooting(mouse_position: Vector2):
	weapon.muzzle.look_at(mouse_position)
	if Input.is_action_just_pressed("shoot"):
		weapon.shoot()
	if mouse_position.x > position.x:
		animatedSprite.flip_h = false
	elif mouse_position.x < position.x:
		animatedSprite.flip_h = true



func _on_hurtbox_area_entered(area: Area2D):
	if !hurtbox.invincible:
		stats.health -= 1
		hurtbox.create_hit_effect()
		hurtbox.start_invincibilty(0.5)

func load_skill(skillName: String):
	var scene: PackedScene = load("res://Skills/"+ skillName +"/"+ skillName +".tscn")
	var node: Node = scene.instantiate()
	add_child(node)
	return node
