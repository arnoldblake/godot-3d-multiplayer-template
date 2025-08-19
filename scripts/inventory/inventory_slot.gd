class_name Inventory_Slot
extends Node

var item: Item_Template = null:
	get: return item
	set(value): 
		if (value._class == item_class && value._subclass == item_subclass) || value == null:
			item = value

var item_class: Item_Template.ITEM_CLASS
var item_subclass: Item_Template.ITEM_SUBCLASS 

func _init(i_c: Item_Template.ITEM_CLASS, i_s: Item_Template.ITEM_SUBCLASS) -> void:
	item_class = i_c
	item_subclass = i_s
