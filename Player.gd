extends Area2D

signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size

var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position


func _process(delta):
	var valocity = Vector2()
#	if (Input.is_action_pressed("ui_up")):
#		valocity.y -= 1
#
#	if (Input.is_action_pressed("ui_down")):
#		valocity.y += 1
#
#	if (Input.is_action_pressed("ui_left")):
#		valocity.x -= 1
#
#	if (Input.is_action_pressed("ui_right")):
#		valocity.x += 1

	if position.distance_to(target) > 10:
		valocity = target - position
		
	if (valocity.length() > 0):
		valocity = valocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += valocity * delta
	position.x = _sim_clamp(position.x, 0, screen_size.x)
	position.y = _sim_clamp(position.y, 0, screen_size.y)
	
	if valocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = valocity.x < 0
	if valocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = valocity.y > 0
		
func _sim_clamp(value, value_min, value_max):
	if (value < value_min):
		return value_min
	if (value_max < value):
		return value_max
	return value;


func _on_Player__body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disable", true) # Replace with function body.
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false
