extends Node2D


# Called when the node enters the scene tree for the first time.
# если артефакт был собран игроком ранее, то при повторном заходе на сцену артефакт автоматически удаляется
func _ready():
	if Global.ut:
		$key.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# если игрок собрал артефакт, то в глобальную переменную передается информация о том, что артефакт
# был собран
func _process(_delta):
	if Global.can_take and Input.is_action_just_pressed("f"):
		Global.ut = true


# переход на сцену "hall"
func _on_transition_transitioned():
	get_tree().change_scene_to_file("res://scenes/hall.tscn")


# если персонаж зашел в зону перемещения
func _on_hall_body_entered(body):
	if body.has_method('player'):
		Global.up_exit = true
		$transition.transition()
