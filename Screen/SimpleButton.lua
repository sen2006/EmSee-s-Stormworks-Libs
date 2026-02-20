---@class simpleButton : BaseClass
---@field buttonWidth number
---@field buttonHeight number
---@field posX number
---@field posY number
EmSeeLib.simpleButton = {
    buttonWidth = 0,
    buttonHeight = 0,
    posX = 0,
    posY = 0,
    onPress = nil,
    whilePressed = nil,
    onRelease = nil,
    isWasPressed = false,

    tick = function(self, isTouch, touchX, touchY, isTouch2, touchX2, touchY2)
        if (isTouch and EmSeeLib.simpleButton.isInButton(self, touchX, touchY)) or (isTouch2 and EmSeeLib.simpleButton.isInButton(self, touchX2, touchY2)) then
            if self.whilePressed ~= nil then
                self.whilePressed()
            end
            if not self.isWasPressed then
                self.isWasPressed = true
                if self.onPress ~= nil then
                    self.onPress()
                end
            end
        else
            if self.isWasPressed then
                self.isWasPressed = false
                if self.onRelease ~= nil then
                    self.onRelease()
                end
            end
        end
    end,

    isInButton = function(self, touchX, touchY)
        return touchX >= self.posX and touchX <= (self.posX + self.buttonWidth) and
            touchY >= self.posY and touchY <= (self.posY + self.buttonHeight)
    end,
    __index = EmSeeLib.simpleButton
}



--#region Constructor
---comment
---@param posX number
---@param posY number
---@param buttonWidth number
---@param buttonHeight number
---@param opPress function|nil the function to run when this button is pressed
---@param whilePressed function|nil the function to run while this button is pressed
---@param onRelease function|nil the function to run when this button is released
---@return simpleButton
EmSeeLib.simpleButton.new = function(posX, posY, buttonWidth, buttonHeight, opPress, whilePressed, onRelease)
    self = {}

    self.posX = posX or 0
    self.posY = posY or 0
    self.buttonWidth = buttonWidth or 1
    self.buttonHeight = buttonHeight or 1
    self.onPress = opPress or nil
    self.whilePressed = whilePressed or nil
    self.onRelease = onRelease or nil

    return self
end
