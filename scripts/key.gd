extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# если нажата кнопка 'f' и игрок в зоне артефакта, глобальная переменная, отвечающая за колличество
# собраных артефактов пополняется на единицу. следом за этим артефакт удаляется со сцены
func _process(_delta):
	$AnimationPlayer.play("idle") # постоянно проигрывается анимация 'idle'
	if Input.is_action_just_pressed("f") and Global.can_take:
		Global.key_count += 1
		self.queue_free()


# если персонаж вошел в зону
func _on_area_2d_body_entered(body):
	if body.has_method('player'):
		Global.can_take = true # передается информация о том, что персонаж в зоне
		$KeyboardF.visible = true # кнопка взаимодействия становится видимой

#
func _on_area_2d_body_exited(body):
	if body.has_method('player'):
		Global.can_take = false # передается информация о том, что персонаж не в зоне
		$KeyboardF.visible = false # кнопка взаимодействия становится невидимой
