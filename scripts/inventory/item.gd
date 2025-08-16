class_name Item
extends Resource


@export var display_name: String
@export var description: String
@export var icon : Texture2D
@export var max_stack_size: int


func _on_use(_player: Character) -> bool:
    print("Use")
    return false