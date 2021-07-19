extends Node2D

class_name Ball

var _color: Color = Color.white
var _radius: float = 10.0
var _reset_pos: Vector2
var _pos: Vector2
var _speed: Vector2
var _reset_speed: Vector2

func _init(start_pos: Vector2, speed: float = 400.0):
	_pos = start_pos
	_reset_pos = start_pos # Assuming center of screen is being passsed
	_speed = Vector2(abs(speed), 0.0)
	_reset_speed = _speed
	
func _draw() -> void:
	draw_circle(_pos, _radius, _color)
	
func move_ball(delta: float) -> void:
	_pos += _speed * delta
	update() # This method calls the draw() function
	
func reset_ball(player_serve: bool) -> void:
	_pos = _reset_pos # Assuming ball is centered on the screen
	_speed = _reset_speed if player_serve else -_reset_speed
	update()
	
func inverse_Y_speed() -> void:
	_speed.y = -_speed.y
	
func inverse_X_speed() -> void:
	_speed = Vector2(-_speed.x, rand_range(-400.0, 0))
	
func get_position() -> Vector2:
	return _pos

func get_top_point() -> Vector2:
	return Vector2(_pos.x, _pos.y - _radius)

func get_bottom_point() -> Vector2:
	return Vector2(_pos.x, _pos.y + _radius)
	
func is_moving_left() -> bool:
	return _speed.x <= 0.0

func is_moving_right() -> bool:
	return _speed.x >= 0.0

func is_moving_up() -> bool:
	return _speed.y <= 0.0

func is_moving_down() -> bool:
	return _speed.y >= 0.0