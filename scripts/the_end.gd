extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var butt = Button.new() #пустой шаблон кнопки записывается в переменную
	butt.position = Vector2(350, 480) #позиция кнопки в сцене
	butt.size = Vector2(450, 50) #размер кнопки
	butt.pivot_offset = Vector2(200, 25) #ось вращения устанавливается в центр кнопки
	butt.text = "New Game" # текст кнопки
	add_child(butt) #кнопка выводится на экран
	butt.pressed.connect(self.clickButt.bind(1)) #передается сигнал с аргументом


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in get_child_count():
		var ms = get_global_mouse_position()
		if ms[0] > 350 and 800 > ms[0] and 450 < ms[1] and ms[1] < 535:
			get_child(3).scale = Vector2(1.1, 1.1) #если дист. от кнопки до мышки меньше 30 пикселей, кнопка увел. в размерах
		else:
			get_child(3).scale = Vector2(1, 1) #в противополож. случае возвращ. исходный размер


# переход на начальную сцену игры
func clickButt(x):
	if x == 1:
		Global.refresh()
		get_tree().change_scene_to_file("res://.godot/exported/133200997/export-3ad5c15c4f3250da0cc7c1af1770d85f-main.scn")
