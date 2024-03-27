extends BaseEffect
## Класс эффекта яда
class_name PoisonEffect

@export var damage_per_second := 10 ## Урон в секунду


func handle_effect() -> void: 
	target_entity.current_health -= damage_per_second
