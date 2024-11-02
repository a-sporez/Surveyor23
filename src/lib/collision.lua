local love = require('love')

local collision = {}

function collision:init(gravityX, gravityY)
-- Initialize physics module
    self.worldMesh = love.physics.newWorld(gravityX or 0, gravityY or 0)
    self.worldMesh:setCallbacks(self.beginContact, self.endContact)
end

function collision.beginContact(a, b, coll)
    local aData = a:getUserData() or "unknown"
    local bData = b:getUserData() or "unknown"
    print("Contact begins between"..aData.." and "..bData)
end

function collision.endContact(a, b, coll)
    print("Contact ends between"..a:getUserData().." and "..b:getUserData())
end

-- axes and vertices are passed to body and shape, that makes up fiture, that makes up userData
function collision:addEntity(shapeType, data)
    local body = love.physics.newBody(self.worldMesh, data.x, data.y, 'dynamic')
    local shape
    if shapeType == "polygon" then
        if not data.vertices or #data.vertices < 6 then
            error("Expected a minimum of 3 vertices for polygon, got " .. (data.vertices and #data.vertices / 2 or 0))
        end
        -- Print each vertex to check the actual values
        print("Creating polygon with vertices:")
        for i = 1, #data.vertices, 2 do
            print("Vertex " .. (i / 2 + 0.5) .. ": (" .. data.vertices[i] .. ", " .. data.vertices[i + 1] .. ")")
        end
        shape = love.physics.newPolygonShape(data.vertices)
    elseif shapeType == "circle" then
        shape = love.physics.newCircleShape(data.radius)
    end
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData(data.userData)
    return body
end


function collision:update(dt)
    self.worldMesh:update(dt)
end

function collision:draw()
    for _, body in pairs(self.worldMesh:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            if shape:getType() == 'polygon' then
                love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
            elseif shape:getType() == 'circle' then
                local x, y = body:getWorldPoint(shape:getPoint())
                love.graphics.circle('line', x, y, shape:getRadius())
            end
        end
    end
end

return collision