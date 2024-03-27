extends Node2D

func _ready():
	var scene = load("res://scenes/game/objects/Coin.tscn")
	
	for _i in randi_range(25, 80):
		var instance = scene.instantiate()
		instance.count = randi_range(1, instance.max_count)
		instance.position = Vector2(randi_range(600, 2000), randi_range(600, 2000))
		add_child(instance)
