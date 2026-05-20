extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.0

@export var footsteps_sfx : AudioStreamPlayer3D
@export var jump_sfx : AudioStreamPlayer3D
@export var land_sfx : AudioStreamPlayer3D

@onready var mesh: MeshInstance3D = $Mesh

var step_timer := 0.0
var was_on_floor : bool = true


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	mesh.visible = false


func _input(event: InputEvent) -> void:
	# Mouse Look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		$AimHelper.rotate_x(Globals.invert_y_to_int() * \
							Globals.mouse_sensitivity * \
							Globals.zoom_sensitibity * event.relative.y)
		$AimHelper.rotation.x = clamp($AimHelper.rotation.x, \
										-deg_to_rad(89), deg_to_rad(89))
		rotate_y(-Globals.mouse_sensitivity * Globals.zoom_sensitibity * \
															event.relative.x)
		rotation.z = 0

	if Input.is_action_just_pressed("Pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if velocity and is_on_floor():
		step_timer += delta
		if fmod(step_timer, 0.65) <= 0.025:
			footsteps_sfx.play()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		was_on_floor = false if was_on_floor else true
		velocity += get_gravity() * delta
	elif is_on_floor() and not was_on_floor:
		was_on_floor = true
		#land_sfx.play()

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		step_timer = 0.0
		jump_sfx.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
