extends Area2D

var speed = 750


# базовое перемещение по прямой с постоянной скоростью, учитывающее поворот персонажа
func _physics_process(delta):
	position += transform.x * speed * delta


# при попадание в обьект с колизией пуля исчезает
func _on_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
