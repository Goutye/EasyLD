package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

drystal = require 'drystal'

EasyLD = require 'EasyLD'
EasyLD.load("Drystal")

--LOCAL VARIABLE
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
fps = 0
dtt = 0
nb = 0

function drystal.init()
	drystal.resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	drystal.set_title("EasyLD")

	box = EasyLD.box:new(200,270, 54, 45,EasyLD.color:new(255,25,25,125), "fill")
	box1 = EasyLD.box:new(170,335, 20, 21,EasyLD.color:new(25,25,25,125), "fill")
	box2 = EasyLD.box:new(80,89, 54, 45,EasyLD.color:new(255,255,25,125), "fill")
	boxR = box:copy()
	boxL = box:copy()
	ox = box.x
	boxR:rotate(math.pi/4, ox, box.y)
	boxL:rotate(math.pi/3, ox, box.y)
	boxL:translate(100,100)
	boxR.c = EasyLD.color:new(0,255,0,125)

	m = EasyLD.matrix:new(2, 2)
	for i = 0, 1 do
		for j = 0, 1 do
			m.d[i][j] = math.random(-3, 4)
		end
	end

	box2 = box1:copy()
	box2:rotate(math.pi/2, box2.x, box2.y)
	box3 = boxR:copy()
	box3.c = EasyLD.color:new(5,255,255,125)

	box2.c = EasyLD.color:new(0,100,255,125)



	area = EasyLD.area:new(box)
	area:attach(box1)
	--area:attach(box3)
	area:attach(box2)
	area:attach(boxR)
	area:rotate(math.pi, box1.x, box1.y)
	area:translate(100, 10)

	font = assert(drystal.load_font("assets/digital-7.ttf", 24))
	img = EasyLD.image:new("assets/car2.png")
end

function drystal.update(dt)
	dtt = dtt + dt
	nb = nb + 1
	if dtt > 1 then
		fps = nb
		nb = 0
		dtt = dtt - 1
	end

	area:rotate(math.pi/180, box1.x, box1.y)
	boxL:moveTo(EasyLD.mouse:getPosition())
	if EasyLD.collide:OBB_OBB(boxR, boxL) or EasyLD.collide:OBB_OBB(boxL, box1) then
		boxL.c = EasyLD.color:new(0,255,0,125)
	else
		boxL.c = EasyLD.color:new(255,0,0,125)
	end

	if EasyLD.collide:OBB_point(boxR, EasyLD.point:new(0,0)) then
		box1.c = EasyLD.color:new(0,0,255,125)
	else
		box1.c = EasyLD.color:new(25,25,25,125)
	end
end

function drystal.draw()
	drystal.set_color(drystal.colors.black)
	drystal.draw_rect(0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
	drystal.set_color(drystal.colors.white)
	area:draw()
	box3:draw()
	boxL:draw()

	font:draw("FPS : " .. fps, 0, 20)
	--map:draw(0, 0, 5, 5, 0, 0)
	--EasyLD.graphics:polygon("fill", EasyLD.point:new(1,1), EasyLD.point:new(1,90), EasyLD.point:new(50,159), EasyLD.point:new(59,1))
end