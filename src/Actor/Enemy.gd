extends "res://src/Actor/Actor.gd"

func _ready() -> void:
	velocity.x = -speed2.x
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	velocity.y = move_and_slide(velocity, floor_normal).y
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1
	if velocity.x > 0 :
		$EnemySprite.play("run")
		$EnemySprite.flip_h = false
	if velocity.x < 0 :
		$EnemySprite.play("run")
		$EnemySprite.flip_h = true
	


func _on_Area2D_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y :
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
