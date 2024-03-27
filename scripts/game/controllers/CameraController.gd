extends Camera2D
# Котроллер камеры игрока
class_name Camera

@export_range(0.5, 1) var zoom_factor_min: float = 0.9 ## Минимальный множитель зума
@export_range(0.5, 1) var zoom_factor_max: float = 1.1 ## Максимальный множитель зума
@export_range(0.01, 1) var zoom_speed: float = 0.1  ## Скорость изменения зума
@export var zoom_min: Vector2 = Vector2(0.4, 0.4) ## Минимальный приближене
@export var zoom_max: Vector2 = Vector2(1.1, 1.1) ## Максимальное приближение

var new_zoom: Vector2 = zoom

## Значение `_position_smoothing_speed` по умолчанию
var default_position_smoothing_speed: float


func _ready() -> void:
	default_position_smoothing_speed = position_smoothing_speed

func _physics_process(_delta: float) -> void:
	zoom = zoom.lerp(new_zoom, zoom_speed)

func _unhandled_input(_event: InputEvent) -> void:
	if !(_event is InputEventMouseButton && _event.is_pressed()): 
		return
	
	if _event.button_index == MOUSE_BUTTON_WHEEL_UP:
		new_zoom *= zoom_factor_max
	elif _event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		new_zoom *= zoom_factor_min

	new_zoom = new_zoom.clamp(zoom_min, zoom_max)
