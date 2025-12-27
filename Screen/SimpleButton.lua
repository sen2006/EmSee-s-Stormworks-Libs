---@class simpleButton
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

    tick = function(self, isTouch, touchX, touchY)
        if isTouch and self:isInButton(self, touchX, touchY) then
            if self.whilePressed ~= nil then
                self.whilePressed()
                if self.isWasPressed == false then
                    self.isWasPressed = true
                    if self.onPress ~= nil then
                        self.onPress()
                    end
                end
            end
        else
            if self.isWasPressed == true then
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

    --#region Constructor
    ---comment
    ---@param posX number
    ---@param posY number
    ---@param buttonWidth number
    ---@param buttonHeight number
    ---@param opPress function the function to run when this button is pressed
    ---@param whilePressed function the function to run while this button is pressed
    ---@param onRelease function the function to run when this button is released
    ---@return simpleButton
    new = function(posX, posY, buttonWidth, buttonHeight, opPress, whilePressed, onRelease)
        local self = setmetatable({}, EmSeeLib.simpleButton)

        self.posX = posX or 0
        self.posY = posY or 0
        self.buttonWidth = buttonWidth or 1
        self.buttonHeight = buttonHeight or 1
        self.onPress = opPress or nil
        self.whilePressed = whilePressed or nil
        self.onRelease = onRelease or nil

        return self
    end
}
