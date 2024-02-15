extends CharacterBody2D


@export var Bullet : PackedScene
@export var speed = 54
@export var gravity = 630
@onready var pid = $poprigunchik
#игрок в области(bool)
var player_chase = false
var player = null
var health = 100
var player_inattack_range = false
var can_take_damage = true
var ubili_pistoletom = false
var can_walk = true
var umer = false


func _physics_process(delta):
	deal_with_damage()
	health_update()
	
	
	if umer == false:
		enemy()
	
	#гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	#если игрок в области
	if player_chase and umer == false:
		position += (player.position - position) / speed #преследование игрока
		
		if can_walk:
			pid.play('walk') #анимация ходьбы
		#поворот бота в зависимости от направления
		if (player.position.x - position.x) < 0:
			pid.flip_h = true
		else:
			pid.flip_h = false
	else:
		if can_walk and umer == false:
			pid.play('idle') #если игрок не в области, то проигравается анимация статичного положения

	move_and_slide()

#вход в область отслеживания
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

#выход из области отслеживания
func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false


# функция отвечающая за анимацию удара
func enemy():
	if Global.enemy_attack and Global.enemy_damaged == false:
		pid.play('attack')
		can_walk = false
		$attack.start()


# проверяет попала ли в бота пуля или персонаж
func _on_pid_hitbox_body_entered(body):
	if body.has_method("attack"):
		player_inattack_range = true
	if body.has_method('ubiystvo'):
		ubili_pistoletom = true



# проверяет вышел ли игрок из облати бота
func _on_pid_hitbox_body_exited(body):
	if body.has_method("attack"):
		player_inattack_range = false


# функция отвечабщая за получение урона
func deal_with_damage():
	if player_inattack_range and Global.player_current_attack: # если игрок атакует
		if can_take_damage:
			health -= 20 # уменьшается здоровье
			Global.enemy_damaged = true
			pid.play('damage') # анимация получения урона
			can_walk = false
			can_take_damage = false
			$attack_cooldown.start() # кулдаун атаки
			if health <= 0: # если HP истрачено
				pid.play("death") # анимация смерти
				umer = true
				$smert.start()
	if ubili_pistoletom: # если во врага попала пуля
		health -= 10 # HP уменьшается
		Global.enemy_damaged = true
		pid.play('damage') # анимация получения урона
		can_walk = false
		ubili_pistoletom = false
		$attack_cooldown.start() # кулдаун атаки
		if health <= 0: # если HP истрачено
			pid.play("death") # анимация смерти
			umer = true
			$smert.start()


# когда прошел кулдаун атаки
func _on_attack_cooldown_timeout():
	can_take_damage = true
	can_walk = true
	Global.enemy_damaged = false


# функция отвечающая за обновление значений HealthBar
func health_update():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 200: # если HP полное, то HelathBar становится невидимым
		healthbar.visible = false
	else: # если HP не полное, то HelathBar становится видимым
		healthbar.visible = true


# когда закончился таймер смерти, бот исчезает
# таймер нужен для того, чтобы бот не умерал сразу, а успела проиграться анимация смерти
func _on_smert_timeout():
	can_walk = false
	self.queue_free()


func _on_attack_timeout():
	can_walk = true
