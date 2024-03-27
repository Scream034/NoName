extends Object
## Базовый класс состояний
class_name FSMState

var name: StringName
var handle: Callable


func _init(_name: StringName, _handle: Callable) -> void:
    name = _name
    handle = _handle