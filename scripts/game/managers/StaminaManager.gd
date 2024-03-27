extends Node
class_name StaminaManager

# TODO: Добавить setter на проверку не больше ли current_amount чем max_amount
@export var max_amount := 200.0 ## Максимальное кол-во выносливости
@export var regen_amount := 4.0 ## Слагаемое при восстановлении 
@export var current_amount: float: set = __set_current_amount ## Текущея выносливость

# Флаги выносливости
var is_regenerating: bool: set = __set_is_regenerating ## Восстанавливается ли выносливость
var is_used: bool: set = __set_is_used ## Используется ли стамина
var is_depleted: bool: set = __set_is_depleted ## Истощена ли выносливость

# Узлы
@onready var regen_timer: Timer = get_node("RegenCooldownTimer")
@onready var restore_regen_timer: Timer = get_node("RestoreRegenTimer")
@onready var depletion_timer: Timer = get_node("DepletedCooldownTimer")


func _ready() -> void:
    current_amount = max_amount
    regen_timer.connect("timeout", 	Callable(self, "_on_regen_timer_timeout"))
    restore_regen_timer.connect("timeout", 	Callable(self, "_on_restore_regen_timer_timeout"))
    depletion_timer.connect("timeout", Callable(self, "_on_depletion_timer_timeout"))


func _on_regen_timer_timeout() -> void:
    if current_amount == max_amount:
        regen_timer.stop()
        return
    
    current_amount += regen_amount

func _on_restore_regen_timer_timeout() -> void:
    is_regenerating = true

func _on_depletion_timer_timeout() -> void:
    is_depleted = false


## **setter** для `current_amount`, включать таймеры
func __set_current_amount(new_amount: float) -> void:
    new_amount = clampf(new_amount, 0, max_amount)

    if new_amount <= 0:
        is_used = false
        is_depleted = true
    elif new_amount < current_amount && !is_used:
        return

    current_amount = new_amount

## **setter** для `is_regenerating`, запускать/останавливать таймер `regen_timer`
func __set_is_regenerating(value: bool) -> void:
    if value:
        if regen_timer.is_stopped():
            regen_timer.start()
    else:
        regen_timer.stop()

    is_regenerating = value

## **setter** для `is_used`, запускать/останавливать таймер `stamina_start_regen_timer`
func __set_is_used(value: bool) -> void:
    if value && !is_depleted:
        is_regenerating = false
    else:
        if is_used == true && restore_regen_timer.is_stopped():
            restore_regen_timer.start()

    is_used = value

## **setter** для `is_depleted`, запускать/останавливать таймер `depletion_timer`
func __set_is_depleted(value: bool) -> void:
    if value:
        if depletion_timer.is_stopped():
            is_regenerating = false
            depletion_timer.start()
    else:
        is_regenerating = true

    is_depleted = value