extends Control
class_name HUDStatsManager

@onready var template_icon: TextureRect = get_node("Icon")
@onready var template_name: Label = get_node("Name")
@onready var template_value: Label = get_node("Value")

var all_stats: Dictionary ## Все статистики, **имя_статистики: [приоритет, иконка, имя, значение]**

## Изменить статистику
@warning_ignore("unused_parameter")
func set_stats_value(stats_name: String, stats_new_value: int) -> void:
    var node_value = all_stats[stats_name][3]
    node_value.text = str(stats_new_value)

## Добавить статистику
@warning_ignore("unused_parameter")
func add_stats(stats: Statistics) -> void:
    var new_nodes := [
        template_icon.duplicate(),
        template_name.duplicate(),
        template_value.duplicate()
    ]

    for node in new_nodes:
        node.name = stats.name + node.name
        node.visible = true
        add_child(node)

    new_nodes[0].texture = load(stats.icon_path)
    new_nodes[1].text = stats.display_name
    new_nodes[2].text = str(stats.value)

    all_stats[stats.name] = [stats.priority] + new_nodes

    update_priorities()

## Обновить дерево узлов по приоритетам
func update_priorities() -> void:
    # Сортируем статистики по приоритету в порядке убывания
    var sorted_stats = all_stats.values()
    sorted_stats.sort_custom(func(a, b): return a[0] > b[0])

    # Создаем новые узлы в отсортированном порядке
    for stats in sorted_stats:
        var stats_name: StringName = stats[1].name.replace("Icon", "")

        for index in range(1, stats.size()):
            var node = stats[index].duplicate()
            stats[index].free()
            add_child(node)
            all_stats[stats_name][index] = node

## Есть ли такая статистика
func has_stats(stats_name: StringName) -> bool:
    return all_stats.has(stats_name)