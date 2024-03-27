extends Node2D
## Абстрактный класс для всех предметов
class_name BaseItem

signal removed ## Когда полностью удаляется предмет

@export var id := -1: set = set_id ## Айди предмета 
@export var max_count: int: set = set_max_count ## Максимальное кол-во
@export var count: int: set = set_count ## Кол-во
@export var display_name: String ## Отображаемое имя
@export_multiline var description: String ## Описание
@export var icon_path: String ## Путь до иконки


func _ready() -> void:
    connect("removed", Callable(self, "remove"))

## Удалить предмет из игры
func remove() -> void:
    queue_free()
    
    if !is_queued_for_deletion():
        emit_signal("removed")

## Удалить предмет из мира
func remove_from_world() -> void:
    $PickUpArea.free()
    $AnimatedSprite.free()


# Геттеры и сеттеры для @export свойств **(Промежуточны)**
# Нельзя определять `count` до `max_count`!

## Установить новое максимальное значеие кол-ва
func set_max_count(new_max_count: int) -> void:
    if new_max_count <= count:
        count = new_max_count
        max_count = new_max_count
    elif new_max_count <= 0:
        count = 0
        max_count = 0
        remove()
    else:
        max_count = new_max_count

## Установить новое значеие кол-ва
func set_count(new_count: int) -> void:
    if new_count <= 0:
        count = 0
        remove()
    elif new_count > max_count:
        count = max_count
    else:
        count = new_count

## Сеттер айди
func set_id(new_id: int) -> void:
    if id > -1:
        return

    id = new_id