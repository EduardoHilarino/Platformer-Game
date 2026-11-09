# 🎮 2D Precision Platformer
> **Note:** This project was born through **Hack Club Terra** and is currently under active, passionate development! 🚀

A 2D precision platformer heavily inspired by *Celeste*, focused on fluid movement, tight challenges, exploration, and mechanical problem-solving.

---

## 📖 About the Game

The goal sounds simple: **just reach the end of each level!** But don't expect a walk in the park. 

This is a precision platformer where every pixel matters. You will need to master your controls, perfect your timing, and use logic to overcome punishing obstacles. Rather than just mindlessly jumping from one ledge to another, the game invites you to experiment, fail forward, and find creative solutions to tricky challenges.

The project is a **work in progress**, with a heavy emphasis on delivering ultra-responsive controls, juicy animations, and polished pixel-art visuals.

---

## 🕹️ Controls

Movement feels free and dynamic! You can **Dash** both on the ground and mid-air. Ready to take it to the next level? Try combining mechanics with precise timing to pull off advanced moves like *Super Jumps* and fly through the stages.

| Key | Action |
| :--- | :--- |
| **A / D** | Move Left / Right |
| **Space** | Jump |
| **Hold Space** | Jump Higher |
| **Shift** | Dash |
| **W/A/S/D + Shift** | 8-Directional Dash |
| **C** | Grab Wall |
| **C + W** | Climb Up |
| **C + S** | Climb Down |
| **Space (near a wall)** | Wall Jump |
| **F3** | Toggle Debug HUD |

---

## ⚡ The Movement System

To capture that tight, satisfying "game feel" pioneered by games like *Celeste*, I built a fully customized movement controller from scratch.

### Basic Movement
*   **Acceleration & Deceleration:** Smooth, physics-based movement with carefully tuned momentum.
*   **Variable Jump Height:** The height of your jump reacts dynamically to how long you hold the button.
*   **Coyote Time:** Ever run off a ledge but still wanted to jump? The game gives you a brief fraction of a second extra so you don't drop like a stone.
*   **Jump Buffering:** Hit the jump button a split second before hitting the ground? The game remembers and triggers the jump the exact frame you land.
*   **Air Control:** Fine-tune your positioning and course-correct mid-flight.

### Advanced Techniques
*   **8-Directional Dash:** Dash horizontally, vertically, or diagonally to save yourself or reach hidden spots.
*   **Super Jump:** Chain mechanics together with precise timing to gain massive momentum.
*   **Wall Interactions:** Slide down walls slowly, grab hold to catch your breath, or push off with a *Wall Jump* while balancing your stamina.

---

## 🎨 Visuals & Efeitos (VFX)

Every piece of art—from the character sprites and fluid animations to the tile-based environments—is completely custom-made right inside GameMaker.

No visual effect is just for show; they are designed to give **immediate tactile feedback** to your inputs without cluttering your view:

*   Full animation sets for running, jumping, falling, turning, dashing, and climbing.
*   **Squash & Stretch** effects to add weight, impact, and elasticity to every movement.
*   Crisp pixel-art smoke particles when jumping and landing.
*   Directional dust bursts during Wall Jumps and Wall Slides.
*   Rastros styles (*dash trails*) to make your bursts of speed look awesome.
*   Tile environments with random visual variations to make the world feel organic and alive.

---

## 🛠️ Built-in Debug HUD

If you love seeing how the gears turn under the hood, hit **F3**. The built-in testing overlay displays real-time telemetry, including:

*   Current movement state machine status.
*   Exact horizontal and vertical velocity.
*   Grounded / Airborne status.
*   Available dash charges.
*   Active Coyote Time and Jump Buffer frames.
*   Climbing stamina reserves.

---

## 💻 Technical Details
*   **Engine:** GameMaker Studio 2
*   **Language:** GML (GameMaker Language)
*   **Art Style:** 2D Pixel Art
*   **Genre:** Precision Platformer
*   **Status:** Work in Progress 🛠️

---

## 🚀 Future Plans
*   More mind-bending levels and custom obstacles.
*   New interactive environmental mechanics.
*   Even juicier dash trails and visual polish.
*   Expanded animation sets and ambient particle effects.
*   Sound design, audio cues, and background music.

---

## 📥 Installation (Windows Only)

1.  Head over to the **Releases** tab of this project and download the latest build.
2.  Extract the `.zip` file wherever you like on your computer.
3.  Open the folder and double-click the game's `.exe` file.
4.  Have fun!

*(Note: Make sure to keep all the extracted files together in the same folder so the game runs perfectly).*

---

## ❤️ Credits & Acknowledgments

*   **Development, Programming, Pixel Art & Level Design:** Eduardo Hilarino dos Santos
*   **Engine:** GameMaker Studio 2
*   **Primary Inspiration:** Maddy Thorson and the *Celeste* team.
*   **Incubator / Support:** Hack Club Terra

Thank you so much for checking out my project and testing it! Feedbacks, bug reports, and thoughts are always highly appreciated. 🎮
