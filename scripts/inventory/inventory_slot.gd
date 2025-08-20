class_name Inventory_Slot
extends Node

signal slot_changed(slot: Inventory_Slot)

var item: Item_Template = null:
	get: return item
	set(value): 
		if (value._class & slot_class && value.subclass & slot_subclass) || value == null:
			item = value
			slot_changed.emit(self)

var slot_class: int 
var slot_subclass: int 

func _init(i_c: int, i_s: int) -> void:
	slot_class = i_c
	slot_subclass = i_s
