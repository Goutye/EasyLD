# EasyLD

Project to allow the programmer (who uses Löve2D or Drystal) to programm a game as easily as possible .

Current features :
-----------------

* Tileset / Map
* MapEditor
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
* Window

In the side of LÖVE2D :
----------------------

* Circle (line)
* Music (Some stuffs available only in LÖVE2D)

In the side of Drystal :
----------------------

Upcoming stuffs : (Priority order)
----------------------

* Software to create as easily as possible an AreaAnimation
* Camera

How to program with EasyLD
----------------------

1. EasyLD = require 'EasyLD'
2. Add 3 functions to your main.lua :
	* EasyLD:load()
	* EasyLD:update(dt)
	* EasyLD:draw()
3. Free cookies

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