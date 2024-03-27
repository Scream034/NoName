extends BasePUIA
## PickUpCollectibleItemArea
class_name PUCA


func pick_up(__ = null, stats_manager: StatisticsManager = null) -> void:
	var stats: Statistics = stats_manager.get_node_or_null(NodePath(owner.type_name))
	stats.value += owner.count
	owner.count = 0
	emit_signal("finished_pick_up")


func _on_pick_up_area_body_entered(body: LivingEntity) -> void:
	var stats_manager: StatisticsManager = body.get_node_or_null("StatisticsManager")
	if !stats_manager: return

	PUCA.add_stats_if_dont_exist(stats_manager, owner.type_name)
	pick_up(null, stats_manager)

## Создать статистику, если её нет
static func add_stats_if_dont_exist(stats_manager: StatisticsManager, stats_name: String) -> void:
	var stats = stats_manager.get_node_or_null(NodePath(stats_name))
	if stats:
		return
	
	var stats_reference: PackedScene = load("res://scenes/game/components/Statistics/%s.tscn" % stats_name)
	stats_manager.add_child(stats_reference.instantiate())