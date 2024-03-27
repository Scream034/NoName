## Дополнительные возможности работы с `AnimationNodeStateMachine`
class_name AnimationNodeStateMachineUtils


## Даёт возможность изменить `BlendSpace 2D`, точнее анимации у **существующих точек**
static func set_blendspace_2d_points_from_animations(tree_root: AnimationNodeStateMachine, blendspace_2d_name: String, animations: Array[String], point_indexs: Array[int] = [0, 1, 2, 3]) -> void:
	var dash: AnimationNodeBlendSpace2D = tree_root.get_node(blendspace_2d_name)
	for index in point_indexs:
		AnimationNodeBlendSpace2DUtils.get_point(dash, index).animation = animations[index]