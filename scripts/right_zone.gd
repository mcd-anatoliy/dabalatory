extends Node2D

var c = 0
var d = 0

# Called when the node enters the scene tree for the first time.
# если артефакт был собран ранее, то при повторном заходе на сцену артефакт удаляется
func _ready():
	if Global.rz:
		$key.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# если игрок собрал артефакт на сцене, то в глобальную переменную передается информация о том,
# что он был собран конкретно в этой сцене
func _process(_delta):
	if Global.can_take and Input.is_action_just_pressed("f"):
		Global.rz = true


# если персонаж в зоне перемещения
func _on_hall_body_entered(body):
	if body.has_method('player'):
		Global.hall_exit = true
		$transition.transition()


# переход на сцену, взависимости от зоны перемещения
func _on_transition_transitioned():
	if d == 0:
		get_tree().change_scene_to_file("res://scenes/hall.tscn")
	elif d == 1:
		get_tree().change_scene_to_file("res://scenes/the_end.tscn")


# если персонаж защел в зону, то скрытая область становится видимой
func _on_upal_v_pvpshku_body_entered(body):
	if body.has_method('player') and c == 0:
		$pvpshnica.queue_free()
		c = 1


# если игрок зашёл в зону перемещения
func _on_area_2d_body_entered(body):
	if body.has_method('player'):
		d = 1
		$transition.transition()
