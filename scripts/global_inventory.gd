extends Node

signal bags_updated(index: int)
signal items_updated

var bag_slots: Array[Inventory_Slot]: 
	get: return bag_slots
	# TODO: We will eventually like to do some validation on the bag_slots array
	set(value):
		if value.size() > 4:
			return
		bag_slots = value

var items: Array[Item_Template]:
	get: return items
	set(value):
		items = value
		items_updated.emit()

func _ready() -> void:

	# TODO: Items should be received by the server instead of instantiated locally

	# Fill the array with four bag slots
	for n in 4: 
		var bag_slot: Inventory_Slot = Inventory_Slot.new(
			Item_Template.ITEM_CLASS.CONTAINER,
			Item_Template.ITEM_SUBCLASS.BAG
		)
		bag_slot.slot_changed.connect(_on_slot_changed)
		bag_slots.append(bag_slot)

	var new_bag: Item_Template = Item_Template.new(
		1,
		Item_Template.ITEM_CLASS.CONTAINER,
		Item_Template.ITEM_SUBCLASS.BAG,
		"Backpack",
		preload("res://prefabs/backpack.tres"),
		false,
		8,
		"A sturdy backpack for carrying items."
	)
	for n in bag_slots:
		if n.item == null:
			n.item = new_bag
			break

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

func _on_slot_changed(slot: Inventory_Slot) -> void:
	var index: int = bag_slots.find(slot)
	bags_updated.emit(index)