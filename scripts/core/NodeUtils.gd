class_name NodeUtils

## Получение параметров из узла, **исключает ссылки на объекты**
static func get_properties(node: Node) -> Dictionary:
    var properties := {}
    for property in node.get_property_list():
        if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
            var value = node.get(property.name)
            if !value is Object:
                properties[property.name] = value
    return properties

## Устанавливает параметры в узел
static func set_properties(node: Node, properties: Dictionary) -> void:
    for property_name in properties:
        node.set(property_name, properties[property_name])