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
    radarPosToXYZ = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetHeading, targetElevation,
                             targetDistance)
        local targetHeading = targetHeading * math.pi * 2
        local targetElevation = targetElevation * math.pi * 2

        local cosX, sinX = math.cos(eulerX), math.sin(eulerX)
        local cosY, sinY = math.cos(eulerY), math.sin(eulerY)
        local cosZ, sinZ = math.cos(eulerZ), math.sin(eulerZ)

        local localXOffset = targetDistance * math.cos(targetElevation) * -math.sin(-targetHeading)
        local localYOffset = targetDistance * math.sin(targetElevation)
        local localZOffset = targetDistance * math.cos(targetElevation) * math.cos(-targetHeading)
        local m00 = cosY * cosZ
        local m01 = -cosX * cosZ + sinX * sinY * cosZ
        local m02 = sinX * sinZ + cosX * sinY * cosZ

        local m10 = cosY * sinZ
        local m11 = cosX * cosZ + sinX * sinY * sinZ
        local m12 = -sinX * cosZ + cosX * sinY * sinZ

        local m20 = -sinY
        local m21 = sinX * cosY
        local m22 = cosX * cosY

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
    XYZToHeadingElevationDistance = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, targetX, targetY,
                                             targetZ)
        local xOffset = targetX - selfX
        local yOffset = targetY - selfY
        local zOffset = targetZ - selfZ

        local cosX, sinX = math.cos(eulerX), math.sin(eulerX)
        local cosY, sinY = math.cos(eulerY), math.sin(eulerY)
        local cosZ, sinZ = math.cos(eulerZ), math.sin(eulerZ)

        local m00 = cosY * cosZ
        local m01 = -cosX * sinZ + sinX * sinY * cosZ
        local m02 = sinX * sinZ + cosX * sinY * cosZ

        local m10 = cosY * sinZ
        local m11 = cosX * cosZ + sinX * sinY * sinZ
        local m12 = -sinX * cosZ + cosX * sinY * sinZ

        local m20 = -sinY
        local m21 = sinX * cosY
        local m22 = cosX * cosY

        local localX = m00 * xOffset + m10 * yOffset + m20 * zOffset
        local localY = m01 * xOffset + m11 * yOffset + m21 * zOffset
        local localZ = m02 * xOffset + m12 * yOffset + m22 * zOffset

        local targetDistance = math.sqrt(localX * localX + localY * localY + localZ * localZ)
        local targetElevation = math.asin(localY / targetDistance)
        local targetHeading = math.atan(-localX, localZ)
        return targetHeading, targetElevation, targetDistance
    end
}
