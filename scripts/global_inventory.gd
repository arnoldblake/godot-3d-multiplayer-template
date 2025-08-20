extends Node

signal bags_updated(bag_slots: Array[Inventory_Slot])
signal items_updated

var bag_slots: Array[Inventory_Slot]: 
	get: return bag_slots
	# TODO: We will eventually like to do some validation on the bag_slots array
	set(value):
		if value.size() > 4:
			return
		bag_slots = value

var item_slots: Array[Inventory_Slot]:
	get: return item_slots
	set(value):
		item_slots = value

func _ready() -> void:

	# TODO: Items should be received by the server instead of instantiated locally

	# Fill the array with four bag slots
	for n in 4: 
		var bag_slot: Inventory_Slot = Inventory_Slot.new(
			Item_Template.ITEM_CLASS.CONTAINER,
			Item_Template.ITEM_SUBCLASS.BAG
		)
		bag_slot.slot_changed.connect(_on_bag_slot_changed)
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
	for bag_slot in bag_slots:
		if bag_slot.item == null:
			bag_slot.item = new_bag
			print(new_bag.container_slots)
			for container_slots in new_bag.container_slots:
				print(Item_Template.ITEM_CLASS.CONSUMABLE | Item_Template.ITEM_CLASS.CONTAINER)
				var new_slot: Inventory_Slot = Inventory_Slot.new(
					Item_Template.ITEM_CLASS.CONSUMABLE & Item_Template.ITEM_CLASS.CONTAINER,
					Item_Template.ITEM_SUBCLASS.CONSUMEABLE & Item_Template.ITEM_SUBCLASS.POTION & Item_Template.ITEM_SUBCLASS.ELIXIR & Item_Template.ITEM_SUBCLASS.FLASK & Item_Template.ITEM_SUBCLASS.SCROLL & Item_Template.ITEM_SUBCLASS.BAG
				)
				new_slot.slot_changed.connect(_on_inventory_slot_changed)
				item_slots.append(new_slot)
			break

	var new_item: Item_Template = Item_Template.new(
		1,
		Item_Template.ITEM_CLASS.CONSUMABLE,
		Item_Template.ITEM_SUBCLASS.POTION,
		"Health Potion",
		preload("res://prefabs/health_potion.tres"),
		false,
		1,
		"A potion that restores health."
	)
	for item_slot in item_slots:
		if item_slot.item == null:
			item_slot.item = new_item
			break

func _on_bag_slot_changed(_slot: Inventory_Slot) -> void:
	bags_updated.emit(bag_slots)

func _on_inventory_slot_changed(_slot: Inventory_Slot) -> void:
	print(_slot)
	pass
