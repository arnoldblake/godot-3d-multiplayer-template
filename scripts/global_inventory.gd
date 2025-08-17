extends Node

signal bags_updated
signal items_updated

var bags: Array[Item_Template]:
	get: return bags
	# TODO: We will eventually like to do some validation on the bags array
	set(value):
		if value.size() > 4:
			return
		bags = value
		bags_updated.emit()

var items: Array[Item_Template]:
	get: return items
	set(value):
		items = value
		items_updated.emit()

func _ready() -> void:
	# TODO: Items should be received by the server instead of instantiated locally
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

	new_bag = bags.duplicate()
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

	var new_items: Array[Item_Template] = items.duplicate()
	new_items.append(Item_Template.new(
		1,
		Item_Template.ITEM_CLASS.CONSUMABLE,
		Item_Template.ITEM_SUBCLASS.POTION,
		"Health Potion",
		preload("res://prefabs/health_potion.tres"),
		false,
		1,
		"A potion that restores health."
	))
	items = new_items
