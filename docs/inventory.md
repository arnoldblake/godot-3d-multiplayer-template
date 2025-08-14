---
title: Inventory Example
---
::: mermaid
classDiagram
    Resource --|> Item
    Node --|> InventorySlot
    Node --|> Inventory
    class Item {
        +String     display_name
        +Texture2D  icon
        +Int        max_stack_size
        +on_use(player)
    }

    class InventorySlot {
        Item item
        int quantity
        TextureRect icon
        Label quantity_text
        Inventory inventory
        set_item(Item item)
        add_item()
        remove_item
        update_quantity_text()
    }
    class Inventory {
        Array~InventorySlot~ slots
        Panel window
        Label info_text
        Array~Item~ starter_items
        ready()
        _process()
        toggle_window(bool open)
        on_give_player_item(Item item, int amount)
        add_item(Item item)
        remove_item(Item item)
        get_slot_to_add(Item item) InventorySlot
        get_slot_to_remove(Item item) InventorySlot
        get_number_of_item(Item item) int
    }
::: 