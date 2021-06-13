extends Node2D

class_name Ball

var _color: Color = Color.white
var _speed: Vector2 = Vector2(400.0, 0.0)
var _radius: float = 10.0
var _reset_pos: Vector2
var _pos: Vector2
var _reset_speed: Vector2
var _player_serve: bool

func _init(start_pos: Vector2, player_serve = true):
	_pos = start_pos
	_reset_pos = start_pos # Assuming center of screen is being passsed
	_player_serve = player_serve
	_reset_speed = _speed
	
func _draw() -> void:
	draw_circle(_pos, _radius, _color)
	
func move_ball(delta: float) -> void:
	_pos += _speed * delta
	update() # This method calls the draw() function
	
func reset_ball(player_serve: bool) -> void:
	_pos = _reset_pos # Assuming ball is centered on the screen
	_speed = _reset_speed if _player_serve else -_reset_speed
	update()
	
func inverse_Y_speed() -> void:
	_speed.y = -_speed.y
	
func inverse_X_speed() -> void:
	_speed = Vector2(-_speed.x, rand_range(-400.0, 0))
	
func get_position() -> Vector2:
	return _pos

func get_top_point() -> float:
	return _pos.y - _radius

func get_bottom_point() -> float:
	return _pos.y + _radius
	
	
