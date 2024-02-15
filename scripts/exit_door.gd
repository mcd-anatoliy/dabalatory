extends CharacterBody2D

var pl = null
var open = 0
var exit = false
var enter = false


# если персонаж вошел в зону и собраны все 3 артефакта
func _on_area_2d_body_entered(body):
	if body.has_method('player') and Global.key_count == 3:
		$KeyboardF.visible = true # кнопка взаимодействия становится видимой
		$AnimationPlayer.play("f") # проигрывается анимация кнопки
		pl = body # в переменную передаются параметры обьекта вошедшего в зону (в данном случае персонаж)
		exit = false
		enter = true


# если персонаж вышел из зоны
func _on_area_2d_body_exited(body):
	if body.has_method('player'):
		rotation_degrees += 180 # сцена поворачивается на 180 градусов
		$KeyboardF.rotation_degrees += 180 # кнопка поворачивается на 180 градусов 
		$KeyboardF.visible = false # кнопка взаимодействия становится невидимой
		exit = true
		enter = false


func _physics_process(_delta):
	if Input.is_action_just_pressed('f') and enter: # если нажата кнопка 'f' и персонаж находится в зоне
		$KeyboardF.visible = false # кнопка взаимодействия становится невидимой
		open = 1
	# анимация открытия двери
	if open == 1:
		$AnimationPlayer.play("open")
	# анимация закрытия двери
	if open == 2 and exit:
		$AnimationPlayer.play('close')
		$".".collision_layer = 1
		$".".collision_mask = 1


# когда анимация закончилась
func _on_animation_player_animation_finished(anim_name):
	# если это анимация открытия двери
	if anim_name == 'open':
		$".".collision_layer = 4 # колизия меняется на другой слой, для того чтобы персонаж мог пройти через дверь
		$".".collision_mask = 4
		open = 2 # следующая анимация 'закрытие'
	# если это анимация закрытия двери
	elif anim_name == 'close':
		open = 0 # следующей анимации не будет
