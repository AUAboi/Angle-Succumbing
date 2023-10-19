extends CharacterBody2D

class_name Player

@export var speed: float = 80
@export var acceleration: float = 400.0
@export var friction: float = 600.0

@onready var weapon: Node = $Staff
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox

var movement: Vector2 = Vector2.ZERO

var stats  = PlayerStats

var skill: Node = load_ability("dash", "skills")
var super_attack: Node = load_ability("death_curse", "supers")

func _ready() -> void:
	Global.Player = self
	animated_sprite.play("default")
	stats.no_health.connect(queue_free)

func _physics_process(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	handle_movement(delta)
	handle_aim(mouse_position)
	
	if Input.is_action_just_pressed("dash"):
		skill.execute(self, mouse_position)
	
	if Input.is_action_just_pressed("alt_ability"):
		super_attack.execute()
	
	move_and_slide()

func handle_movement(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
				

func handle_aim(mouse_position: Vector2) -> void:
	weapon.muzzle.look_at(mouse_position)
	
	if mouse_position.x > position.x:
		animated_sprite.flip_h = false
	elif mouse_position.x < position.x:
		animated_sprite.flip_h = true

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	if !hurtbox.invincible:
		stats.health -= 1
		hurtbox.create_hit_effect()
		hurtbox.start_invincibilty(0.5)

func load_ability(abilityName: String, abilityType: String)  -> Node:
	var Scene: PackedScene = load("res://"+ abilityType.capitalize() +"/"+ abilityName +"/"+ abilityName +".tscn")
	var node: Node = Scene.instantiate()
	add_child(node)
	return node


