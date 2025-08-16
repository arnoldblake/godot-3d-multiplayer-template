# TODO: Items should be received by the server instead of instantiated locally
extends Node

signal bags_updated

var bags: Array[Item_Template]:
	get: return bags
	# TODO: We will eventually like to do some validation on the bags array
	set(value): 
		bags = value
		bags_updated.emit()

func _ready() -> void:
	var new_bag: Array[Item_Template] = bags.duplicate()
	new_bag.append(Item_Template.new(
		1, 
		Item_Template.ITEM_CLASS.CONTAINER, 
		Item_Template.ITEM_SUBCLASS.BAG, 
		"Backpack", 
		preload("res://prefabs/backpack.tres"), 
		false, 
		8,
		"A sturdy backpack for carrying items."
	))
	bags = new_bag
