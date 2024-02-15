extends Node

var exit_pos = false
var player_current_attack = false
var hall_exit = false
var up_exit = false
var enemy_attack = null
var enemy_damaged = false
var key_count = 0
var can_take = false
var rz = false
var ut = false
var hl = false


# функция, которая вызывается при смерти или полном прохождении, чтобы сбросить все изменения
# переменных в глобальном скрипте
func refresh():
	exit_pos = false
	player_current_attack = false
	hall_exit = false
	up_exit = false
	enemy_attack = null
	enemy_damaged = false
	key_count = 0
	can_take = false
	rz = false
	ut = false
	hl = false


# это глобальный скрипт в котором записаны переменные, используемые в других скриптах, это упрощает
# передачу значений от одного скрипта к другому. Сделать скрипт глобальным можно в настройках проекта.
# К любой функции, переменной и любому сигналу из данного скрипта можно получить доступ в любом другом скрипте
# в любое удобное время
