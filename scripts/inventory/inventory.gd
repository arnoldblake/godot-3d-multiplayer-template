class_name InventoryGUI
extends Control

@onready var inventory_bag_gui: PackedScene = preload("res://prefabs/inventory_bag_gui.tscn")
@onready var inventory_bag_slot_gui: PackedScene = preload("res://prefabs/inventory_bag_slot_gui.tscn")
@onready var inventory_bag_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	GlobalInventory.bags_updated.connect(_on_bags_updated)
	if GlobalInventory.is_node_ready(): _on_bags_updated()
	GlobalInventory.items_updated.connect(_on_items_updated)
	if GlobalInventory.is_node_ready(): _on_items_updated()
	
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		self.visible = not self.visible


func _on_bags_updated() -> void:
	for bag_containers: Node in $VBoxContainer.get_children():
		bag_containers.queue_free()

	for bag_slot in GlobalInventory.bag_slots:
		if bag_slot == null || bag_slot.item == null:
			break
		var new_bag := inventory_bag_gui.instantiate()
		inventory_bag_container.add_child(new_bag)
		for n: int in bag_slot.item.container_slots:
			var new_slot := inventory_bag_slot_gui.instantiate()
			new_bag.add_child(new_slot)

func _on_items_updated() -> void:
	var grid_containers: Array[Node] = $VBoxContainer.get_children()
	if grid_containers.size() == 0:
		return

	for item_slot in GlobalInventory.item_slots:
		if item_slot == null or item_slot.item == null:
			break
		var texture_rect: TextureRect = grid_containers[0].get_node("Button").get_node("TextureRect")
		if texture_rect:
			texture_rect.texture = item_slot.item.display_id
