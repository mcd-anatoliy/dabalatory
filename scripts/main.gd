extends Node2D

# Called when the node enters the scene tree for the first time.
# меняет положение персонажа на сцене при возвращении в эту сцену
func _ready():
	if Global.exit_pos:
		$player.position.x = 762
		$player.position.y = -12


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# вошел ли персонаж в зону перемешения
func _on_area_2d_body_entered(body):
	if body.has_method('player'):
		Global.exit_pos = true
		$transition.transition() # вызыает функцию отвечабщую за плавный переход


# при получении эмитированного сигнала от сцены перехода, меняет сцену на сцену "hall"
func _on_transition_transitioned():
	get_tree().change_scene_to_file("res://scenes/hall.tscn")
