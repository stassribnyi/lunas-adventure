# Luna’s Adventure is a Metroidvania, where the player’s curiosity is rewarded.
![Promo image](https://github.com/user-attachments/assets/5bda07c2-8c00-4caf-8b66-8b0e4bb16586)


**1/ Engine:** https://godotengine.org/

**Language:** GDScript

**2/** The game should be launched via .exe file or link on latest Chromium browser (Google Chrome, Edge, etc.). Supported platforms: Windows, Mac.  Work in other browsers isn’t guaranteed.

**3/** Recommended sound configuration: 100%, 30%, 100% (could be found in settings).

**4/** Features: the game has multiple endings. To gain the ability to choose, you need to pay attention to the dialogues. You can skip dialogue using mouse clicks. To start or continue the dialog, press  "E".

**5/** The game contains collectibles in the form of leaves, but collecting all of them is optional to complete the game.

**6/** Depending on your browser settings, different keys may be used for movement (>, <, or “A” and “D”). Recommended setup: >, <

**7/** Other in-game controls: Space, Shift, “M”, Enter. Shift and “M” cannot be changed, but everything else can be customized.

### Screenshots and Video:
#### Gameplay trailer
[![Youtube video trailer](https://github.com/user-attachments/assets/81f2ae6b-3cce-4789-bcf4-144f5e7bc4ad)](https://youtu.be/3bv4MF0ZoEI)

#### Locations
![Path of Pain location](https://github.com/user-attachments/assets/c691f90f-aad4-4d2e-be4d-9a150bc94f18)
![Second Witch location](https://github.com/user-attachments/assets/4921a134-8976-479b-9e57-57a91b269b30)
![Neckless location](https://github.com/user-attachments/assets/92f5a01a-3395-46c7-9d9a-571ae0f981dc)


### KNOWN ISSUES:
- The initial use of the dash may cause a brief freeze. (Most likely due to lazy-loaded shaders)
- Occasionally, saves do not occur immediately, resulting in spawning at previous checkpoints.
- Leaves may respawn upon re-entering a room.
- Blur shader doesn't work in browsers.
- Jumping from high points into water could send player into nearby room due to y velocity being bigger than size of water damage box.
- Player might stuck in textures between two rooms.

### SOLUTIONS:
- In most cases, using the pause menu to restart the level should resolve the issue. If not, the game must be restarted.
- If you are unable to reach certain areas using dash or double jump abilities, try holding the jump button longer. The jump height is variable by design to allow for more precise control. Use dash at the highest point of your jump to achieve longer distances.
- The dash ability accelerates the player in the current direction. Therefore, activating the dash while falling will increase the falling speed.
