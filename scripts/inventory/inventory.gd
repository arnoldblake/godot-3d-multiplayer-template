class_name Inventory
extends Node


var slots : Array[InventorySlot]
# @onready var window : Panel = get_node("Inventory")
# @onready var info_text : Label = get_node("Inventory/InfoText")
@export var starter_items : Array[Item]

func _ready():
	toggle_window(false)
	for child in get_node("GridContainer").get_children():
		slots.append(child)
		child.set_item(null)
		child.inventory = self
	
	GlobalSignals.on_give_player_item.connect(on_give_player_item)

	for item in starter_items:
		print('Adding starter item: ' + item.display_name)
		add_item(item)

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		toggle_window(!self.visible)

func toggle_window (open : bool):
	self.visible = open

func on_give_player_item(item : Item, amount : int):
	pass

func add_item(item : Item):
	var slot = get_slot_to_add(item)
	if slot == null:
		return
	if slot.item == null:
		slot.set_item(item)
	elif slot.item == item:
		slot.add_item()

func remove_item(item : Item):
	var slot = get_slot_to_remove(item)
	if slot == null or slot.item != item:
		return
	slot.remove_item()

func get_slot_to_add(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack_size:
			return slot

	for slot in slots:
		if slot.item == null:
			return slot
	return null

func get_slot_to_remove(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item:
			return slot
	return null

func get_number_of_item(item : Item) -> int:
	var total = 0
	for slot in slots:
		if slot.item == item:
			total += slot.quantity
	return total
