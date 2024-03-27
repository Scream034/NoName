extends Node
class_name DashManager

signal started ## Когда рывок был произведён
signal ended ## Когда рывок закончился

@export_node_path var stamina_manager_path: NodePath = "../StaminaManager" ## Путь до `StaminaManager`

@export var acceleration := 1000.0 ## Ускорение
@export var deacceleration := 1000.0 ## Замедление после рывка
@export var speed := 750.0 ## Скорость
@export var speed_delta := 0.985 ## Шаг в добавлении скорости
@export var speed_stop_delta := 0.975 ## Шаг в убавлении скорости
@export var length := 100.0 ## Длина рывка
@export var cost_stamina_dash := 25.0 ## Стоимость рывка
var current_speed: float ## Текущая скорость рывка
var current_length: float ## Текущая длина рывка

var begin_position: Vector2 ## Начальная позиция, начала рывка

# Флаги
var can_dashing := true ## Можно ли выполнить рывок

# Узлы
@onready var cooldown_timer: Timer = get_node("CooldownTimer")
var stamina_manager: StaminaManager


func _ready() -> void:
	set_physics_process(false)

	stamina_manager = get_node(stamina_manager_path)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timer_timeout"))

func _physics_process(_delta) -> void:
	if begin_position.distance_to(owner.global_position) >= current_length:
		set_physics_process(false)
		emit_signal("ended")

## Выполнить рывок
func execute(target_direction: Vector2) -> void:
	if !can_dashing:
		return

	emit_signal("started")

	can_dashing = false
	stamina_manager.is_used = true
	owner.can_control_movement = false
	owner.can_update_speed = false

	owner.move_direction = target_direction

	owner.set_current_movement_params(speed, speed_delta, speed_stop_delta, acceleration, deacceleration)

	# Высчитывается множитель стамины, далее применение
	var stamina_ratio: float = calculate_stamina_ratio(stamina_manager.current_amount)

	current_speed = speed * stamina_ratio
	current_length = length * stamina_ratio
	current_speed = current_speed

	# Вычитаем из текущей стамины
	stamina_manager.current_amount -= cost_stamina_dash

	begin_position = owner.global_position
	set_physics_process(true)

	# Ждём пока таймер удалится
	await ended

	# Возращаю всё обратно	
	stamina_manager.is_used = false
	owner.can_control_movement = true
	owner.can_update_speed = true

	owner.move_direction = Vector2.ZERO
	owner.set_current_movement_params()

	cooldown_timer.start()

## Вычисление множителя стамины
func calculate_stamina_ratio(amount: float) -> float:
	var stamina_ratio := 1.0
	if amount < cost_stamina_dash:
		stamina_ratio = 0.65 - (0.325 - amount / cost_stamina_dash)
	return stamina_ratio

func _on_cooldown_timer_timeout() -> void:
	can_dashing = true
