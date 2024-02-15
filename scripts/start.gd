extends Control


# Вызывается во время перехода на данную сцену
func _ready():
	#создается 2 кнопки
	for i in range(2):
		var butt = Button.new() #пустой шаблон кнопки записывается в переменную
		butt.position = Vector2(770, 480 + (i * 70)) #позиция кнопки в сцене
		butt.size = Vector2(400, 50) #размер кнопки
		butt.pivot_offset = Vector2(200, 25) #ось вращения устанавливается в центр кнопки
		#разные текста для 1й и 2й кнопки
		if i == 0:
			butt.text = "Continue Game"
		else:
			butt.text = 'New Game'
		add_child(butt) #кнопка выводится на экран
		butt.pressed.connect(self.clickButt.bind(i)) #передается сигнал с аргументом, у каждой кнопки свой аргумент
		

#функция, регестрирующая действия производимые в данной сцене
func _process(_delta):
	#перебирается каждая кнопка
	for i in get_child_count():
		var ms = get_global_mouse_position()
		if ms[0] > 740 and 1200 > ms[0] and 400 + (i * 70) < ms[1] and ms[1] < 470 + (i * 70):
			get_child(i).scale = Vector2(1.1, 1.1) #если дист. от кнопки до мышки меньше 30 пикселей, кнопка увел. в размерах
		else:
			get_child(i).scale = Vector2(1, 1) #в противополож. случае возвращ. исходный размер


#функция, приним. сигнал от кнопки с аргументом, нужным для отборочного выполнения действий
func clickButt(x):
	if x == 0:
		Global.refresh()
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		Global.refresh()
		get_tree().change_scene_to_file("res://scenes/main.tscn")
