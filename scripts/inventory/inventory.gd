class_name InventoryGUI
extends Control

@onready var inventory_bag_gui: PackedScene = preload("res://prefabs/inventory_bag_gui.tscn")
@onready var inventory_bag_slot_gui: PackedScene = preload("res://prefabs/inventory_bag_slot_gui.tscn")
@onready var inventory_bag_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	GlobalInventory.bags_updated.connect(_on_bags_updated)
	if GlobalInventory.bags.size(): _on_bags_updated()
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		self.visible = not self.visible


func _on_bags_updated() -> void:
	var new_bag := inventory_bag_gui.instantiate()
	inventory_bag_container.add_child(new_bag)
	for bag in GlobalInventory.bags:
		for n in bag.container_slots:
			var new_slot := inventory_bag_slot_gui.instantiate()
			new_bag.add_child(new_slot)
