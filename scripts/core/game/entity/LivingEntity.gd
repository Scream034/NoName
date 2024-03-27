extends CharacterBody2D
## Абстрактный класс для всех живых существа
# NOTE: Этот класс находится на стадии рассмотрения геймдизайнерами и сценаристами.
class_name LivingEntity

signal health_changed ## Когда у персонажа **изменилось ХП**
# TODO: Дописать состояние смерти и её процесс/результат
signal died ## Когда **умирает персонаж**
# TEST: То как он реагирует, будут ли конфликты с другими частями класса
signal hit ## Когда персонаж **получил урон**
# TODO: Создать логику взаимодествия персонажа с игровомы элементами
signal process_interact_started ## Когда персонаж **начал процесс для взаимодействия**
signal process_interact_finished ## Когда персонаж **закончил процесс для взаимодействия**
signal interacted ## Когда персонаж **взаимодействовал**

@export_group("Movement")
@export_range(0, 100) var acceleration: float = 38 ## Ускорение персонажа
@export_range(0, 100) var deacceleration: float = 30 ## Замедление персонажа

# TODO: Добавить setter чтобы было так: walking_speed < running_speed < max_speed
@export var max_speed := 800.0 ## Максимально допустимая скорость игрока
@export var running_speed := 400.0 ## Максимальная скорость бега персонажа
@export var walking_speed := 200.0 ## Максимальная скорость ходьбы персонажа
@export_range(0, 1) var speed_delta := 0.95 ## Шаг в добавлении скорости
@export_range(0, 1) var speed_stop_delta := 0.97 ## Шаг в убавлении скорости
var target_speed: float ## Конечная скорость в интерполяции
var current_speed: float ## Текущая скорость персонажа
var current_speed_delta: float ## Текущий шаг в добавлении скорости
var current_speed_stop_delta: float ## Текущий шаг в убавлении скорости
var current_acceleration: float ## Текущее ускорение персонажа
var current_deacceleration: float ## Текущее замедление персонажа

# Направление
var move_direction: Vector2: set = __set_move_direction ## Текущее направление движения персонажа
var active_move_direction : Vector2 ## Текущий активный `move_direction`

# Флаги перемещения
var is_moving := false: set = __set_is_moving ## Передвигается ли персонаж
var can_update_speed := true ## Можно ли обновлять скорость

@export_group("Characteristic")
@export_range(0, 1000) var max_health := 100: set = __set_max_health ## Максимальное ХП персонажа
@export var current_health := 100: set = __set_current_health ## Текущее ХП персонажа

## Содержит лишь указанные состояния
var states: Array[FSMState] = [
	FSMState.new("idle", handle_idle),
	FSMState.new("walk", handle_walk),
	FSMState.new("run", handle_run),
	FSMState.new("hit", handle_hit),
	FSMState.new("die", handle_die)
]

# Компоненты
var state_machine: FSMStateMachine = FSMStateMachine.new()

# Узлы
@onready var animation_tree: AnimationTree = get_node("AnimationTree") ## Ссылка на узел с анимационным деревом.

## Возможные направления персонажа `{Имя_направления: Вектор}`
var Directions := {
	"North": Vector2.UP,
	"North east": Vector2(1, -1),
	"East": Vector2.RIGHT,
	"South east": Vector2(1, 1),
	"South": Vector2.DOWN,
	"South west": Vector2(-1, 1),
	"West": Vector2.LEFT,
	"North west": Vector2(-1, -1)
}


func _init() -> void:
	set_current_movement_params()

	state_machine.add_states(states)

func _ready() -> void:
	$AnimationTree.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(_delta) -> void:
	_movement()
	_update_animations()


## Обработчик бездействия
func handle_idle() -> void:
	target_speed = 0

## Обработчик ходьбы
func handle_walk() -> void:
	if !can_walk():
		state_machine.current_state = "idle"
		return
	
	target_speed = walking_speed

## Обработчик бега
func handle_run() -> void:
	if !can_run():
		state_machine.current_state = "walk" if is_moving else "idle"
		return
	
	target_speed = running_speed

## Обработчик хита
func handle_hit() -> void:
	print("Hit!")

## Обработчик смерти
func handle_die() -> void:
	print("Die!")

func can_walk() -> bool:
	return is_moving

func can_run() -> bool:
	return is_moving

## Наносит урон персонажу
func take_damage(amount: int) -> void:
	state_machine.current_state = "hit"
	current_health -= amount
	emit_signal("hit", amount)

