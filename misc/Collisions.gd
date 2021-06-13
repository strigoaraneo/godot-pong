extends Resource

class_name Collisions

static func point_to_point(point_a: Vector2, point_b: Vector2) -> bool:
	return point_a.x == point_b.x and point_a.y == point_b.y

static func point_to_rect(point: Vector2, rect: Rect2) -> bool:
	var rect_left:float = rect.position.x
	var rect_right:float = rect_left + rect.size.x
	var rect_top:float = rect.position.y
	var rect_bottom: float = rect_top + rect.size.y
	
	return (point.x >= rect_left and point.x <= rect_right
	and point.y >= rect_top and point.y <= rect_bottom)
