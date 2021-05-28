extends Node2D

# States
enum GAME_STATE {MENU, SERVE, PLAY}
var is_player_serve = true

# Current state
var current_game_state = GAME_STATE.MENU

# Screen values
# onready to set the variable after everything is ready
onready var screen_width = get_tree().get_root().size.x
onready var screen_height = get_tree().get_root().size.y
onready var half_screen_height = screen_height/2
onready var half_screen_width = screen_width/2

# Ball variables
var ball_radius = 10.0
var ball_color = Color.white
onready var starting_ball_position = Vector2(half_screen_width, half_screen_height)
onready var ball_position = starting_ball_position

# Ball speed
var starting_speed = Vector2(400.0, 0.0)
var ball_speed = starting_speed 

# Paddle variables
var paddle_color = Color.white
var paddle_size = Vector2(10.0, 100.0)
var half_paddle_height = paddle_size.y/2
var paddle_padding = 10.0

# Player paddle
onready var player_position = Vector2(paddle_padding, half_screen_height-half_paddle_height)
onready var player_rectangle = Rect2(player_position, paddle_size)

# AI paddle
onready var AI_position = Vector2(screen_width - (paddle_padding + paddle_size.x), half_screen_height-half_paddle_height)
onready var AI_start_position = Rect2(AI_position, paddle_size)

# Font variable
var font = DynamicFont.new()
var roboto_font_file = load("res://assets/fonts/Roboto/Roboto-Black.ttf")
var font_size = 24
var half_font_width
var font_height
var string_value = "Hello world"

# String variable
var string_position

# Delta key
const RESET_DELTA_KEY = 0.0
const MAX_KEY_TIME = 0.3
var delta_key_press = RESET_DELTA_KEY

# Player
var player_speed = 200.0

func _ready() -> void:
	font.font_data = roboto_font_file
	font.size = font_size
	half_font_width = font.get_string_size(string_value).x/2
	font_height = font.get_height()
	string_position = Vector2(half_screen_width - half_font_width, font_height)
	
func _physics_process(delta: float) -> void:
	delta_key_press += delta
	
	match current_game_state:
		GAME_STATE.MENU:
			change_string("MENU")
			
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY

		GAME_STATE.SERVE:
			ball_position = starting_ball_position
			
			if is_player_serve:
				ball_speed = starting_speed
				change_string("Player Serve")
			else:
				ball_speed = -starting_speed
				change_string("AI Serve")
			
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.PLAY
				delta_key_press = RESET_DELTA_KEY
				
		GAME_STATE.PLAY:
			change_string("PLAY")
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.MENU
				delta_key_press = RESET_DELTA_KEY
			
			ball_position += ball_speed * delta
			
			if ball_position.x <= 0:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY
				is_player_serve = true
				
			if ball_position.x >= screen_width:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY
				is_player_serve = false
			
			if (ball_position.x - ball_radius >= player_position.x and
			ball_position.x - ball_radius <= player_position.x + paddle_size.x):
				var paddle_section = paddle_size.y/3
				
				if (ball_position.y >= player_position.y and
				ball_position.y <= player_position.y + paddle_section):
					var temp_ball_speed = Vector2(-ball_speed.x, -400.0)
					ball_speed = temp_ball_speed
				elif (ball_position.y > player_position.y + paddle_section and
				ball_position.y <= player_position.y + paddle_section * 2):
					var temp_ball_speed = Vector2(-ball_speed.x, 0.0)
					ball_speed = temp_ball_speed
				elif (ball_position.y > player_position.y + paddle_section * 2 and
				ball_position.y <= player_position.y + paddle_section * 3):
					var temp_ball_speed = Vector2(-ball_speed.x, 400.0)
					ball_speed = temp_ball_speed
				
			if (ball_position.x + ball_radius >= AI_position.x and
			ball_position.x + ball_radius <= AI_position.x + paddle_size.x):
				var paddle_section = paddle_size.y/3
				
				if (ball_position.y >= AI_position.y and
				ball_position.y < AI_position.y + paddle_section):
					var temp_ball_speed = Vector2(-ball_speed.x, -400.0)
					ball_speed = temp_ball_speed
				elif (ball_position.y >= AI_position.y + paddle_section and
				ball_position.y < AI_position.y + paddle_section * 2):
					var temp_ball_speed = Vector2(-ball_speed.x, 0.0)
					ball_speed = temp_ball_speed
				elif (ball_position.y >= AI_position.y + paddle_section * 2 and
				ball_position.y < AI_position.y + paddle_section * 3):
					var temp_ball_speed = Vector2(-ball_speed.x, 400.0)
					ball_speed = temp_ball_speed
					
			# TODO: Add collisions to to the top and bottom edges of the screen
				
			# Player movement
			if Input.is_key_pressed(KEY_W):
				player_position.y += -player_speed * delta
				player_rectangle = Rect2(player_position, paddle_size)
			if Input.is_key_pressed(KEY_S):
				player_position.y += player_speed * delta
				player_rectangle = Rect2(player_position, paddle_size)
			
			update()
	
func _draw() -> void:
	set_starting_position()
	
func set_starting_position():
	draw_circle(ball_position, ball_radius, ball_color)
	draw_rect(player_rectangle, paddle_color)
	draw_rect(AI_start_position, paddle_color)
	draw_string(font, string_position, string_value)
	
func change_string(new_string_value):
	string_value = new_string_value
	half_font_width = font.get_string_size(string_value).x/2
	string_position = Vector2(half_screen_width - half_font_width, font_height)
	update()	# Force a call to the _draw() virtual method
