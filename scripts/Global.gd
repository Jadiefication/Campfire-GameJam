extends Node

signal money_changed(new_amount)

var money: int = 0:
	set(value):
		money = value
		if value > 0:
			total_money = value
		money_changed.emit(money)
		
signal hp_changed(new_amount)

var hp: int = 100:
	set(value):
		hp = value
		hp_changed.emit(value)
		
var total_money: int = 0
