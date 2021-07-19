extends Paddle

class_name AIPaddle

const _CHASE_BUFFER: float = 15.0

func _init(box: BoundingBox) -> void:
	_bound_box = box
	_pos = Vector2(_bound_box.get_size().x - (_padding + _size.x), _bound_box.get_half_height() - _half_height) # Specific to subclass
	_reset_pos = _pos
	_rect = Rect2(_pos, _size)

func check_movement(delta: float, ball_pos: Vector2):
	if ball_pos.y <= (_pos.y + _half_height) - _CHASE_BUFFER:
		move_up(delta)
		update_position()
	elif ball_pos.y >= (_pos.y + _half_height) + _CHASE_BUFFER:
		move_down(delta)
		update_position()

func move_up(delta: float) -> void:
	_pos.y -= _speed.y * delta

func move_down(delta: float) -> void:
	_pos.y += _speed.y * delta
