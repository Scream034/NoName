extends Area2D
## BasePickUpItemArea
class_name BasePUIA

signal finished_pick_up ## Когда закончил подбирать предмет
signal added_to_inventory ## Когда смог добавиться в инв-рь


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_pick_up_area_body_entered"))


## Попытка подобрать предмет
func pick_up(inventory: Inventory) -> void:
	var result := inventory.add_item(owner)

	# Если собрал, но нет места
	if result > 0:
		owner.count -= result
	else: # Иначе он полностью собрал предмет
		owner.call_deferred("remove")
		emit_signal("added_to_inventory")

	emit_signal("finished_pick_up")


func _on_pick_up_area_body_entered(living_entity: LivingEntity) -> void:
	call_deferred("_toggle_pick_up") # переключаем поднятие предмета

	var inventory: Inventory = living_entity.get_node("Inventory")
	pick_up(inventory)


## Переключение поднятие предмета
func _toggle_pick_up() -> void:
	visible = !visible
	process_mode = Node.PROCESS_MODE_DISABLED if visible else Node.PROCESS_MODE_INHERIT
