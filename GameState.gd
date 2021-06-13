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

# Ball object instancing
onready var ball: Ball = Ball.new(Vector2(half_screen_width, half_screen_height))

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
onready var AI_rectangle = Rect2(AI_position, paddle_size)

# Font variable
var font = DynamicFont.new()
var roboto_font_file = load("res://assets/fonts/Roboto/Roboto-Black.ttf")
var font_size = 24
var half_font_width
var font_height
var string_value = "Start the game by pressing Spacebar."

# String variable
var string_position

# Delta key
const RESET_DELTA_KEY = 0.0
const MAX_KEY_TIME = 0.3
var delta_key_press = RESET_DELTA_KEY

# Player
var player_speed = 200.0

# Scoring
var player_score = 0
var player_score_text = player_score as String
var player_text_half_width
var player_score_position

var AI_score = 0
var AI_score_text = AI_score as String
var AI_text_half_width
var AI_score_position

const MAX_SCORE = 3
var is_player_win

func _ready() -> void:
	add_child(ball)
	
	font.font_data = roboto_font_file
	font.size = font_size
	half_font_width = font.get_string_size(string_value).x/2
	font_height = font.get_height()
	string_position = Vector2(half_screen_width - half_font_width, font_height)
	
	player_text_half_width = font.get_string_size(player_score_text).x/2
	player_score_position = Vector2(half_screen_width - (half_screen_width/2) - player_text_half_width, font_height + 50)
	AI_text_half_width = font.get_string_size(AI_score_text).x/2
	AI_score_position = Vector2(half_screen_width + (half_screen_width/2) - AI_text_half_width, font_height + 50)
	
func _physics_process(delta: float) -> void:
	delta_key_press += delta
	
	match current_game_state:
		GAME_STATE.MENU:
			if is_player_win == true:
				change_string("You won! Press Spacebar to start a new game.")
			elif is_player_win == false:
				# elif to not match null value
				change_string("AI won. Press Spacebar to start a new game.")
				
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY
				player_score_text = player_score as String
				AI_score_text = AI_score as String

		GAME_STATE.SERVE:
			set_starting_position()
			update()
			if player_score == MAX_SCORE:
				current_game_state = GAME_STATE.MENU
				player_score = 0
				AI_score = 0
				is_player_win = true
				
			if AI_score == MAX_SCORE:
				current_game_state = GAME_STATE.MENU
				player_score = 0
				AI_score = 0
				is_player_win = false
			
			if is_player_serve:
#				ball.reset_ball(is_player_serve)
				change_string("Player Serve: press Spacebar to serve.")
			else:
#				ball.reset_ball(is_player_serve)
				change_string("AI Serve: press Spacebar to serve.")
			
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.PLAY
				delta_key_press = RESET_DELTA_KEY
				
		GAME_STATE.PLAY:
			change_string("PLAY")
			if Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME:
				current_game_state = GAME_STATE.MENU
				delta_key_press = RESET_DELTA_KEY
			
			ball.move_ball(delta)
			
			if ball.get_position().x <= 0:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY
				is_player_serve = true
				
				# If the ball is touching the left side of the screen, AI scores a point
				AI_score += 1
				AI_score_text = AI_score as String
				
			if ball.get_position().x >= screen_width:
				current_game_state = GAME_STATE.SERVE
				delta_key_press = RESET_DELTA_KEY
				is_player_serve = false
				
				# If the ball is touching the right side of the screen, player scores a point
				player_score += 1
				player_score_text = player_score as String
				
			if ball.get_top_point() <= 0.0:
				ball.inverse_Y_speed()
			if ball.get_bottom_point() >= screen_height:
				ball.inverse_Y_speed()
			
			if Collisions.point_to_rect(ball.get_position(), Rect2(player_position, paddle_size)):
				ball.inverse_X_speed()
			
			if Collisions.point_to_rect(ball.get_position(), Rect2(AI_position, paddle_size)):
				ball.inverse_X_speed()
			
			
			# Player movement
			if Input.is_key_pressed(KEY_W):
				player_position.y += -player_speed * delta
				player_position.y = clamp(player_position.y, 0.0, screen_height - paddle_size.y)
				player_rectangle = Rect2(player_position, paddle_size)
			if Input.is_key_pressed(KEY_S):
				player_position.y += player_speed * delta
				player_position.y = clamp(player_position.y, 0.0, screen_height - paddle_size.y)
				player_rectangle = Rect2(player_position, paddle_size)
				
			# AI movement
			if ball.get_position().y > AI_position.y + (paddle_size.y/2 + 10):
				AI_position.y += 250 * delta # AI speed
			if ball.get_position().y < AI_position.y + (paddle_size.y/2 - 10):
				AI_position.y -= 250 * delta
			
			AI_position.y = clamp(AI_position.y, 0.0, screen_height - paddle_size.y)
			AI_rectangle = Rect2(AI_position, paddle_size)
			
			update()
	
func _draw() -> void:
	draw_rect(player_rectangle, paddle_color)
	draw_rect(AI_rectangle, paddle_color)
	draw_string(font, string_position, string_value)
	draw_string(font, player_score_position, player_score_text)
	draw_string(font, AI_score_position, AI_score_text)
	
func set_starting_position():
	AI_position = Vector2(screen_width - (paddle_padding + paddle_size.x), half_screen_height-half_paddle_height)
	AI_rectangle = Rect2(AI_position, paddle_size)
	
	player_position = Vector2(paddle_padding, half_screen_height-half_paddle_height)
	player_rectangle = Rect2(player_position, paddle_size)
	
	ball.reset_ball(is_player_serve)
	
func change_string(new_string_value):
	string_value = new_string_value
	half_font_width = font.get_string_size(string_value).x/2
	string_position = Vector2(half_screen_width - half_font_width, font_height)
	update()	# Force a call to the _draw() virtual method
