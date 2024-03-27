class_name ItemHelper

## Содержит в себе все возможные айди предметов в игре (-1 = неопределяемый)
enum Id {
	Sword
}

## Содержит типы предметов
enum Type {
	NULL,
	InteractItem,
	Weapon
}

## Пути до сцен предметов, шаблон: `Айди_предмета = Путь_до_сцены`
static var item_scenes: Array[String] = [
	"res://scenes/game/objects/Sword.tscn"
]


## Получить тип предмета по его `class_name`
static func get_item_type_by_class_name(_class_name) -> Type:
	if !_class_name:
		return Type.NULL
	
	if _class_name.find("Weapon") != -1:
		return Type.Weapon
	elif _class_name.find("Interact") & _class_name.find("Item") != -1:
		return Type.InteractItem
	else:
		return Type.NULL

## Вернёт предмет либо null, по айди предмета
static func get_item_scene_by_id(id: int) -> BaseItem:
	var scene: PackedScene = load(item_scenes[id])
	return scene.instantiate() if scene else null

## Вернёт предмет со всеми его хар-ами или null
static func get_item_scene_by_item_info(item_info: Dictionary) -> BaseItem:
	var item := get_item_scene_by_id(item_info.id)
	if !item:
		return null
	
	NodeUtils.set_properties(item, item_info)
	item.call_deferred("remove_from_world")
	return item