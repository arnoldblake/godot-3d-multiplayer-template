class_name Inventory
extends Node

var slots : Array[InventorySlot]
@export var starter_items : Array[Item]

func _ready():
	GlobalInventory.ready.connect(_on_global_inventory_ready)
	if GlobalInventory.is_node_ready(): _on_global_inventory_ready()
	self.visible = false


	for child in get_node("GridContainer").get_children():
		slots.append(child)
		child.set_item(null)
		child.inventory = self
	
	for item in starter_items:
		add_item(item)

func _on_global_inventory_ready():
	print(GlobalInventory.item.name)

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		self.visible = !self.visible

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
