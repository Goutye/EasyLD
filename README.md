# EasyLD

Project to allow the programmer (who uses Löve2D or Drystal) to programm a game as easily as possible .

Current features :
-----------------

* Tileset / Map
* MapEditor
* Anim8Editor (Required an Area to use it)
* Entity / SpriteAnimation / AreaAnimation
* Matrix / Vector / Point
* Collide (Area, Polygon, OBB, AABB, Circle, Segment, Point)
* Area (Contains Shapes)
* Shapes : Area, Polygon / Box / Circle (fill) / Segment / Point
* InputText
* Font
* Keyboard / Mouse
* Timer (callback)
* Flux (Tweening)
* Music
* SFX
* Window
* Camera
* DepthManager
* Surface
* Screen
* Postfx

In the side of LÖVE2D :
----------------------

* Music (Some stuffs only available in LÖVE2D)

In the side of Drystal :
----------------------

* Mouse position (screen to scene) works with scaling

Upcoming stuffs : (Priority order)
----------------------

* Entity manager
* AreaEditor (Required for Anim8Editor)

How to program with EasyLD
----------------------

1. EasyLD = require 'EasyLD'
2. Add 3 functions to your main.lua :
	* EasyLD:load()
	* EasyLD:update(dt)
	* EasyLD:draw()
3. Free cookies

How to use the Screen feature
----------------------

1. Create a class which inherits from EasyLD/IScreen.lua
2. Modify/Add methods to it
3. Use it : EasyLD:nextScreen(MyScreen:new(xxx))

The preCalcul method is done _after_ the EasyLD:preCalcul function.  
The update/draw method is done _before_ the EasyLD:update/draw function.  
This allows you to do something before or after the update and to draw something over the screen.  

How to use the DepthManager feature
----------------------

1. Create one with the following parameters:
	* An object that the camera will follow (Need to have x and y attributes (Like Every shapes/areas in EasyLD))  
	* A draw function where you draw your world (Without any offset due to the camera position, the camera will take care of this)  
	* A ratio: 1 = 1/1, 0.5 will create a world behind the worlds with a higher ratio. 2 will create a world before the worlds with a lower ratio.  
	* The number of worlds before this one  
	* The number of worlds after this one  
2. Add your other worlds using the method `addDepth`  with these parameters  
	* id: Position of the worlds (before/after). The first world is at the 0-position.  
	* ratio: Same as above  
	* A draw function: Same as above
3. Choose a center of parallax with the `centerOn` method  
4. Don't forget to use the `update` method.  
5. Draw! With or without zoom.  

Examples :
---------

In the folder `examples`, you can find some implementations of EasyLD features.  
Other examples can be found in my [LD32](https://github.com/Goutye/LD32) game (Github).  


Version :
---------

There is no available version. All the code are not correctly optimized, well written (Except some parts). Please wait the first release version. (Before April, 17th 2015 (LD32)).

Developper : Gautier Boëda

Drystal : http://drystal.github.io/ (Run on Web (Javascript HTML5) or Linux)  
Löve2D : https://love2d.org/ (Run on Windows-MacOS/X-Linux)


Library :
---------

middleclass.lua - MIT Licence - Copyright (c) 2011 Enrique García Cota  
utf8.lua - BSD License - Copyright (c) 2006-2007 Kyle Smith  
cron.lua - MIT Licence - Copyright (c) 2011 Enrique García Cota  
flux.lua - MIT Licence - Copyright (c) 2014, rxi (Modified version for the needs of EasyLD - 2015, Goutye)