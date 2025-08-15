---
title: Inventory Example
---

::: mermaid
---
config:
    class:
        hideEmptyMembersBox: true
---

classDiagram
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