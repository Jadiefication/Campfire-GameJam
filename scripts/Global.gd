extends Node
var pipe_upgrade_cost: int = 500
var hp_upgrade_cost: int = 500
var speed_upgrade_cost: int = 500
signal money_changed(new_amount)

var money: int = 0:
	set(value):
		if value > money:
			total_money += (value - money)
		money = value
		money_changed.emit(money)
		
signal hp_changed(new_amount)

var hp: int = 100:
	set(value):
		hp = value
		hp_changed.emit(value)
		
var total_money: int = 0
var rope_length: int = 1050:
	set(value):
		rope_length = value
		rope_length_changed.emit(value)

signal rope_length_changed(new_amount)
signal max_hp_changed(new_amount)
signal speed_changed(new_amount)

var speed: float = 300:
	set(value):
		speed = value
		speed_changed.emit(value)

var max_hp: int = 100:
	set(value):
		max_hp = value
		max_hp_changed.emit(value)
