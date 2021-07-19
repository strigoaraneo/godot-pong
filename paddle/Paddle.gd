extends Node2D

class_name Paddle

# Paddle variables
var _color: Color= Color.white
var _size: Vector2 = Vector2(10.0, 100.0)
var _padding: float = 10.0
var _speed: Vector2 = Vector2(0.0, 400.0) # Paddle only moves in y-axis
var _reset_speed: Vector2 = _speed
var _half_height: float = _size.y/2.0

# Handled by subclass
var _rect: Rect2
var _pos: Vector2
var _reset_pos: Vector2
var _bound_box: BoundingBox

func _draw() -> void:
	draw_rect(_rect, _color)

func get_half_height() -> float:
	return _half_height

func get_rect() -> Rect2:
	return _rect

func reset_position() -> void:
	_pos = _reset_pos
	_rect = Rect2(_pos, _size)
	update()

func update_position() -> void:
	_pos.y = clamp(_pos.y, _bound_box.get_position().y, _bound_box.get_size().y - _size.y)
	_rect = Rect2(_pos, _size)
	update()

# Overriden by subclass
func move_up(delta: float) -> void:
	assert(false, "Mehtod move_up() has not been overridden")

# Overriden by subclass
func move_down(delta: float) -> void:
	assert(false, "Mehtod move_down() has not been overridden")
