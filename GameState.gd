extends Node2D

# States
enum GAME_STATE {MENU, SERVE, PLAY}
var is_player_serve: bool = true

# Current state
var current_game_state = GAME_STATE.MENU
var player_score: int = 0
var AI_score: int = 0
var _SCORE_HEIGHT_PADDING: float = 50.0

# Screen values
# onready to set the variable after everything is ready
onready var screen: Rect2 = get_tree().get_root().get_visible_rect()
onready var screen_box: BoundingBox = BoundingBox.new(screen)

# Ball object instancing
onready var ball: Ball = Ball.new(screen_box.get_center())
onready var player_paddle: PlayerPaddle = PlayerPaddle.new(screen_box)
onready var AI_paddle: AIPaddle = AIPaddle.new(screen_box)
onready var instruction_text: Text = Text.new(
	"Start a game by pressing the spacebar",
	Vector2(screen_box.get_size().x/2.0, 0.0)
)
onready var player_score_text: Text = Text.new(
	player_score as String,
	Vector2(screen_box.get_size().x/4.0, _SCORE_HEIGHT_PADDING) # 25% from the left
)
onready var AI_score_text: Text = Text.new(
	player_score as String,
	Vector2(screen_box.get_size().x - screen_box.get_size().x/4.0, _SCORE_HEIGHT_PADDING) # 25% from the right
)

# Delta key
const RESET_DELTA_KEY = 0.0
const MAX_KEY_TIME = 0.3
var delta_key_press = RESET_DELTA_KEY

const MAX_SCORE = 3
var is_player_win

func _ready() -> void:
	add_child(ball)
	add_child(player_paddle)
	add_child(AI_paddle)
	add_child(instruction_text)
	add_child(player_score_text)
	add_child(AI_score_text)
	
func _physics_process(delta: float) -> void:
	delta_key_press += delta
	
	match current_game_state:
		GAME_STATE.MENU:
			check_change_state(GAME_STATE.SERVE)

		GAME_STATE.SERVE:
			set_starting_position()
			check_winner()
			check_change_state(GAME_STATE.PLAY)
				
		GAME_STATE.PLAY:
			instruction_text.update_string("W = Move up; S = Move down")
			move_objects(delta)
			check_collisions()
			check_change_state(GAME_STATE.SERVE) # Debug. Delete before submitting
	
func move_objects(delta: float):
	player_paddle.check_movement(delta)
	AI_paddle.check_movement(delta, ball.get_position())
	ball.move_ball(delta)


func set_starting_position():
	player_paddle.reset_position()
	AI_paddle.reset_position()
	ball.reset_ball(is_player_serve)
	AI_score_text.update_string(AI_score as String)
	player_score_text.update_string(player_score as String)

	if is_player_serve:
		instruction_text.update_string("Player Serve: press Spacebar to serve.")
	else:
		instruction_text.update_string("AI Serve: press Spacebar to serve.")


func check_change_state(new_state: int) -> void:
	if space_bar_delay():
		current_game_state = new_state
		delta_key_press = RESET_DELTA_KEY


func space_bar_delay() -> bool:
	return Input.is_key_pressed(KEY_SPACE) and delta_key_press > MAX_KEY_TIME


func game_point_player(player_win: bool) -> void:
	current_game_state = GAME_STATE.SERVE
	delta_key_press = RESET_DELTA_KEY
	is_player_serve = !player_win
	
	player_score += 1 if player_win else 0
	AI_score += 1 if !player_win else 0

	AI_score_text.update_string(AI_score as String)
	player_score_text.update_string(player_score as String)

func check_collisions() -> void:
	if screen_box.is_pass_left_bound(ball.get_position()):
		game_point_player(false)
		
	if screen_box.is_pass_right_bound(ball.get_position()):
		game_point_player(true)
		
	if screen_box.is_pass_top_bound(ball.get_top_point()) and ball.is_moving_up():
		ball.inverse_Y_speed()
	if screen_box.is_pass_bottom_bound(ball.get_bottom_point()) and ball.is_moving_down():
		ball.inverse_Y_speed()
	
	if Collisions.point_to_rect(ball.get_position(), player_paddle.get_rect()) and ball.is_moving_left():
		ball.inverse_X_speed()
	if Collisions.point_to_rect(ball.get_position(), AI_paddle.get_rect()) and ball.is_moving_right():
		ball.inverse_X_speed()

func check_winner() -> void:
	match MAX_SCORE:
		player_score:
			current_game_state = GAME_STATE.MENU
			player_score = 0
			AI_score = 0
			is_player_win = true
			instruction_text.update_string("You won! Press Spacebar to start a new game.")
			
		AI_score:
			current_game_state = GAME_STATE.MENU
			player_score = 0
			AI_score = 0
			is_player_win = false
			instruction_text.update_string("AI won. Press Spacebar to start a new game.")