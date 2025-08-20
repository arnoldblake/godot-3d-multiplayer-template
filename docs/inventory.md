---
title: Inventory Systems
---

# Inventory System Architecture

The inventory system is designed around a flexible slot-based architecture that can accommodate different container types including bags, action bars, and other specialized containers.

## Core Components

### GlobalInventory (Singleton)
- Manages the player's inventory state globally
- Maintains arrays of inventory slots for bag containers (`bag_slots`) and items within bags (`item_slots`)
- Emits signals when bags or items are updated
- Handles initial setup with default backpack and health potion

### Item_Template (Resource)
- Base template for all items in the game
- Supports different item classes (CONSUMABLE, CONTAINER)
- Supports different item subclasses (POTION, ELIXIR, FLASK, SCROLL, BAG)
- Contains item properties like name, icon, description, stackable status

### Inventory_Slot (Node)
- Container that can hold a specific type of Item_Template
- Validates items based on class and subclass restrictions (`slot_class` and `slot_subclass`)
- Used for both bag slots and item slots within bags
- Emits `slot_changed` signal when item is assigned or removed

### InventoryGUI (Control)
- Main UI component for displaying the inventory
- Dynamically creates bag and slot UI elements
- Responds to GlobalInventory signals to update display
- Handles inventory visibility toggle with input action

### Item (Resource) - Alternative Implementation
- Alternative item class with simplified structure
- Contains `display_name`, `description`, `icon`, and `max_stack_size` properties
- Includes `_on_use()` method for item usage logic
- Currently exists alongside Item_Template but not actively used in main inventory system

## System Flow

1. **Initialization**: **GlobalInventory** creates an array of **bag_slots** to hold bag containers and initializes empty **item_slots** array
2. **Bag Assignment**: Each bag slot is assigned a bag (Item_Template with CONTAINER class)
3. **Item Slot Creation**: When a bag is assigned, the system creates item slots based on the bag's `container_slots` property
4. **GUI Creation**: When bags are updated, **InventoryGUI** creates visual representations using prefab scenes
5. **Slot Generation**: For each bag, the GUI creates visual slot elements dynamically
6. **Item Assignment**: Items (like health potions) are assigned to slots within bags
7. **Visual Update**: The GUI updates TextureRect components to show item icons in appropriate slots

### Signal Flow
- `GlobalInventory.bags_updated` → `InventoryGUI._on_bags_updated()` → Creates bag GUI elements
- `GlobalInventory.items_updated` → `InventoryGUI._on_items_updated()` → Updates item icons in slots

### Validation
- **Inventory_Slot** validates items based on `slot_class` and `slot_subclass` restrictions
- Only compatible items can be placed in specific slot types
- Maximum of 4 bags can be held at once (enforced in GlobalInventory setter)

::: mermaid
---
config:
    class:
        hideEmptyMembersBox: true
---

classDiagram
    Node --|> GlobalInventory
    class GlobalInventory {
        +Array~Inventory_Slot~ bag_slots
        +Array~Inventory_Slot~ item_slots
        +signal bags_updated()
        +signal items_updated()
        +_ready() void
    }

    Resource --|> Item_Template
    class Item_Template {
        +int entry
        +ITEM_CLASS _class
        +ITEM_SUBCLASS _subclass
        +String name
        +AtlasTexture display_id
        +bool stackable
        +int container_slots
        +String description
        +_init(e, _c, _sc, n, d_id, s, c, d) void
    }

    Node --|> Inventory_Slot
    class Inventory_Slot {
        +Item_Template item
        +int slot_class
        +int slot_subclass
        +signal slot_changed(slot)
        +_init(i_c, i_s) void
    }

    Control --|> InventoryGUI
    class InventoryGUI {
        +PackedScene inventory_bag_gui
        +PackedScene inventory_bag_slot_gui
        +VBoxContainer inventory_bag_container
        +_ready() void
        +_process(delta) void
        +_on_bags_updated() void
        +_on_items_updated() void
    }

    Resource --|> Item
    class Item {
        +String display_name
        +String description
        +Texture2D icon
        +int max_stack_size
        +_on_use(player) bool
    }

    GlobalInventory --o Inventory_Slot : contains_bag_slots
    GlobalInventory --o Inventory_Slot : contains_item_slots
    Inventory_Slot --o Item_Template : holds_item
    InventoryGUI ..> GlobalInventory : listens_to_signals
    InventoryGUI --> inventory_bag_gui : instantiates
    InventoryGUI --> inventory_bag_slot_gui : instantiates

    class ITEM_CLASS {
        <<enumeration>>
        CONSUMABLE
        CONTAINER
    }
    
    class ITEM_SUBCLASS {
        <<enumeration>>
        CONSUMABLE
        POTION
        ELIXIR
        FLASK
        SCROLL
        BAG
    }

:::

## GUI Components

### Prefab Scenes

**inventory_bag_gui.tscn**
- GridContainer with 3 columns
- Visual representation of a bag container
- Dynamically populated with slot GUI elements

**inventory_bag_slot_gui.tscn**
- Button with 64x64 minimum size
- TextureRect for displaying item icons
- Label for item stack count or other information
- Represents individual inventory slots within bags

### UI Hierarchy

```
InventoryGUI (Control)
└── VBoxContainer (inventory_bag_container)
    └── GridContainer (inventory_bag_gui instances)
        └── Button (inventory_bag_slot_gui instances)
            ├── TextureRect (item icon display)
            └── Label (item info)
```

## Example Usage

The system initializes as follows:

1. **GlobalInventory** creates 4 bag slots for holding container items (bags)
2. A backpack (Item_Template) is assigned to the first available bag slot with 8 container slots
3. For each container slot in the bag, the system creates item slots in the `item_slots` array
4. A health potion (Item_Template) is created and assigned to the first available item slot
5. **InventoryGUI** responds to `bags_updated` signal by creating visual bag and slot elements
6. **InventoryGUI** responds to `items_updated` signal by updating item icons in the TextureRect components

This architecture supports future expansion to action bars, quest item containers, and other specialized inventory systems by reusing the same slot-based foundation. 