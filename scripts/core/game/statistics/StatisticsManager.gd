extends Node
# Для того чтобы он работал, нужно вызвать set_process(true)
class_name StatisticsManager


func _notification(what):
    match what:
        # Инициализация
        NOTIFICATION_UNPAUSED:
            get_children().map(func (child: Statistics): _add_stats(child))
            connect("child_entered_tree", Callable(self, "_on_child_entered_tree"))
            connect("child_exiting_tree", Callable(self, "_on_child_exiting_tree"))


## Добавить статистику, если нужно добавить статистику то делайте это через `add_child`!
func _add_stats(stats: Statistics) -> void:
    stats.connect("value_changed", Callable(self, "_on_stats_changed"))
    _on_stats_changed(stats)

## Удалить статистику, если нужно удалить статистику то делайте это через `remove_child`!
func _remove_stats(stats: Statistics) -> void:
    stats.disconnect("value_changed", Callable(self, "_on_stats_changed"))
    stats.free()


func _on_child_entered_tree(stats: Statistics) -> void:
    _add_stats(stats)

func _on_child_exiting_tree(stats: Statistics) -> void:
    _remove_stats(stats)

@warning_ignore("unused_parameter")
func _on_stats_changed(stats: Statistics) -> void:
    pass