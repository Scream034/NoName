extends StatisticsManager
class_name PlayerStatisticsManager

var hud_stats_manager: HUDStatsManager


func _on_stats_changed(stats: Statistics) -> void:
	if hud_stats_manager.has_stats(stats.name):
		hud_stats_manager.set_stats_value(stats.name, stats.value)
	else:
		hud_stats_manager.add_stats(stats)
