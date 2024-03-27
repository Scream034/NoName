extends Node
class_name Inventory

signal item_added(slot_index: int) ## Когда предмет добавился в инв-рь
signal cant_add_item_no_space ## Когда нет места в инв-ре, чтобы подобрать

@export var max_capacity: int
var slots: Array[InventorySlot]


func _ready() -> void:
	for index in max_capacity:
		var slot := InventorySlot.new(index)
		slots.append(slot)
		add_child(slot)
	slots.make_read_only()


## Добавить предмет, возращает: -1: нет места, 0: успешно
func add_item(new_item: BaseItem) -> int:
	var index := find_free_space()
	if index == -1:
		emit_signal("cant_add_item_no_space")
		return -1
	
	var slot: InventorySlot = slots[index]
	var item_info: Dictionary = slot.item_info

	if has_item(new_item.id):
		# Если предмет уже есть добавить к кол-ву текушего предмета в инв-ре
		if item_info.count + new_item.count <= new_item.max_count:
			item_info.count += new_item.count
		else: # Иначе добавляем до конца и ищем ещё место в инв-ре
			var remaining_count: int = item_info.count - new_item.count
			item_info.count += remaining_count

			index = find_free_space()
			if index == -1:
				emit_signal("cant_add_item_no_space")
				return remaining_count
	
	slot.set_item_info(NodeUtils.get_properties(new_item))
	emit_signal("item_added", index)
	return 0

## Вычитает предмет
func subtract_item(item_id: int, count: int) -> bool:
	var slot_index := get_item_slot(item_id)
	if slot_index == -1:
		return false
	
	var item_info = slots[slot_index].item_info
	item_info.count -= count
	if item_info.count <= 0:
		item_info = {}
	
	return true

## Получить слот по-индексу
func get_slot(index: int) -> InventorySlot:
	if index > slots.size():
		push_warning("Длина слотов меньше, чем переданный индекс!")
		return null

	return slots[index]

## Получить слот, где находиться переданный айди предмета (-1 если такого нет)
func get_item_slot(item_id: int) -> int:
	for index in max_capacity:
		if slots[index].item_info.get("id") == item_id:
			return index
	
	return -1

## Есть ли данный предмет
func has_item(item_id: int) -> bool:
	return slots.any(func (slot): return slot.item_info.get("id") == item_id)

## Найти свободное место, **-1 если нет места**
func find_free_space() -> int:
	for index in max_capacity:
		if slots[index].item_info == {}:
			return index
	
	return -1
