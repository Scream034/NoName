extends Node
## Абстрактный класс всех эффектов
class_name BaseEffect

signal started(target_living_entity: LivingEntity)
signal update ## Когда необходимо обновить эффект, пример: Обновление эффектов каждую секунду - вызов
signal ended ## Когда эффект закончил время действие

@export var id : int ## Айди предмета
@export var max_effect_time: float ## Макс время действия эффекта
var current_effect_time: float ## Точка отсчёта, макс время
var target_entity: LivingEntity ## На кого действует эффект


func _init() -> void:
    connect("started",Callable(self, "_on_started"))
    connect("update",Callable(self, "update_effect"))

func _ready():
    current_effect_time = max_effect_time  


## Обработчик логики эффекта
func handle_effect() -> void: 
    push_warning("Нет обработчика эффекта, необходимо его добавить в класс %s!" % get_script().get_global_name())

func update_effect() -> void:
    current_effect_time -= 1
    if current_effect_time < 0:
        return emit_signal("ended")
    handle_effect()   


func _on_started(target_living_entity: LivingEntity) -> void:
    target_entity = target_living_entity