extends Node

@onready var item: Item_Template = Item_Template.new(
    1, 
    Item_Template.ITEM_CLASS.CONTAINER, 
    Item_Template.ITEM_SUBCLASS.BAG, 
    "Backpack", 
    preload("res://assets/icons/Action_Inventory.png"), 
    true, 
    0,
    "A sturdy backpack for carrying items."
    )


func _ready() -> void:
    pass