## Обработка смерти персонажа
func die() -> void:
	state_machine.current_state = "die"
	emit_signal("died")
	queue_free()

## Обновляет все функции анимаций
func _update_animations() -> void:
	_update_idle_animation()
	_update_walk_animation()
	_update_run_animation()

## Обновляет анимацию бездействия
func _update_idle_animation() -> void:
	animation_tree.set("parameters/conditions/idle", state_machine.current_state == "idle")

	if state_machine.current_state == "idle":
		animation_tree.set("parameters/Idle/blend_position", active_move_direction)

## Обноваляет анимацию ходьбы
func _update_walk_animation() -> void:
	animation_tree.set("parameters/conditions/walking", state_machine.current_state == "walk")
	
	if state_machine.current_state == "walk":
		animation_tree.set("parameters/Walk/blend_position", active_move_direction)

## Обноваляет анимацию бега
func _update_run_animation() -> void:
	animation_tree.set("parameters/conditions/running", state_machine.current_state == "run")

	if state_machine.current_state == "run":
		animation_tree.set("parameters/Run/blend_position", active_move_direction)

## Обработка движения
func _movement() -> void:
	_update_movement_flags()
	_update_speed()
	
	if is_moving:
		active_move_direction = move_direction
		velocity = velocity.move_toward(move_direction * current_speed, acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deacceleration)
	
	move_and_slide()

## Устаносвить новое направление по имени направления
func set_direction_by_name(direction_name: String) -> void:
	move_direction = Directions[direction_name]

## Возращает имя стороны света
func get_direction_name() -> String:
	var finded := Directions.values().find(move_direction.round())
	return Directions.keys()[finded] if finded != -1 else ""

## Выставляет текущие значения интерполяции движения, если ничего не передать будет дефолт
func set_current_movement_params(
	new_current_speed: float = -1, 
	new_speed_delta: float = -1, 
	new_speed_stop_delta: float = -1, 
	new_acceleration: float = -1, 
	new_deacceleration: float = -1) -> void:
	
	current_speed = current_speed if new_current_speed == -1 else new_current_speed
	current_speed_delta = speed_delta if new_speed_delta == -1 else new_speed_delta
	current_speed_stop_delta = speed_stop_delta if new_speed_stop_delta == -1 else new_speed_stop_delta
	current_acceleration = acceleration if new_acceleration == -1 else new_acceleration
	current_deacceleration = deacceleration if new_deacceleration == -1 else new_deacceleration

## Обновляет флаги движения
func _update_movement_flags() -> void:
	is_moving = move_direction != Vector2.ZERO

## Обновляет текущею скорость движения
func _update_speed() -> void:
	if !can_update_speed:
		return
	
	if is_moving:
		current_speed = lerpf(current_speed, target_speed * _get_turn_factor_from_movement(), current_speed_delta)
	else:
		current_speed = lerpf(current_speed, target_speed, current_speed_stop_delta)

## Вычисляет множитель угла между текущим и последним движением
func _get_turn_factor_from_movement() -> float:
	# Вычисление угла между предыдущим и текущим направлением движения
	var turn_angle: float = move_direction.angle_to(active_move_direction)
	# Нормализация угла
	return clampf(1 - absf(turn_angle) / PI, 0, 1)

## Получает направление движения
func _get_move_direction() -> Vector2:
	return Vector2.ZERO


## **setter** для `max_health`, проверки на нуль и максимального ХП относительно текущего ХП
func __set_max_health(new_max_health: int) -> void:
	if new_max_health < current_health:
		current_health = new_max_health
	if new_max_health <= 0:
		push_error("Максимально ХП персонажа не может быть меньше или равняться нулю!")
	
	max_health = new_max_health
	
## **setter** для `current_health`, проверки на смерть и максимального ХП
func __set_current_health(new_health: int) -> void:
	if current_health != new_health:  # Если здоровье изменилось
		emit_signal("health_changed", current_health, new_health)  # Эмитируем сигнал

	if new_health > max_health: 
		current_health = max_health
		return push_error("ХП персонажа не может быть больше максимального значения!")
	if new_health <= 0:
		current_health = 0
		return die()

	current_health = new_health

## **setter** для `move_direction`, округляет с шагом 0.1
func __set_move_direction(new_move_direction: Vector2) -> void:
	move_direction = new_move_direction.snapped(Vector2(0.1, 0.1)) if new_move_direction else Vector2.ZERO

## **setter** для `is_moving`, обновляет состояние
func __set_is_moving(value: bool) -> void:
	if !value:
		state_machine.current_state = "idle"
	
	is_moving = value