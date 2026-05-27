extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var hitbox_colision: CollisionShape2D = $HITBOX/CollisionShape2D
@onready var healthbar = $CanvasLayer/HealthBar
@onready var jumpSFX = $jumpSFX as AudioStreamPlayer2D
const GameOverScreen = preload("uid://r32ycnp1u604")

var health: int = 6:
	set = _set_health
var game_over_screen_ref: CanvasLayer = null

enum PlayerState {
	idle,
	walk,
	jump,
	falling,
	dead,
	hurt,
}

@export var MAX_SPEED: float = 150.0
@export var acceleration: float = 400.0
@export var deceleration: float = 400.0
const JUMP_VELOCITY: float = -300.0
var direction = 0
var jump_count: float = 0
@export var max_jump_count: float = 2
var status = PlayerState
@onready var reload_timer: Timer = $ReloadTimer
var death_on_jump_counter: float = 0
var blocked = false

func _ready() -> void:
	health = 5
	go_to_idle_state()
	healthbar.ini_health(health)
	anim.connect("frame_changed", Callable(self, "_on_anim_frame_changed"))

func _set_health(value):
	health = value
	if health <= 0 and status != PlayerState.dead:
		go_to_dead_state()
	if is_inside_tree():
		healthbar.health = health

func _physics_process(delta: float) -> void:
	if get_tree().paused or blocked:
		$AnimatedSprite2D.play("idle")
		return
	if Input.is_action_pressed("down"):
		set_collision_mask_value(8, false)
	else:
		set_collision_mask_value(8, true)

	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.falling:
			falling_state(delta)
		PlayerState.dead:
			dead_state(delta)
		PlayerState.hurt:
			hurt_state(delta)

	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	jumpSFX.play()

func go_to_falling_state():
	status = PlayerState.falling
	anim.play("falling")

func go_to_dead_state():
	if status == PlayerState.dead:
		return
	status = PlayerState.dead
	anim.play("dead")
	velocity.x = 0
	game_over_screen_ref = GameOverScreen.instantiate()
	get_tree().get_root().add_child(game_over_screen_ref)
	reload_timer.start()
	if hitbox_colision:
		hitbox_colision.set_deferred("disabled", true)
	if colision:
		colision.set_deferred("disabled", true)

func go_to_hurt_state():
	if status == PlayerState.hurt or status == PlayerState.dead:
		return
	health -= 1
	status = PlayerState.hurt
	anim.play("hurt")
	velocity.y = -200
	await get_tree().create_timer(0.25).timeout
	if status == PlayerState.dead:
		return
	if is_on_floor():
		if abs(velocity.x) < 1:
			go_to_idle_state()
		else:
			go_to_walk_state()
	else:
		go_to_falling_state()

func idle_state(delta:):
	move(delta)
	apply_gravity(delta)
	if Input.is_action_just_pressed("up"):
		go_to_jump_state()
		return
	if velocity.x != 0:
		go_to_walk_state()
		return

func walk_state(delta:):
	move(delta)
	apply_gravity(delta)
	not_on_floor()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("up"):
		go_to_jump_state()
		return

func jump_state(delta:):
	move(delta)
	apply_gravity(delta)
	if Input.is_action_just_pressed("up") && jump_check():
		go_to_jump_state()
		return
	if velocity.y > 0:
		go_to_falling_state()
		return

func falling_state(delta:):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("up") && jump_check():
		go_to_jump_state()
		return
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

func dead_state(delta:):
	apply_gravity(delta)

func hurt_state(delta:):
	apply_gravity(delta)

func not_on_floor():
	if not is_on_floor() and velocity.y > 0:
		jump_count += 1
		go_to_falling_state()
		return

func jump_check():
	return jump_count < max_jump_count

func move(delta:):
	update_direction()
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func update_direction():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	death_on_jump_counter += 1
	if body.is_in_group("lethal_area") && death_on_jump_counter == 1:
		go_to_hurt_state()
		return

func hit_lethalarea(_area: Area2D):
	go_to_hurt_state()
	return

func _on_reload_timer_timeout() -> void:
	if game_over_screen_ref:
		game_over_screen_ref.queue_free()
		game_over_screen_ref = null
	get_tree().reload_current_scene()
