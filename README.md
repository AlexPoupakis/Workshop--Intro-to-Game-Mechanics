# Workshop: Intro to Game Mechanics
A repository for my 2-hour long "Intro to Game Mechanics" Workshop in the Startup Greece Week 2020 event. The goal was to get familiar with basic (2D) game concepts and implement (part of) a 2D browser game.

## Overview
* Game loops
* Affine Matrix Transformations
* Animation sequencing
* Collision Detection
* Parallax scrolling


## Case study
For this workshop, [StormWinds The Lost Campaigns](https://armorgames.com/play/3099/stormwinds-the-lost-campaigns) was used as an example and a general direction. Our implementation includes the first two types of enemies and the Machine Gun turret.
The official game displays only a static background image, but for the purposes of this workshop, we deviated to a more interesting - and completely out of theme - parallax-effect background.


## Game resources
In order to implement our own mini-game, we naturally need certain... artistic resources. Namely, the sprites and background images. The former where graciously extracted from the browser game itself, by means of sophisticated, state-of-the-art methods and tools (print screen, Paint, and a [suite of online png tools](https://onlinepngtools.com/)). The explosion and smoke animations were sprite sheets I found online and where cut up into individual sprites with this [sprite sheet cutter](https://ezgif.com/sprite-cutter) (other useful tools there as well). The later were amongst the free-to-use collection at [itch.io](itch.io).

For the more creative souls out there, custom sprites or images can be created with online tools such as [PiskelApp](https://www.piskelapp.com/), [Pixie](https://pixieengine.com/), [Pixlr](https://pixlr.com/) and many more.


## Implementation details
### Framework
The entire project was build in the [Processing IDE](https://processing.org/) and the Processing language (a Java variant). The answer to the obvious question of why a Game Engine was not used instead, is in three parts: 
* it is more resonable to download a few-MB IDE than a multi-GB Engine for an introductory workshop
* the focus was on the techniques, methods and subtleties of building a 2D game, rather than the hustle and steep(er) learning curve of using a full-blown Game Engine
* Game Engines are cool, but a working knowledge of the behind-the-scenes mechanisms of a game is cooler

With some adaptability, the ideas can, of course, be transfered to the Engine of your choice. It is also possible (and relatively easy) to port the code into Processing.js (a JavaScript variant) and run the game on a browser or embed it in a site.


### Game characteristics
On the more technical side of things, our game was a frame-based shooter with distance units in pixels and time units in frame counts. This choice was made for simplicity's sake and so that we can (easily) slow down the game as much as we want, to closely observe the sprite sequences.


### Turret
The Machine Gun consists of two sprites, its base and head. The provided coordinates indicate the bottom center of the turret. Due to how affine matrix transformations and the drawing canvas work, as well as the fact that the head rotates 360°, the axis origin must be placed in the center of the head (more details in the source code comments). 

<p align="center">
  <img src="/images/Machine_Gun_Construction.png">
</p>

The base sprite is purposefully elongated, sacrificing memory efficiency, in order to represent a more realistic, physical base and simplifying the coordinate offsets in the code. We could obviously trim the sprite down to just the visible part and add the necessary offsets in the code, but since this results in less readable code,  I decided to discard the black magic constants and go with the intuition.


### Enemies
In the original game, enemies, unlike the turrets, do not have names. So, they will hence be, rather creatively, called Enemy_1 and Enemy_2.

#### Enemy_1
This is a non-firing enemy with the main goal of inconveniently getting in front of other enemies or our turrets. Its animation consists of two sprites and looks like this:

<p align="center">
  <img src="/images/Enemy_1_Animation.gif">
</p>

Its motion is a bit complicated due to the turns and variable speed (only during the turns). To constrain his position inside the frame at all times, we define a margin around the frame borders, which, when crossed, the Enemy_1 will have to pick a new (random) direction and start turning around. This new direction is a obtained by rotating the [normal vector](https://en.wikipedia.org/wiki/Normal_(geometry)) by a random angle in <img src="https://render.githubusercontent.com/render/math?math=[-\frac{\pi}{2}, \frac{\pi}{2}]"> and then we [linearly interpolate](https://en.wikipedia.org/wiki/Linear_interpolation) frame-by-frame between the old and the new direction, to execute a smooth turn. 

<p align="center">
  <img src="/images/Enemy_1_Motion_margin.png">
</p>

#### Enemy_2
This one drops a bomb when it flies above a turret. A "bomb.png" sprite is included in the project files, however the implementation is left to you and should be simple enough once you understand the rest of the code. The motion here is **much** simpler; just move from right to left with a constant speed. Also, in contrast to other enemies in the original game, this one does not re-enter the frame if it is not destroyed before it exits.

<p align="center">
  <img src="/images/Enemy_2_Animation.gif">
</p>
