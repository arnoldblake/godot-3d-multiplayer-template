extends Control
class_name InventoryUI

@onready var grid_container: GridContainer = $Panel/MarginContainer/VBoxContainer/GridContainer
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleBar/Title
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/TitleBar/CloseButton
@onready var tooltip: Control = $ItemTooltip
@onready var tooltip_label: RichTextLabel = $ItemTooltip/Panel/MarginContainer/TooltipText

var player_inventory: PlayerInventory
var slot_ui_scene: PackedScene
var slot_uis: Array[InventorySlotUI] = []

signal inventory_closed

func _ready():
	# Load the slot UI scene
	slot_ui_scene = preload("res://level/scenes/ui/inventory_slot_ui.tscn")
	
	# Set up grid
	grid_container.columns = 4
	
	# Connect close button
	close_button.pressed.connect(_on_close_pressed)
	
	# Hide tooltip initially
	tooltip.visible = false
	
	# Initialize empty inventory for testing
	player_inventory = PlayerInventory.new()
	_create_slot_uis()
	
	# Add some test items
	_add_test_items()

func _create_slot_uis():
	# Clear existing slots
	for child in grid_container.get_children():
		child.queue_free()
	slot_uis.clear()
	
	# Create slot UIs
	for i in range(PlayerInventory.INVENTORY_SIZE):
		var slot_ui = slot_ui_scene.instantiate() as InventorySlotUI
		slot_ui.custom_minimum_size = Vector2(64, 64)
		slot_ui.parent_inventory = self
		
		# Connect signals
		slot_ui.slot_clicked.connect(_on_slot_clicked)
		slot_ui.item_hovered.connect(_on_item_hovered)
		slot_ui.item_unhovered.connect(_on_item_unhovered)
		
		# Set slot data
		slot_ui.set_slot_data(player_inventory.get_slot(i), i)
		
		grid_container.add_child(slot_ui)
		slot_uis.append(slot_ui)

func update_inventory_display():
	for i in range(slot_uis.size()):
		if i < PlayerInventory.INVENTORY_SIZE:
			slot_uis[i].set_slot_data(player_inventory.get_slot(i), i)

func _on_slot_clicked(slot_index: int, button: int):
	print("Slot ", slot_index, " clicked with button ", button)
	
	# Handle different click types
	match button:
		MOUSE_BUTTON_LEFT:
			# Left click - select/use item
			pass
		MOUSE_BUTTON_RIGHT:
			# Right click - context menu or quick action
			_handle_right_click(slot_index)

func _handle_right_click(slot_index: int):
	var slot = player_inventory.get_slot(slot_index)
	if slot and not slot.is_empty():
		var item = ItemDatabase.get_item(slot.item_id)
		if item:
			print("Right clicked on: ", item.name)
			# TODO: Show context menu or perform quick action

func _on_item_hovered(_slot_index: int, item: Item):
	_show_tooltip(item)

func _on_item_unhovered():
	_hide_tooltip()

func _show_tooltip(item: Item):
	if not item:
		return
	
	# Create rich text for tooltip
	var tooltip_content = "[b]" + item.name + "[/b]\n"
	tooltip_content += item.description + "\n\n"
	tooltip_content += "Type: " + _get_item_type_string(item.item_type) + "\n"
	tooltip_content += "Rarity: " + _get_rarity_string(item.rarity) + "\n"
	tooltip_content += "Value: " + str(item.value) + " gold"
	
	if item.stackable:
		tooltip_content += "\nMax Stack: " + str(item.max_stack)
	
	tooltip_label.text = tooltip_content
	tooltip.visible = true
	
	# Position tooltip near mouse
	var mouse_pos = get_global_mouse_position()
	tooltip.global_position = mouse_pos + Vector2(10, 10)

func _hide_tooltip():
	tooltip.visible = false

func _get_item_type_string(type: Item.ItemType) -> String:
	match type:
		Item.ItemType.WEAPON: return "Weapon"
		Item.ItemType.ARMOR: return "Armor"
		Item.ItemType.CONSUMABLE: return "Consumable"
		Item.ItemType.TOOL: return "Tool"
		Item.ItemType.MISC: return "Miscellaneous"
		_: return "Unknown"

func _get_rarity_string(rarity: Item.ItemRarity) -> String:
	match rarity:
		Item.ItemRarity.COMMON: return "Common"
		Item.ItemRarity.UNCOMMON: return "Uncommon"
		Item.ItemRarity.RARE: return "Rare"
		Item.ItemRarity.EPIC: return "Epic"
		Item.ItemRarity.LEGENDARY: return "Legendary"
		_: return "Unknown"

func handle_item_drop(from_slot: int, to_slot: int, inventory_type: String):
	print("Moving item from slot ", from_slot, " to slot ", to_slot)
	
	if inventory_type == "player":
		if player_inventory.move_item(from_slot, to_slot):
			update_inventory_display()
			print("Item moved successfully")
		else:
			# Try swapping if move failed
			if player_inventory.swap_items(from_slot, to_slot):
				update_inventory_display()
				print("Items swapped successfully")
			else:
				print("Move/swap failed")

func _on_close_pressed():
	inventory_closed.emit()
	visible = false

func open_inventory():
	visible = true

func close_inventory():
	visible = false

# Test function to add some items for visual testing
func _add_test_items():
	var sword = ItemDatabase.get_item("iron_sword")
	var potion = ItemDatabase.get_item("health_potion")
	var armor = ItemDatabase.get_item("leather_armor")
	var gem = ItemDatabase.get_item("magic_gem")
	var pickaxe = ItemDatabase.get_item("iron_pickaxe")
	
	if sword:
		player_inventory.add_item(sword, 1)
	if potion:
		player_inventory.add_item(potion, 5)
	if armor:
		player_inventory.add_item(armor, 1)
	if gem:
		player_inventory.add_item(gem, 2)
	if pickaxe:
		player_inventory.add_item(pickaxe, 1)
	
	update_inventory_display()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and visible:
			_on_close_pressed()
