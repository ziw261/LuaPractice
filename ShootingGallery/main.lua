function love.load()
	Target = {}
	Target.x = 300
	Target.y = 300
	Target.radius = 50

	Score = 0
	Timer = 0

	GameState = 1

	GameFont = love.graphics.newFont(40)

	Sprites = {}
	Sprites.sky = love.graphics.newImage('sprites/sky.png')
	Sprites.target = love.graphics.newImage('sprites/target.png')
	Sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

	CrosshairsDim = {}
	CrosshairsDim.x = Sprites.crosshairs.getPixelWidth(Sprites.crosshairs)
	CrosshairsDim.y = Sprites.crosshairs.getPixelHeight(Sprites.crosshairs)

	TargetDim = {}
	TargetDim.x = Sprites.target.getPixelWidth(Sprites.target)
	TargetDim.y = Sprites.target.getPixelHeight(Sprites.target)

	love.mouse.setVisible(false)
	love.window.setTitle("IDKWTFISTHIS")
end

function love.update(dt)
	if Timer > 0 then
		Timer = Timer - dt
	end

	if Timer < 0 then
		Timer = 0
		GameState = 1
		Score = 0
	end
end

function love.draw()

	love.graphics.draw(Sprites.sky, 0, 0)

	love.graphics.setColor(1,1,1)
	love.graphics.setFont(GameFont)
	love.graphics.print("Score: " .. Score, 5, 5)
	love.graphics.print("Time: " .. math.ceil(Timer), 300, 5)

	if GameState == 1 then
		love.graphics.printf("Click to Start", 0, 250, love.graphics.getWidth(), "center")
	end

	if GameState == 2 then
		love.graphics.draw(Sprites.target, Target.x-TargetDim.x/2, Target.y-TargetDim.y/2)
	end
	love.graphics.draw(Sprites.crosshairs, love.mouse.getX()-CrosshairsDim.x/2, love.mouse.getY()-CrosshairsDim.y/2)
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 and GameState == 2 then
		local mouseToTarget = DistanceBetween(x, y, Target.x, Target.y)
		if mouseToTarget < Target.radius then
			Score = Score + 1
			Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
			Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
		end
	elseif button == 1 and GameState == 1 then
		GameState = 2
		Timer = 10
	end
end

function DistanceBetween(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end