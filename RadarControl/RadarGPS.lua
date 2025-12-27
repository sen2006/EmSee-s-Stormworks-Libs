radarGPS = {
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
    radarPosToXYZ = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetHeading, targetElevation, targetDistance)
        local targetHeading = targetHeading * math.pi * 2
        local targetElevation = targetElevation * math.pi * 2

        local cx, sx = math.cos(eulerX), math.sin(eulerX)
        local cy, sy = math.cos(eulerY), math.sin(eulerY)
        local cz, sz = math.cos(eulerZ), math.sin(eulerZ)

        local localXOffset = targetDistance * math.cos(targetElevation) * -math.sin(-targetHeading)
        local localYOffset = targetDistance * math.sin(targetElevation)
        local localZOffset = targetDistance * math.cos(targetElevation) * math.cos(-targetHeading)
        local m00 = cy * cz
        local m01 = -cx * cz + sx * sy * cz
        local m02 = sx * sz + cx * sy * cz

        local m10 = cy * sz
        local m11 = cx * cz + sx * sy * sz
        local m12 = -sx * cz + cx * sy * sz

        local m20 = -sy
        local m21 = sx * cy
        local m22 = cx * cy

        local xOffset = m00 * localXOffset + m01 * localYOffset + m02 * localZOffset
        local yOffset = m10 * localXOffset + m11 * localYOffset + m12 * localZOffset
        local zOffset = m20 * localXOffset + m21 * localYOffset + m22 * localZOffset

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
    XYZToHeadingElevationDistance = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetX, targetY, targetZ)
        local dx = targetX - selfX
        local dy = targetY - selfY
        local dz = targetZ - selfZ

        local cx, sx = math.cos(eulerX), math.sin(eulerX)
        local cy, sy = math.cos(eulerY), math.sin(eulerY)
        local cz, sz = math.cos(eulerZ), math.sin(eulerZ)

        local m00 = cy * cz
        local m01 = -cx * sz + sx * sy * cz
        local m02 = sx * sz + cx * sy * cz

        local m10 = cy * sz
        local m11 = cx * cz + sx * sy * sz
        local m12 = -sx * cz + cx * sy * sz

        local m20 = -sy
        local m21 = sx * cy
        local m22 = cx * cy

        local lx = m00 * dx + m10 * dy + m20 * dz
        local ly = m01 * dx + m11 * dy + m21 * dz
        local lz = m02 * dx + m12 * dy + m22 * dz

        local tD = math.sqrt(lx * lx + ly * ly + lz * lz)
        local tE = math.asin(ly / tD)
        local tH = math.atan(-lx, lz)

        return tH, tE, tD
    end
}
