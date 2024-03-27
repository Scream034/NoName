extends Node
# Базовый класс слота, нужен для инв-ря, как хранилище
class_name InventorySlot

signal added ## Когда добавился новый предмет (не считает замену)
signal removed ## Когда **полностью** удалился предмет

var index := -1: set = set_index ## Содержит индекс слота
var item_info := {}: set = set_item_info ## Информация по-текущему предмету


func _init(_index: int, _item: BaseItem = null) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	process_priority = 1

	index = _index
	if _item:
		set_item_info(NodeUtils.get_properties(_item))


## Применить индекс
func set_index(new_index: int) -> void:
	name = str(new_index)
	index = new_index

## Применить информацию о предмете
func set_item_info(new_item_info: Dictionary) -> void:
	item_info = new_item_info
	emit_signal("added")

## Удалить информацию о предмете
func remove_item_info() -> void:
	item_info = {}
	emit_signal("remove d")

## Получить информацию о предмете из слота, требует инициализации через `id`
func get_item_info() -> Dictionary:
	return item_info