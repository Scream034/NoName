extends Node
# Комппонет быстрого доступа к слотам
class_name HotBarManager

signal current_slot_updated ## Когда текущий слот обновился
signal request_begin_process_action(type: ActionType) ## Запрос на начало процесса-действия
signal request_finished_process_action(type: ActionType) ## Запрос на конец процесса-действия

@export_node_path var inventory_path: NodePath = "../Inventory"
@export var max_cursor_position := 9 ## Максимальная позиция курсора
@export var current_cursor_position := 0: set = set_cursor_position ## Текущая позиция курсора

var current_slot: InventorySlot: set = set_current_slot ## Текущий слот из инв-ря
var current_item: BaseItem: set = __set_current_item ## Текущий предмет
var current_item_type: ItemHelper.Type ## Текущий тип предмета в слоте
var inventory: Inventory ## Ссылка на инв-рь
var last_item: BaseItem ## Последний добавленный предмет

## Тип выполняемого действия предметом
enum ActionType {
	Use,
	Attack
}


func _init() -> void:
	connect("request_begin_process_action", Callable(self, "_on_request_begin_process_action"))
	connect("request_finished_process_action", Callable(self, "_on_request_finished_process_action"))

func _ready() -> void:
	inventory = get_node(inventory_path)
	set_cursor_position(0) # Инициализация текущего слота


## Обновляет текущий слот
func update_current_slot() -> void:
	# TODO: Дописать инициализацию предмета по id, лучше всего делать через статичные функции
	current_slot = inventory.get_slot(current_cursor_position)
	var item_info := current_slot.get_item_info()
	if item_info == {} || (last_item && item_info == NodeUtils.get_properties(last_item)):
		return
	
	var item: BaseItem = ItemHelper.get_item_scene_by_item_info(item_info)
	item.ready.connect(func(): current_item = item, CONNECT_ONE_SHOT)
	call_deferred("add_child", item)
	
	last_item = item
	emit_signal("current_slot_updated")

## Установить новую позицию для курсора
func set_cursor_position(new_index: int) -> void:
	if new_index > max_cursor_position || new_index < 0:
		return

	if current_cursor_position != new_index && last_item:
		last_item.call_deferred("remove")

	current_cursor_position = new_index
	update_current_slot()

## Установить слот, чекать на пустышку
func set_current_slot(new_current_slot: InventorySlot) -> void:
	current_slot = new_current_slot
	if current_slot.item_info == {}:
		current_item = null

## Явл-я ли он оружием
func check_is_weapon(type: ActionType, _class_name: StringName) -> bool:
	return type == ActionType.Attack && current_item_type == ItemHelper.Type.Weapon

## Явл-я ли он предметом, который можно использовать
func check_is_interact_item(type: ActionType, _class_name: StringName) -> bool:
	return type == ActionType.Use && current_item_type == ItemHelper.Type.InteractItem

func process_attack_begin_action() -> void:
	pass

func process_use_begin_action() -> void:
	pass

func process_attack_finished_action() -> void:
	print(0)

func process_use_finished_action() -> void:
	pass


func _on_request_begin_process_action(type: ActionType) -> void:
	var _class_name = current_slot.item_info.get("class_name")
	if !_class_name:
		return

	if check_is_weapon(type, _class_name):
		process_attack_begin_action()
	elif check_is_interact_item(type, _class_name):
		process_use_begin_action()

func _on_request_finished_process_action(type: ActionType) -> void:
	var _class_name = current_slot.item_info.get("class_name")
	if !_class_name:
		return

	if check_is_weapon(type, _class_name):
		process_attack_finished_action()
	elif check_is_interact_item(type, _class_name):
		process_use_finished_action()


## **setter** для `current_item`, установить предмет и тип
func __set_current_item(new_current_item: BaseItem) -> void:
	current_item = new_current_item
	current_item_type = ItemHelper.get_item_type_by_class_name(current_item.get_script().get_global_name()) if current_item else ItemHelper.Type.NULL