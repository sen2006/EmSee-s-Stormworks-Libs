EmSeeLibMath = {
distanceToVec3 = function(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end,

distanceToVec2 = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end,

clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
end
}