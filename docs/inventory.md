---
title: Inventory Systems
---



::: mermaid
---
config:
    class:
        hideEmptyMembersBox: true
---

classDiagram
    Node --|> GlobalInventory
    class GlobalInventory {
        -Item[] items
        _ready() void
    }

    Resource --|> Item_Template
    class Item_Template {
        int entry
        int class
        int subclass
        String name
        Texture2D display_id
        bool stackable
        int container_slots
        String description
    }


::: 