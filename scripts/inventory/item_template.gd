class_name Item_Template
extends Resource

enum ITEM_CLASS {
	CONSUMABLE = 1,
	CONTAINER = 2
}

enum ITEM_SUBCLASS {
	CONSUMABLE = 1,
	POTION = 2,
	ELIXIR = 4,
	FLASK = 8,
	SCROLL = 16,
	BAG = 32
}

var entry: int 					# Unique identifier for the item
var _class: int 			# Class of the item
var subclass: int 	# Subclass of the item
var name: String 				# Name of the item
var display_id: AtlasTexture 	# Icon representing the item
var stackable: bool 			# Whether the item can be stacked
var container_slots: int 		# Number of slots the item occupies in a container
var description: String 		# Description of the item

func _init(e: int, _c: int, _sc: int, n: String, d_id: AtlasTexture, s: bool, c: int, d: String) -> void:
	entry = e
	_class = _c
	subclass = _sc
	name = n
	display_id = d_id
	stackable = s
	container_slots = c
	description = d