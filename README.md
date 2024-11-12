# xHatter

This fork of Degranon's Advanced Hatter supports [xStarbound](https://github.com/xStarbound/xStarbound) by FezzedOne, Kae and other contributors; [OpenStarbound](https://github.com/OpenStarbound/OpenStarbound) by Kae and other contributors; [HasiboundLite](https://github.com/TheFurryDevil/hasiboundlite) by TheFurryDevil; and [StarExtensions v1.5+](https://github.com/StarExtensions/StarExtensions) by Kae. The head sprite replacement feature requires Quickbar or Stardust Core Lite.

# Installation

Download the [latest release](https://github.com/KrashV/Starbound-AdvancedHatter/releases) and place the `.pak` file in your `$sbInstall/assets` or `$sbInstall/mods` folder.

# Usage

## General usage

For basic usage, you can just generate your hat sprites with the [Advanced Hatter site](https://krashv.github.io/Starbound-AdvancedHatter/) (or manually if you're using the `"xHatter"` parameter), spawn the item in game and enjoy! The guide below describes how to integrate a head spritesheet into your character as if it were the character's original head. (Note: For the best sprite integration, use xStarbound.)

## xStarbound / OpenStarbound / StarExtensions v1.5+ / Hasiboundlite

1. Go to the [Advanced Hatter site](https://krashv.github.io/Starbound-AdvancedHatter/) and generate your head item from the appropriate spritesheet.
2. In your `mods/` or `assets/` folder, create a new subfolder with whatever name you want.
3. Add the generated JSON file (with the `.json` extension!) to the `/animatedhats` folder of the mod.

![Quickbar entry for the mod.](https://i.imgur.com/OHeXwZ8.png)

1. Open Quickbar, find the **Head Setter** and enter the name of the created file in the *only* text field.
2. Click the "Set head" button; the title of the pane should change accordingly.

![Hat successfully set!](https://i.imgur.com/pveXEvN.png)

5. Relog, warp or use `/reload` to see any changes! Adding new JSON files to `/animatedhats` requires a `/reload` or a client restart.

## xHatter-only features

- Added support for facing directions to chest, legs and back items via a new `"xHatter"` parameter:
```json
"xHatter": {
  "left": "<left-facing directives>",
  "right": "<right-facing directives>"
}
```
  
  This parameter is also supported on hats.
- Fixed various potential crashes in the Lua script.
- If you're using xStarbound, OpenStarbound or StarExtensions, characters' original hair properties are saved when a base head item is set via the **Head Setter** and restored if the base item is later removed.

## xStarbound-only features

- Added support for underlaid cosmetic items. Other people must have xClient to see these underlays in multiplayer.
- Characters who have a base head item set via the Head Setter now use it as an underlay behind all hats and hat underlays. For all intents and purposes, it acts as the character's own (optionally fully animated) head sprite; you can even wear xHatter and Animated Hatter hats without issues! *This* underlay is visible to everyone, regardless of their client, in multiplayer.

## Important note

Like Advanced Hatter, xHatter changes the `"facialHair"` and `"facialHairType"` of any characters who have a base head item set via the Head Setter. If you're using xStarbound, OpenStarbound or StarExtensions, the original hair properties will be restored if the base head item is later removed.
