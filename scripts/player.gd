extends CharacterBody2D

@onready var bullet = load("res://scenes/bullet.tscn")
@export var speed = 180
@export var rotation_speed = 4
@export var gravity = 630
var enemy_inattack_range = false
var enemy = null
var enemy_attack_cooldown = true
var health = 200
var attack_ip = false
var enemy_nemosh = true
var padaet = true
var can_walk = true
var umer = false
var alive = true
var landing = false


#импорт настроек персонажа
@onready var pl = $player


var rotation_direction = 0

#ввод градусов поворота
func get_input():
	rotation_direction = Input.get_axis("p_left", "p_right")


func _physics_process(delta):
	get_input()
	enemy_attack()
	health_update()
	
	
	# если персонаж умер 
	if umer:
		death()
	
	
	# если жив
	if alive:
		# вызывается функция стрельбы, если персонаж не находится вблизи врага и игрок нажал клавишу "e"
		if Input.is_action_just_pressed("shoot"):
			if enemy_nemosh:
				shoot()
				
			# в противном случает на экран выводится сообщение
			else:
				$StaticBody2D.visible = true
		
		
		if enemy_nemosh:
			$StaticBody2D.visible = false
		
		
		#если не на земле, то может летать
		if not is_on_floor():
			landing = true
			# анимация падения
			if padaet and can_walk:
				pl.play('idle')
		
			# поворот персонажа в воздухе, который зависит от введенных дальше по коду в функции
			# "get_input()" значений направления
			rotation += rotation_direction * rotation_speed * delta

			#гравитация
			velocity.y += gravity * delta

		#если на земле, то включается обычное перемещение
		if is_on_floor():
			# функция отвечающая за атаку, вызывается только когда персонаж находится на земле
			# для того, чтобы не было возможности атаковать вблизи, находясь в воздухе
			attack()
			
			# если персонаж только что приземлился
			if landing:
				pl.play('landing') # проигрывается анимация кувырка
				can_walk = false
				landing = false
				$landing.start() # таймер действия анимации
				
			# персонаж становится прямо, если находится на земле
			rotation = 0
			
			#перемещение
			if Input.is_action_pressed("p_right"):
				velocity.x = speed
				if can_walk:
					pl.play('run') # анимация ходьбы
			elif Input.is_action_pressed("p_left"):
				velocity.x = -speed
				if can_walk:
					pl.play('run') # анимация ходьбы
			else:
				velocity.x = 0
				if can_walk:
					pl.play('idle') # анимация пассивного стояния

		# полет
		if Input.is_action_pressed("p_up"):
			if Input.is_action_pressed("shoot"): # если персонаж в воздухе и нажата клавиша 'e'
				pl.play("fly_shoot") # проигрывается анимация стрельбы в полете
			else:
				pl.play('fly') # в противном случае проигрывается анимация обычного полета
			padaet = false
			velocity = transform.y * -speed
		else:
			padaet = true # переменная, нужная для проверки падает ли персонаж сейчас, чтобы включить анимацию падения

		# поворот персонажа и координат отсчета спавна пули взависимости от направления движения
		if velocity.x < 0:
			pl.flip_h = true
			$Muzzle.position.x = -20
			$Muzzle.position.y = 8
			$Muzzle.rotation_degrees = 180 
		elif velocity.x > 0:
			pl.flip_h = false
			$Muzzle.position.x = 20
			$Muzzle.position.y = 4
			$Muzzle.rotation_degrees = 0
	
	
	move_and_slide()


#смерть
func death():
	health = 0
	set_physics_process(false) #остановка физического процесса
	get_tree().reload_current_scene() #перезапуск текущей сцены
	get_tree().change_scene_to_file("res://scenes/death_wish.tscn") #переход на сцену смерти


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"): #если у обьекта вошедшего в область есть функция bullet
		enemy_inattack_range = true #то он может атаковать
		enemy_nemosh = false


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"): #если у обьекта вышедшего из области есть функция enemy
		enemy_inattack_range = false #то он не может атаковать
		enemy_nemosh = true


func enemy_attack():
	#если бот может аттаковать, прошёл кулдаун и бот не находится в стане (тоесть не атакован в данный момент)
	if enemy_inattack_range and enemy_attack_cooldown and Global.enemy_damaged == false:
		Global.enemy_attack = true
		health -= 30 #здоровье уменьшается на 30
		pl.play('damage') # проигрывается анимация получения урона
		can_walk = false
		enemy_attack_cooldown = false #время кулдауна включается
		$attack_cooldown.start()
		#если здоровье истрачено, вызывается функция отвечающая за смерть персонажа
		if health <= 0:
			alive = false
			pl.play("death") # проигрывается анимация смерти
			$death.start()


#таймер кулдауна
func _on_attack_cooldown_timeout():
	$attack_cooldown.stop()
	enemy_attack_cooldown = true
	Global.enemy_attack = false
	can_walk = true


# функция атаки
func attack():
	# если нажата ЛКМ
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true # персонаж может атаковать
		pl.play("attack") # проигрывается анимация атаки
		can_walk = false
		$landing.start()
		$deal_attack_timer.start()


# таймер атаки персонажа
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false


# функция, обновляющая HelathBar
func health_update():
	var healthbar = $Healthbar # в переменную передается узел шкалы здоровья
	healthbar.value = health # значение шкалы равняется значению здоровья у персонажа сейчас
	if health >= 200:
		healthbar.visible = false # если здоровье максимальное, то Healthbar становится невидимым
	else:
		healthbar.visible = true # в ином случае HealthBar становится видимым


# таймер отвечающий за регенерацию
func _on_regen_timer_timeout():
	# если HP большу 0, но меньше 200 и кулдаун атаки врага прошел(тоесть враг сейчас не атакует)
	if health <= 200 and health > 0 and enemy_attack_cooldown:
		health += 20 # здоровье увеличивается на 20
		if health > 200:
			health = 200 # если здоровье отрегенерировалось больше максимального значения, то его значение
						# становится равным максимальному


# функция отвечающая за стрельбу
func shoot():
	pl.play('shoot') # проигрывается анимация стрельбы на земле
	can_walk = false
	$shoot_timer.start()
	var b = bullet.instantiate() # в переменную передается заранее запакованная сцена пули
	owner.add_child(b) # на сцену добавляется сцена пули
	
	# положение и угол поворота пули на сцене равняется положению и углу поворота 
	# точки отсчета (для пули) на сцене, тоесть пуля вылетает конкретно из данной точки, следующей
	# за персонажем
	b.transform = $Muzzle.global_transform


# функция, нужная для проверки в скрипте врага, что именно персонаж зашел в зону обнаружения врагом,
# нужно это для того, чтобы враг не преследавал и не получал урон от любого другого объекта имеющего
# физику, к примеру: пуля, артефакт, дверь и т.п
func player():
	pass


# таймер смерти, нужный для того, чтобы успела проиграться анимация смерти персонажа,
# перед его логической кончиной
func _on_death_timeout():
	$death.stop()
	umer = true


# таймер выстрела
func _on_shoot_timer_timeout():
	$shoot_timer.stop()
	can_walk = true


# таймер приземления
func _on_landing_timeout():
	$landing.stop()
	can_walk = true
