function love.load()
    LoadSprites()
    SetupPlayer()
    SetupZombies()
    SetupBullets()
    SetupGameState()
	love.window.setTitle("IDKWTFISTHIS2")
end

function love.update(dt)
    UpdatePlayerMovement(dt)
    UpdateZombiesMovement(dt)
    UpdateBulletsMovement(dt)
    UpdateZombiesStatus()
    UpdateTimer(dt)
end

function love.draw()
    love.graphics.draw(Sprites.background, 0, 0)

    if GameState == 1 then
        love.graphics.setFont(MyFont)
        love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
    end

    love.graphics.printf("Score: " .. Score, 0, love.graphics.getHeight()-100, love.graphics.getWidth(), "center")

    love.graphics.draw(Sprites.player, 
                        Player.x, Player.y, 
                        PlayerMouseAngle(), nil, nil,
                        Sprites.player:getWidth()/2,
                        Sprites.player:getHeight()/2)

    for i,z in ipairs(Zombies) do
        love.graphics.draw(Sprites.zombie, z.x, z.y, 
                            PlayerZombieAngle(z), nil, nil,
                            Sprites.zombie:getWidth()/2,
                            Sprites.zombie:getHeight()/2)
    end

    for i,b in ipairs(Bullets) do
        love.graphics.draw(Sprites.bullet, b.x, b.y, nil, 0.5, 0.5,
                            Sprites.bullet:getWidth()/2,
                            Sprites.bullet:getHeight()/2)
    end
end

function LoadSprites()
    Sprites = {}
    Sprites.background = love.graphics.newImage('sprites/background.png')
    Sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    Sprites.player = love.graphics.newImage('sprites/player.png')
    Sprites.zombie = love.graphics.newImage('sprites/zombie.png')
end

function SetupPlayer()
    Player = {}
    Player.x = love.graphics.getWidth() / 2
    Player.y = love.graphics.getHeight() / 2
    Player.speed = 180
end

function SetupZombies()
    Zombies = {}
end

function SetupBullets()
    Bullets = {}
end

function SetupGameState()
    math.randomseed(os.time())
    GameState = 1
    MaxTime = 2
    Timer = MaxTime
    Score = 0
    MyFont = love.graphics.newFont(30)
end

function SpawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 140
    zombie.dead = false

    local side = math.random(1, 4)

    -- left side of the screen
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    -- right side of the screen
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    -- top side of the screen
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    -- bottom side of the screen
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end
    table.insert(Zombies, zombie)
end

function SpawnBullet()
    local bullet = {}
    bullet.x = Player.x
    bullet.y = Player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = PlayerMouseAngle()
    table.insert(Bullets, bullet)
end

function UpdatePlayerMovement(dt)
    if GameState == 2 then
        local movement = {}
        movement.x = 0
        movement.y = 0
        if love.keyboard.isDown("d") and Player.x < love.graphics.getWidth() then
            movement.x = movement.x + 1
        end
        if love.keyboard.isDown("a") and Player.x > 0 then
            movement.x = movement.x - 1
        end
        if love.keyboard.isDown("w") and Player.y > 0 then
            movement.y = movement.y - 1
        end
        if love.keyboard.isDown("s") and Player.y < love.graphics.getHeight() then
            movement.y = movement.y + 1
        end

        if movement.x ~= 0 or movement.y ~= 0 then
            local movementLength = math.sqrt(movement.x^2 + movement.y^2)
            local normalized = {}
            normalized.x = movement.x / movementLength
            normalized.y = movement.y / movementLength
            Player.x = Player.x + normalized.x * Player.speed * dt
            Player.y = Player.y + normalized.y * Player.speed * dt
        end
    end
end

function UpdateZombiesMovement(dt)
    for i,z in ipairs(Zombies) do
        z.x = z.x + math.cos(PlayerZombieAngle(z)) * z.speed * dt
        z.y = z.y + math.sin(PlayerZombieAngle(z)) * z.speed * dt

        if DistanceBetween(z.x, z.y, Player.x, Player.y) < 30 then
            for i,z in ipairs(Zombies) do
                Zombies[i] = nil
                SetupGameState()
                SetupPlayer()
            end
        end
    end
end

function UpdateBulletsMovement(dt)
    for i,b in ipairs(Bullets) do
        b.x = b.x + (math.cos( b.direction ) * b.speed * dt)
        b.y = b.y + (math.sin( b.direction ) * b.speed * dt)
    end

    for i=#Bullets, 1, -1 do
        if Bullets[i].x < 0 or
            Bullets[i].x > love.graphics.getWidth() or
            Bullets[i].y < 0 or
            Bullets[i].y > love.graphics.getHeight() then
                table.remove(Bullets, i)
        end
    end
end

function UpdateZombiesStatus()
    for i,z in ipairs(Zombies) do
        for j,b in ipairs(Bullets) do
            if DistanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                Score = Score + 1
            end
        end
    end

    for i=#Zombies, 1, -1 do
        if Zombies[i].dead == true then
            table.remove(Zombies, i)
        end
    end

    for i=#Bullets, 1, -1 do
        if Bullets[i].dead == true then
            table.remove(Bullets, i)
        end
    end
end

function UpdateTimer(dt)
    if GameState == 2 then
        Timer = Timer - dt
        if Timer <= 0 then
            SpawnZombie()
            MaxTime = 0.95 * MaxTime
            Timer = MaxTime
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and GameState == 2 then
        SpawnBullet()
    elseif button == 1 and GameState == 1 then
        GameState = 2
    end
end

function love.keypressed(key)
    if key == "space" then
        SpawnZombie()
    end
end

function PlayerMouseAngle()
    return math.atan2(Player.y - love.mouse.getY(), Player.x - love.mouse.getX()) + math.pi
end

function PlayerZombieAngle(enemy)
    return math.atan2(Player.y - enemy.y, Player.x - enemy.x)
end

function DistanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end