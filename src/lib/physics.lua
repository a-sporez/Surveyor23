-- local love = require('love')
-- luacheck: globals Physics
Physics = {}

function Physics.checkContact(collider_a, collider_b)
    local dx = collider_b.x - collider_a.x
    local dy = collider_b.y - collider_a.y
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (collider_a.radius + collider_b.radius)
end

function Physics.applyContact(collider_a, collider_b)
    local dx = collider_b.x - collider_a.x
    local dy = collider_b.y - collider_a.y
    local distance = math.sqrt(dx * dx + dy * dy)
    local overlap = (collider_a.radius + collider_b.radius) - distance
    local nx, ny = dx / distance, dy / distance

    collider_a.x = collider_a.x - nx * overlap / 2
    collider_a.y = collider_a.y - ny * overlap / 2
    collider_b.x = collider_b.x - nx * overlap / 2
    collider_b.y = collider_b.y - ny * overlap / 2
end

return Physics