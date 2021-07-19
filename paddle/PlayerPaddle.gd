extends Paddle

class_name PlayerPaddle

func _init(box: BoundingBox) -> void:
	_bound_box = box
	_pos = Vector2(_padding, _bound_box.get_half_height() - _half_height) # Specific to subclass
	_reset_pos = _pos
	_rect = Rect2(_pos, _size)

func check_movement(delta: float):
	if (Input.is_key_pressed(KEY_W)):
		move_up(delta)
		update_position()
	if (Input.is_key_pressed(KEY_S)):
		move_down(delta)
		update_position()

func move_up(delta: float) -> void:
	_pos.y -= _speed.y * delta

func move_down(delta: float) -> void:
	_pos.y += _speed.y * delta
