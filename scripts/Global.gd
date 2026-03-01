extends Node

signal money_changed(new_amount)

var money: int = 0:
	set(value):
		money = value
		money_changed.emit(money)
		
signal hp_changed(new_amount)

var hp: int = 100:
	set(value):
		hp = value
		hp_changed.emit(value)

signal max_hp_changed(new_amount)

var max_hp: int = 100:
	set(value):
		max_hp = value
		max_hp_changed.emit(value)
