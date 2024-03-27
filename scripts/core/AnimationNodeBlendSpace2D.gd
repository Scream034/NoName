class_name AnimationNodeBlendSpace2DUtils


## Получить точку
static func get_point(blendspace_2d: AnimationNodeBlendSpace2D, index: int) -> AnimationRootNode:
	return blendspace_2d.get("blend_point_%s/node" % index)