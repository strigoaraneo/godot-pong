extends Resource

class_name BoundingBox

var _box: Rect2
var _top_bound: float
var _bottom_bound: float
var _right_bound: float
var _left_bound: float

func _init(rect: Rect2) -> void:
	_box = rect
	_left_bound = _box.position.x
	_right_bound = _left_bound + _box.size.x
	_top_bound = _box.position.y
	_bottom_bound = _top_bound + _box.size.y

func get_half_height() -> float:
	return _box.size.y / 2.0

func get_half_width() -> float:
	return _box.size.x / 2.0

func get_center() -> Vector2:
	return _box.size / 2.0

func get_rect() -> Rect2:
	return _box

func get_size() -> Vector2:
	return _box.size

func get_position() -> Vector2:
	return _box.position

func get_box() -> BoundingBox:
	return self

func is_pass_left_bound(position: Vector2) -> bool:
	return position.x <= _left_bound

func is_pass_right_bound(position: Vector2) -> bool:
	return position.x >= _right_bound

func is_pass_top_bound(position: Vector2) -> bool:
	return position.y <= _top_bound

func is_pass_bottom_bound(position: Vector2) -> bool:
	return position.y >= _bottom_bound
