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
The Machine Gun consists of two sprites, its base and head. 

<kbd>
  <img src="https://github.com/AlexPoupakis/Workshop--Intro-to-Game-Mechanics/tree/master/shooter_game/data/sprites/machine_gun_base.png">
</kbd>
