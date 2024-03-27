extends LivingEntity
## Класс игрока
# NOTE: Этот класс находится на стадии рассмотрения геймдизайнерами.
class_name Player

@export_group("Effects")
@export var run_camera_position_smoothing_speed := 3.5 ## Устанавливается значение `position_smoothing_speed` для камеры при беге
@export var dash_camera_position_smoothing_speed := 5.0  ## Устанавливается значение `position_smoothing_speed` для камеры при рывке

var input_move_direction: Vector2 ## Ввод движения игрока

# Флаги движения
var can_control_movement := true ## Может ли игрок управлять движением персонажа

# Узлы
@onready var stats_manager: PlayerStatisticsManager = get_node("StatisticsManager")
@onready var inventory: Inventory = get_node("Inventory")
@onready var stamina_manager: StaminaManager = get_node("StaminaManager")
@onready var dash_manager: DashManager = get_node("DashManager")
@onready var hotbar_manager: HotBarManager = get_node("HotBarManager")
@onready var camera: Camera = get_node("Camera2D")
@onready var hud_hearts_manager: HUDHeartsManager = get_node("Camera2D/HUD/Control/Hearts")
@onready var hud_debug: RichTextLabel = get_node("Camera2D/HUD/Control/Debug") ## REMOVE

# Переменные состояния
var current_input_state: String


func _init():
	states.append(FSMState.new("dash", handle_dash))
	super._init()

func _ready() -> void:
	super._ready()

	stats_manager.hud_stats_manager = get_node("Camera2D/HUD/Control/Stats")
	stats_manager.process_mode = Node.PROCESS_MODE_INHERIT

	dash_manager.connect("started", Callable(self, "_on_dash_manager_started"))
	dash_manager.connect("ended", Callable(self, "_on_dash_manager_ended"))

	inventory.connect("item_added", Callable(self, "_on_inventory_item_added"))

	__set_max_health(max_health) # Инициализация худа

func _physics_process(_delta) -> void:
	super._physics_process(_delta)
	
	_update_movement_input()

	if state_machine.current_state == "run":
		stamina_manager.current_amount -= absf(0.8 - current_speed / running_speed)

	## REMOVE
	hud_debug.set_debug("Health", current_health, 10)
	hud_debug.set_debug("Stamina", stamina_manager.current_amount, 10)
	hud_debug.set_debug("Moving", is_moving)
	hud_debug.set_debug("Can dash", dash_manager.can_dashing)
	if hotbar_manager.current_slot:
		hud_debug.set_debug("Current slot", hotbar_manager.current_slot.item_info)
		hud_debug.set_debug("Current slot type", hotbar_manager.current_item_type)

func _input(_event: InputEvent) -> void:
	_update_mouse_signals()

func _unhandled_key_input(event: InputEvent) -> void:
	input_move_direction = _get_move_direction()

	# Действия игрока
	if Input.is_action_just_pressed("move_boost"):
		current_input_state = "dash"
	elif Input.is_action_pressed("move_run"):
		current_input_state = "run"
	elif input_move_direction:
		current_input_state = "walk"
	
	# Слоты
	for index in hotbar_manager.max_cursor_position:
		if event.is_action_released("slot_%s" % index):
			hotbar_manager.set_cursor_position(index)

	## REMOVE
	if event.is_action_pressed("debug_subtract_player_health"): # '.'
		current_health -= 5


func handle_idle() -> void:
	super.handle_idle()
	stamina_manager.is_used = false
	camera.position_smoothing_speed = camera.default_position_smoothing_speed

func handle_walk() -> void:
	super.handle_walk()
	stamina_manager.is_used = false
	camera.position_smoothing_speed = camera.default_position_smoothing_speed

func handle_run() -> void:
	if !can_run():
		state_machine.current_state = "walk" if is_moving else "idle"
		return
	
	target_speed = running_speed
	stamina_manager.is_used = true
	camera.position_smoothing_speed = run_camera_position_smoothing_speed

# Обработчик рывка
func handle_dash() -> void:
	if !can_run() || !dash_manager.can_dashing:
		state_machine.current_state = state_machine.prev_state
		return
	
	dash_manager.execute(active_move_direction)

# Может ли игрок бежать
func can_run() -> bool:
	return is_moving && !stamina_manager.is_depleted


# Обе функции отвечают за визуальные эффекты камеры во время рывка
func _on_dash_manager_started() -> void:
	camera.position_smoothing_speed = dash_camera_position_smoothing_speed

func _on_dash_manager_ended() -> void:
	camera.position_smoothing_speed = camera.default_position_smoothing_speed

## Необходимо чтобы обновить новый предмет, когда у нас уже выбран слот, в который идёт предмет
func _on_inventory_item_added(slot_index: int) -> void:
	if hotbar_manager.current_slot && hotbar_manager.current_slot.index == slot_index:
		hotbar_manager.update_current_slot()


## Обновляет сигналы связанные с мышкой
func _update_mouse_signals() -> void:
	if Input.is_action_just_pressed("attack"):
		hotbar_manager.emit_signal("request_begin_process_action", HotBarManager.ActionType.Attack)
	elif Input.is_action_just_released("attack"):
		hotbar_manager.emit_signal("request_finished_process_action", HotBarManager.ActionType.Attack)
	
	elif Input.is_action_just_pressed("use_item"):
		hotbar_manager.emit_signal("request_begin_process_action", HotBarManager.ActionType.Use)
	elif Input.is_action_just_released("use_item"):
		hotbar_manager.emit_signal("request_finished_process_action", HotBarManager.ActionType.Use)

func _get_move_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

func _update_movement_input() -> void:
	if !can_control_movement:
		return
	
	move_direction = input_move_direction

	match current_input_state:
		"walk":
			state_machine.current_state = "walk"
		
		"run":
			state_machine.current_state = "run"
		
		"dash":
			state_machine.current_state = "dash"

func _update_animations() -> void:
	super._update_animations()
	_update_dash_animation()

func _update_dash_animation() -> void:
	animation_tree.set("parameters/conditions/dashing", state_machine.current_state == "dash")
	
	if state_machine.current_state == "dash":
		animation_tree.set("parameters/Dash/blend_position", move_direction)

func __set_current_health(new_health: int) -> void:
	super.__set_current_health(new_health)

	if hud_hearts_manager:
		hud_hearts_manager.set("current_agent_health", new_health)

func __set_max_health(new_max_health: int) -> void:
	super.__set_max_health(new_max_health)

	if hud_hearts_manager:
		hud_hearts_manager.set("max_agent_health", new_max_health)
