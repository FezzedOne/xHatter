# xHatter
This fork of Degranon's Advanced Hatter supports [xStarbound](https://github.com/xStarbound/xStarbound) by FezzedOne, Kae and other contributors; [OpenStarbound](https://github.com/OpenStarbound/OpenStarbound) by Kae and other contributors; [HasiboundLite](https://github.com/TheFurryDevil/hasiboundlite) by TheFurryDevil; and [StarExtensions v1.5+](https://github.com/StarExtensions/StarExtensions) by Kae. Requires Quickbar or Stardust Core Lite.

# Installation
Download the [latest release](https://github.com/KrashV/Starbound-AdvancedHatter/releases) and place the .pak file in the /starbound/mods folder.

# Usage

## General usage
For general use of Advanced Hatter, just load the spritesheet or the emotes separately, spawn the item in game and enjoy.
The guide below described the functionality to integrate the sprite sheet into the character itself

## xStarbound / OpenStarbound / StarExtensions v1.5+ / Hasiboundlite
1. Navigate to the [Creation site](https://krashv.github.io/Starbound-AdvancedHatter/) and create the head item.
2. In /mods folder, create a new subfolder with a preferable name
2. Add the generated json file to the **/animatedhats** folder of the mod.

![pierre.json in the folder](https://i.imgur.com/OHeXwZ8.png)

3. Open Quickbar, find the **Head Setter** and enter the name of the created file in the *only* text field.
4. Click the "Set head" button; the title of the pane should change accordingly.

![Hat successfully set](https://i.imgur.com/pveXEvN.png)

5. Relog or use `/reload` to see any changes

## xHatter-only features

- Added support for facing directions to chest, legs and back items via a new `"xHatter"` parameter:
```json
"xHatter": {
  "left": "<left-facing directives>",
  "right": "<right-facing directives>"
}
```
  
  This parameter is also supported on hats.
- Fixed various crashes in the Lua script.

## xStarbound-only features

- Added support for underlaid cosmetic items.
- Characters who have a base head item set via the Head Setter now use it as an underlay behind all hats and hat underlays. For all intents and purposes, it acts as the character's own fully animated head sprite; you can even wear xHatter and Animated Hatter hats without issues!

## Important note
Like Advanced Hatter, xHatter changes the `"facialHair"` and `"facialHairType"` of any characters who have a base head item set via the Head Setter.
