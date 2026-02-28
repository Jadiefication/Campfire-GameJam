extends Node

signal money_changed(new_amount)

var money: int = 0:
	set(value):
		money = value
		money_changed.emit(money)
