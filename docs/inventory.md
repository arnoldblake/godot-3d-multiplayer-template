---
title: Inventory Example
---
::: mermaid
classDiagram
    Resource --|> Slottable
    class Slottable {

    }

    Slottable --|> Item
    class Item {
        +int id
        +String display_name
        +String description
        +Texture2D icon
    }

    Slottable --|> Spell
    class Spell {
        +int id
    }

    Object --|> Container
    class Container {
        -Slot[] _slots
        add_item(Item)
        remove_item(Item)
    }
    
    Container --|> Bag
    class Bag {
        Item[] items
        sort()
        split_item(Item)
    }

    Object --|> Slot
    class Slot {
        Slottable slottable
    }

    Container --|> Inventory
    class Inventory {
        Bag[] bags
    }

    Container --|> SpellBook
    class SpellBook {
        Spell[] spells
    }
::: 