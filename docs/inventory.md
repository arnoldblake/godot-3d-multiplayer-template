---
title: Inventory Systems
---

# Inventory System Architecture

The inventory system is designed around a flexible slot-based architecture that can accommodate different container types including bags, action bars, and other specialized containers.

## Core Components

### GlobalInventory (Singleton)
- Manages the player's inventory state globally
- Maintains arrays of inventory slots for bags and items
- Emits signals when bags or items are updated
- Handles initial setup with default backpack and health potion

### Item_Template (Resource)
- Base template for all items in the game
- Supports different item classes (CONSUMABLE, CONTAINER)
- Supports different item subclasses (POTION, ELIXIR, FLASK, SCROLL, BAG)
- Contains item properties like name, icon, description, stackable status

### Inventory_Slot (Node)
- Container that can hold a specific type of Item_Template
- Validates items based on class and subclass restrictions
- Used for both bag slots and item slots within bags

### InventoryGUI (Control)
- Main UI component for displaying the inventory
- Dynamically creates bag and slot UI elements
- Responds to GlobalInventory signals to update display

## System Flow

1. **Initialization**: **GlobalInventory** creates an array of **Inventory_Slots** to hold bags
2. **Bag Assignment**: Each bag slot is assigned a bag (Item_Template with CONTAINER class)
3. **GUI Creation**: When bags are updated, **InventoryGUI** creates visual representations using prefab scenes
4. **Slot Generation**: For each bag, the system creates GUI slots based on the bag's `container_slots` property
5. **Item Assignment**: Items (like health potions) are assigned to slots within bags
6. **Visual Update**: The GUI updates TextureRect components to show item icons in appropriate slots

### Signal Flow
- `GlobalInventory.bags_updated` → `InventoryGUI._on_bags_updated()` → Creates bag GUI elements
- `GlobalInventory.items_updated` → `InventoryGUI._on_items_updated()` → Updates item icons in slots

### Validation
- **Inventory_Slot** validates items based on `item_class` and `item_subclass` restrictions
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
        +Array~Inventory_Slot~ bags
        +Array~Item_Template~ items
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
        +ITEM_CLASS item_class
        +ITEM_SUBCLASS item_subclass
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

    GlobalInventory --o Inventory_Slot : contains_bags
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
        CONSUMEABLE
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

1. **GlobalInventory** creates a bag slot for containers
2. A backpack (Item_Template) is assigned to the bag slot with 8 container slots
3. A health potion (Item_Template) is created and added to the items array
4. **InventoryGUI** responds to updates by creating visual bag and slot elements
5. Item icons are displayed in the appropriate TextureRect components

This architecture supports future expansion to action bars, quest item containers, and other specialized inventory systems by reusing the same slot-based foundation. 