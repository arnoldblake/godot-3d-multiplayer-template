class_name Inventory_Slot
extends Node

signal slot_changed(slot: Inventory_Slot)

var item: Item_Template = null:
	get: return item
	set(value): 
		if (value._class & item_class && value._subclass & item_subclass) || value == null:
			item = value
			slot_changed.emit(self)

var item_class: int 
var item_subclass: int 

func _init(i_c: int, i_s: int) -> void:
	item_class = i_c
	item_subclass = i_s
