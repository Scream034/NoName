extends Node
class_name HUDHeartsManager

@export var default_folder_states := "HUDHearts"

## Имена состояний сердечка (используется для файлов по пути `res://resources/sprites/HUDHealth/` и *.atlastex)
@export var STATES := [
	"Full",
	"HitLow",
	"HitHigh",
	"Die"
]
## Пороги смены состояния сердечка, длина должна быть равна длине `STATES` (формула: хп_игрока / кол-во_сердечек)
@export var HEALTH_STAGES := [
	20,
	15,
	8,
	0
]

@export var max_hearts: int = 5 ## Всего сердечек
@export var health_per_heart: float = 20 ## ХП на одно сердечко
var max_agent_health: float: set = __set_max_agent_health ## Максимальное кол-во ХП агента
var current_agent_health: float: set = __set_current_agent_health ## Кол-во ХП агента
var hearts := [] ## Сердечки

# узлы
@onready var template: TextureRect = get_node("Template")


func _init() -> void:
	if len(STATES) != len(HEALTH_STAGES):
		push_error("Длина \"STATES\" должна быть равна длине \"HEALTH_STAGES\"!")


## Инициализировать сердечки
func init_hearts() -> void:
	for index in max_hearts:
		var icon: TextureRect = template.duplicate()
		icon.name = str(index)
		icon.visible = true
		add_child(icon)

		var heart := HUDHealth.new(default_folder_states, icon, health_per_heart, health_per_heart, STATES)
		heart.current_state = 0

		hearts.append(heart)

## Установить каждому сердечку новую папку состояний
func set_folder_states(folder_states: String) -> void:
	hearts.map(func (heart): heart.folder_states = folder_states)

## Обновить сердечки (иконку, значения)
func update_hearts() -> void:
	for index in max_hearts:
		var heart: HUDHealth = hearts[index]

		# Вычисление сколько осталось ХП
		var remaining_health: float = current_agent_health - health_per_heart * index 

		# Если вычисленное ХП >= ХП на каждое седечко, то ставим сердучку значение на макс.
		if remaining_health >= health_per_heart:
			heart.current_health = health_per_heart
		else: # Иначе, то что осталось
			heart.current_health = remaining_health
		 
		# Примение состояния
		var new_state: int
		for j in len(HEALTH_STAGES):
			if heart.current_health <= HEALTH_STAGES[j]:
				new_state = j
			else:
				break
		
		heart.current_state = new_state


## **setter** для `max_agent_health`, создаёт сердечки
func __set_max_agent_health(max_health: float) -> void:
	max_agent_health = max_health
	init_hearts()

## **setter** для `current_agent_health`, обновляет сердечки
func __set_current_agent_health(current_health: float) -> void:
	current_agent_health = current_health
	update_hearts()


## Класс сердечка
class HUDHealth:
	var max_health: float
	var current_health: float
	var states: Array
	var current_state := -1: set = __set_current_state
	var folder_states: String: set = __set_folder_states
	var icon: TextureRect

	## Инициализация 
	func _init(_folder_states: String, _icon: TextureRect, _max_health: float, _health: float, _states: Array):
		states = _states
		folder_states = _folder_states
		icon = _icon
		max_health = _max_health
		current_health = _health


	func update_texture() -> void:
		if current_state == -1:
			return
		
		icon.texture = load("res://resources/sprites/%s/%s.atlastex" % [folder_states, states[current_state]])


	func __set_folder_states(new_folder_states: String) -> void:
		folder_states = new_folder_states
		update_texture()

	## **setter** для `current_state`, выставляет новую иконку, если не повторяется состояние
	func __set_current_state(new_state: int) -> void:
		if new_state == current_state:
			return

		current_state = new_state
		update_texture()