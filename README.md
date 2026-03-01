# UnderFined

## Overview
**UnderFined** is a 2D ocean exploration game developed for the Campfire Jam. Join **Adam Hojer**, a guy who got stranded on an island with one thing on his bucket list: deep diving into the ocean's depths. Explore the vast underwater world, gather treasures, manage your health, and beware of the dangers that lurk below.

The game features health management, upgrades (HP, speed, rope length), a shop system, and various underwater threats like sirens and zombies.

## Stack & Frameworks
- **Engine:** [Godot Engine 4.6](https://godotengine.org/)
- **Language:** [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- **Physics Engine:** Jolt Physics (enabled in configuration)
- **Graphics API:** Forward Plus (Desktop)

## Requirements
- **Godot Engine 4.6** or higher.
- Compatible hardware for **Forward Plus** rendering (Vulkan).

## Setup & Run
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Jadiefication/Campfire-GameJam.git
    cd campfire-jam
    ```
2.  **Open in Godot:**
    - Launch the Godot Engine.
    - Click **Import** and select the `project.godot` file in the project root.
3.  **Run the game:**
    - Press **F5** in the Godot Editor or click the **Play** button in the top-right corner.
    - The main entry point is the menu scene (defined in `project.godot`).

## Controls
- **Movement:** `W`/`S`/`A`/`D` or Arrow Keys
- **Interact:** `E`
- **Jump/Action:** `Space`

## Project Structure
- `scenes/`: Godot Scene files (`.tscn`). Key scenes include `player.tscn`, `main_menu.tscn`, and various level maps.
- `scripts/`: GDScript logic files.
    - `Global.gd`: Autoloaded script managing player stats (HP, money, upgrades).
    - `adam.gd`: Main player controller.
    - `shop.gd`: Merchant and upgrade logic.
- `shaders/`: Custom `.gdshader` files (water effects, bubbles, etc.).
- `sounds/`: Audio assets (music, SFX).
- `IMGS/`, `player imgs/`, `OXYGEN IMG/`: Sprite assets and UI elements.
- `project.godot`: Main configuration file.

## Scripts Overview
- `Global.gd`: Handles persistent game state, money, health, and signals for UI updates.
- `adam.gd`: Implements player movement (swimming and walking), rope visuals, and scene transitions.
- `chest.gd`: Logic for interactable treasure chests.
- `fish_spawner.gd`: Handles enemy/fish generation.
- `veruska_shop.gd`: UI and logic for the in-game upgrade shop.

## Environment Variables
- This project does not currently use `.env` files. Configuration is handled within the Godot Editor and `project.godot`.

## License
- This projected is licensed under `MIT`, meaning it's free to share and use.

