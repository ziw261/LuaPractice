message = 6
chicken = 10
output = chicken + message * chicken

condition = false

if condition == true then
    output = 0.4
end

if output >=  1.9 then
    output = output + 2.3
end

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(output)
end