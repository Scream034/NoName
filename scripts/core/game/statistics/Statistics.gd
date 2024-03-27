extends Node
## Абстрактный класс всех статистик
class_name Statistics

signal value_changed ## Когда значение изменилось

@export var icon_path: String ## Путь до иконки
@export var display_name: String ## Отображаемое имя
@export var priority: int ## Приоритет отображения
@export var value: int: set = __set_value ## Значение


## **setter** для `value` 
func __set_value(new_value: int) -> void:
    var prev_value := value

    value = new_value

    if new_value != prev_value:
        emit_signal("value_changed", self)