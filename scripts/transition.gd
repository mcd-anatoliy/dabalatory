extends CanvasLayer


# создание сигнала
signal transitioned

#func _ready():
#	transition()


# функция, которая будет выщываться из других скриптов, для плавного перехода на сцену
func transition():
	$ColorRect.visible = true # fade становится видимым
	$AnimationPlayer.play('fade_to_black') # проигрывается анимация затемнения


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fade_to_black': # если закончилась анимация затемнения
		
		# эмитируется сигнал, он будет приниматься в других скриптах, как катализатор перехода на другую сцену
		emit_signal('transitioned') # сцена не меняется, пока из данного скрипта не будет эмитирован сигнал
		
		$AnimationPlayer.play('fade_to_normal') # проигрывается анимация выхода из темноты
	if anim_name == 'fade_to_normal': # если анимация выхода из темноты закончилась
		$ColorRect.visible = false # fade становится невидимым
