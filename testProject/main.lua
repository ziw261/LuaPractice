message = 6
chicken = 10
output = chicken + message * chicken
condition = false

-- This is a table, table starts from index 1
testScores = {1, 2, 3, 4}

-- You could create table's own variable
testScores.name = "ZheHeLiMa"

testScores[0] = 99
testScores[1] = 95
testScores[2] = 87
testScores[3] = 98

-- insert (which list, where, what value)
table.insert( testScores, 0, 5 )

-- i=index, s=value
for i,s in ipairs(testScores) do 
    output = output + s
end

emptyObject = nil


-- <=, ==, >=, ~= (not equal), >, < 
if condition == true then
    output = 0.4
elseif output < 3.4 then
    output = 4.3
else 
    output = 2.2
end

if output >=  1.9 then
    output = output + testScores[3]
end

while output < 7.5 do
    output = output + 1
end

-- i = 1, if i != 5, go, if i == 5, do the last loop.
--[[ Which means, i starts from 1, it will go exactly that many times.
That's interesting
]]--
for i=1, 5, 1 do
    output = output + 1
end

function increaseOutput(numToIncrease)
    local temp = output + numToIncrease
    return temp
end

output = output + increaseOutput(4)

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(testScores.name)
end

