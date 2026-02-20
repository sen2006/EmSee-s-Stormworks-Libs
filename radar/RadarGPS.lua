EmSeeLibRadarGPS = {
    ---comment
    ---@param selfX number self x
    ---@param selfY number self y
    ---@param selfZ number self z
    ---@param eulerX number self euler x
    ---@param eulerY number self euler y
    ---@param eulerZ number self euler z
    ---@param targetHeading number target heading
    ---@param targetElevation number target elevation
    ---@param targetDistance number target distance
    ---@return number x target x
    ---@return number y target y
    ---@return number z target z
    radarPosTurnsToXYZ = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetHeading, targetElevation, targetDistance
    )
        -- Convert radar angles from turns to radians
        local heading   = targetHeading * math.pi * 2
        local elevation = targetElevation * math.pi * 2

        -- Radar-local (spherical → Cartesian)
        local lx        = targetDistance * math.cos(elevation) * math.sin(heading)
        local ly        = targetDistance * math.sin(elevation)
        local lz        = targetDistance * math.cos(elevation) * math.cos(heading)

        -- Precompute trig
        local cx, sx    = math.cos(eulerX), math.sin(eulerX)
        local cy, sy    = math.cos(eulerY), math.sin(eulerY)
        local cz, sz    = math.cos(eulerZ), math.sin(eulerZ)

        -- Yaw → Pitch → Roll rotation matrix (ZYX)
        local m00       = cy * cz
        local m01       = cz * sx * sy - cx * sz
        local m02       = cx * cz * sy + sx * sz

        local m10       = cy * sz
        local m11       = sx * sy * sz + cx * cz
        local m12       = cx * sy * sz - cz * sx

        local m20       = -sy
        local m21       = cy * sx
        local m22       = cx * cy

        -- Rotate local radar vector into world space
        local xOffset   = m00 * lx + m01 * ly + m02 * lz
        local yOffset   = m10 * lx + m11 * ly + m12 * lz
        local zOffset   = m20 * lx + m21 * ly + m22 * lz

        -- World position
        return selfX + xOffset, selfY + yOffset, selfZ + zOffset
    end,

    ---comment
    ---@param selfX number self x
    ---@param selfY number self y
    ---@param selfZ number self z
    ---@param eulerX number self euler x
    ---@param eulerY number self euler y
    ---@param eulerZ number self euler z
    ---@param targetX number target x
    ---@param targetY number target y
    ---@param targetZ number target z
    ---@return number heading target heading
    ---@return number elevation target elevation
    ---@return number distance target distance
    XYZToHeadingElevationDistanceTurns = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetX, targetY,
                                             targetZ)
        -- World offset
        local wx = targetX - selfX
        local wy = targetY - selfY
        local wz = targetZ - selfZ

        -- Precompute trig
        local cx, sx = math.cos(eulerX), math.sin(eulerX)
        local cy, sy = math.cos(eulerY), math.sin(eulerY)
        local cz, sz = math.cos(eulerZ), math.sin(eulerZ)

        -- Same rotation matrix as forward function
        local m00 = cy * cz
        local m01 = cz * sx * sy - cx * sz
        local m02 = cx * cz * sy + sx * sz

        local m10 = cy * sz
        local m11 = sx * sy * sz + cx * cz
        local m12 = cx * sy * sz - cz * sx

        local m20 = -sy
        local m21 = cy * sx
        local m22 = cx * cy

        -- Inverse rotation = transpose
        local lx = m00 * wx + m10 * wy + m20 * wz
        local ly = m01 * wx + m11 * wy + m21 * wz
        local lz = m02 * wx + m12 * wy + m22 * wz

        -- Distance
        local distance = math.sqrt(lx * lx + ly * ly + lz * lz)
        if distance == 0 then
            return 0, 0, 0
        end

        -- Elevation & heading
        local elevation = math.asin(ly / distance)
        local heading   = math.atan(lx, lz)

        -- Convert radians → turns (0–1)
        heading         = heading / (math.pi * 2)
        elevation       = elevation / (math.pi * 2)

        return heading, elevation, distance
    end
}
