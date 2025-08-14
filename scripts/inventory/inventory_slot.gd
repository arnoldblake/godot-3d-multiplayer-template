class_name InventorySlot
extends Node

var item : Item
var quantity : int
@onready var icon : TextureRect = get_node("TextureRect")
@onready var quantity_text : Label = get_node("Label")
var inventory : Inventory

func set_item(new_item : Item):
	item = new_item
	quantity = 1

	if item == null:
		icon.visible = false
	else:
		icon.visible = true
		icon.texture = item.icon

	update_quantity_text()

func add_item():
	quantity += 1
	update_quantity_text()

func remove_item ():
	quantity -= 1
	update_quantity_text()

	if quantity == 0:
		set_item(null)

func update_quantity_text():
	if quantity <= 1:
		quantity_text.text = ""
	else:
		quantity_text.text = str(quantity)

func drop_item():
	if item == null:
		return
	remove_item()

func _on_pressed():
	if item == null:
		return

	var remove_after_use = item._on_use(inventory.get_parent())
	if remove_after_use:
		remove_item()
