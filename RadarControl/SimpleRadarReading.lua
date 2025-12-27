require("RadarControl.RadarGPS")

-- id is the radar input from 0-7
function readFromRadartoXYZ(selfX,selfY,selfZ,eulerX,eulerY,eulerZ,id,minimumDistance)
	local DistanceTo=input.getNumber(1+(id-1)*4)
	local x,y,z = radarPosToXYZ(selfX,selfY,selfZ,eulerX,eulerY,eulerZ,input.getNumber(2+(id-1)*4),input.getNumber(3+(id-1)*4),DistanceTo)

	if DistanceTo >= minimumDistance then
		return x,y,z,DistanceTo,input.getBool(1+(id-1)*4)
	else
        return 0,0,0,0,false
    end
end

function readFromRadar(id,minimumDistance)
	local DistanceTo=input.getNumber(1+(id-1)*4)

	if DistanceTo >= minimumDistance then
		return input.getNumber(2+(id-1)*4),input.getNumber(3+(id-1)*4),DistanceTo,input.getBool(1+(id-1)*4)
	else
        return 0,0,0,0,false
    end
end