require("RadarControl.RadarGPS")

simpleRadarReading = {
	---comment
	---@param selfX number self x pos
	---@param selfY number self y pos
	---@param selfZ number self z pos
	---@param eulerX number self euler x
	---@param eulerY number self euler y
	---@param eulerZ number self euler z
	---@param id number chanel id to search on 0-7
	---@param minimumDistance number minimumDistance for finding target
	---@return number x target x
	---@return number y target y
	---@return number z target z
	---@return number distanceTo distance to target
	---@return boolean isDetected if target is detected
	readFromRadartoXYZ = function(selfX, selfY, selfZ, eulerX, eulerY, eulerZ, id, minimumDistance)
		local DistanceTo = input.getNumber(1 + (id - 1) * 4)
		local x, y, z = radarGPS.radarPosToXYZ(selfX, selfY, selfZ, eulerX, eulerY, eulerZ,
			input.getNumber(2 + (id - 1) *
				4), input.getNumber(3 + (id - 1) * 4), DistanceTo)

		if DistanceTo >= minimumDistance then
			return x, y, z, DistanceTo, input.getBool(1 + (id - 1) * 4)
		else
			return 0, 0, 0, 0, false
		end
	end,

	---comment
	---@param id number chanel id to search on 0-7
	---@param minimumDistance number minimumDistance for finding target
	---@return number heading target heading
	---@return number elevation target elevation
	---@return number distanceTo distance to target
	---@return boolean isDetected if target is detected
	readFromRadar = function(id, minimumDistance)
		local DistanceTo = input.getNumber(1 + (id - 1) * 4)

		if DistanceTo >= minimumDistance then
			return input.getNumber(2 + (id - 1) * 4), input.getNumber(3 + (id - 1) * 4), DistanceTo,
				input.getBool(1 + (id - 1) * 4)
		else
			return 0, 0, 0, false
		end
	end
}
