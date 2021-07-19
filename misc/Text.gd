extends Node2D

class_name Text

var _font: DynamicFont = DynamicFont.new()
var _value: String = ""
var _half_width: float
var _height: float
var _pos: Vector2
var _center_pos: Vector2 # This is where our string centers to

func _init(value: String, position: Vector2, size := 24, file := load("res://assets/fonts/Roboto/Roboto-Black.ttf")) -> void:
	_font.set_font_data(file)
	_font.set_size(size)
	_value = value
	_half_width = _font.get_string_size(_value).x/2.0
	_height = _font.get_height()
	_center_pos = position
	_pos = Vector2(_center_pos.x - _half_width, _center_pos.y + _height)

func _draw() -> void:
	draw_string(_font, _pos, _value)

func update_string(new_value: String) -> void:
	_value = new_value
	_half_width = _font.get_string_size(_value).x/2.0
	_pos = Vector2(_center_pos.x - _half_width, _center_pos.y + _height)
	update()