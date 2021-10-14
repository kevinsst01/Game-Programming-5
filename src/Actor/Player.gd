extends Actor

var impulse : = 700.0

func _physics_process(delta: float) -> void:
	var direction: =calculate_direction()
	if direction.x == 1.0 and is_on_floor() :
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif direction.x  == -1.0 and is_on_floor() :
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	elif direction.x == 0.0 and is_on_floor() :
		$AnimatedSprite.play("idle")
	velocity = calculate_velocity(velocity, speed, direction)
	velocity = move_and_slide(velocity, floor_normal)
	if velocity.y > 0 :
		if velocity.x > 0 :
			$AnimatedSprite.play("fall")
			$AnimatedSprite.flip_h = false
		if velocity.x < 0 :
			$AnimatedSprite.play("fall")
			$AnimatedSprite.flip_h = true
	elif velocity.y < 0 :
		if velocity.x > 0 :
			$AnimatedSprite.play("jump")
			$AnimatedSprite.flip_h = false
		if velocity.x < 0 :
			$AnimatedSprite.play("jump")
			$AnimatedSprite.flip_h = true

func calculate_direction() -> Vector2 :
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_velocity(
		velocity : Vector2,
		speed : Vector2,
		direction : Vector2
	) -> Vector2 :
	var main_velocity : = velocity
	main_velocity.x = speed.x * direction.x
	main_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0 :
		main_velocity.y = speed.y * direction.y
	return main_velocity


func _on_PlayerDetector_area_entered(area: Area2D) -> void:
	velocity = stomp_velocity(velocity, impulse)

func stomp_velocity(velocity : Vector2, impulse : float) -> Vector2:
	var main_velocity : = velocity
	main_velocity.y = -impulse
	return main_velocity


func _on_PlayerDetector_body_entered(body: Node) -> void:
	queue_free()
