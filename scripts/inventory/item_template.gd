class_name Item_Template
extends Resource

enum ITEM_CLASS {
	CONSUMABLE = 0,
	CONTAINER = 1
}

enum ITEM_SUBCLASS {
	CONSUMEABLE = 0,
	POTION = 1,
	ELIXIR = 2,
	FLASK = 4,
	SCROLL = 8,
	BAG = 16
}

var entry: int 					# Unique identifier for the item
var _class: int 			# Class of the item
var _subclass: int 	# Subclass of the item
var name: String 				# Name of the item
var display_id: AtlasTexture 	# Icon representing the item
var stackable: bool 			# Whether the item can be stacked
var container_slots: int 		# Number of slots the item occupies in a container
var description: String 		# Description of the item

func _init(e: int, _c: int, _sc: int, n: String, d_id: AtlasTexture, s: bool, c: int, d: String) -> void:
	entry = e
	_class = _c
	_subclass = _sc
	name = n
	display_id = d_id
	stackable = s
	container_slots = c
	description = d