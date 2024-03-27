extends Node
## Менеджер эффектов, родитель всегда LivingEntity
class_name EffectManager

signal effect_added(effect: BaseEffect) ## Когда добавился эффект
signal new_effect_added(effect: BaseEffect) ## Когда новый эффект добавился

@onready var timer: Timer = get_node("UpdateTimer")
var effects : Array[BaseEffect]: set = __set_effects


func _ready() -> void:
    connect("child_entered_tree",Callable(self,"_on_child_entered_tree"))
    connect("child_exiting_tree",Callable(self,"_on_child_exiting_tree"))
    timer.connect("timeout",Callable(self,"_on_timer_timeout"))

   

## Найти эффект в списке
func find_effect(effect: BaseEffect) -> int:
    return effects.find(effect)


func _on_child_entered_tree(effect: Node) -> void:
    if !effect is BaseEffect:
        return remove_child(effect)
    
    emit_signal("effect_added")

    var founded_index_effect := find_effect(effect)

    # NOTE: Нужно будет изменить если поменяется логика, когда уже есть такой эффект
    # Если такой эффект уже есть, то выставляем текущее время равному максимальному у двоих
    if founded_index_effect != -1:
        var existing_effect := effects[founded_index_effect]
        existing_effect.current_effect_time = maxf(existing_effect.max_effect_time, effect.max_effect_time)
        return remove_child(effect)

    effect.connect("ended", Callable(self,"_on_effect_ended").bind(effect))
    effects.append(effect)
    effect.emit_signal("started",owner)

    
    emit_signal("new_effect_added")

func _on_child_exiting_tree(effect: Node)-> void:
    if !effect is BaseEffect:
        return
    
    effects.erase(effect)  

func _on_timer_timeout():
    effects.map(func(effect): effect.emit_signal("update"))

func _on_effect_ended(effect: BaseEffect)->void:
    remove_child(effect)


## **setter** для `effects`, обновляет таймера в зависимости от кол-во эффектов
func __set_effects(new_effects:Array)-> void:
    var _size := new_effects.size()
    if _size > 0: 
        timer.process_mode = Node.PROCESS_MODE_INHERIT
    elif _size <= 0:
        timer.process_mode = Node.PROCESS_MODE_DISABLED