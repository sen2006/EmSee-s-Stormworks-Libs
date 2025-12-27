EmSeeLib.screenManager.__index = EmSeeLib.screenManager

---@class screenManager
---@field screenWidth number
---@field screenHeight number
---@field buttons table<number, simpleButton>
---@field tickers table<number, function>
EmSeeLib.screenManager = {
    screenWidth = 32,
    screenHeight = 32,
    buttons = {},
    tickers = {},

    setWidthHeight = function(self, width, height)
        self.screenWidth = width
        self.screenHeight = height
    end,

    tick = function(self, isTouch, touchX, touchY, isTouch2, touchX2, touchY2)
        for i, button in pairs(self.buttons) do
            button:checkPressed(isTouch, touchX, touchY)
            button:checkPressed(isTouch2, touchX2, touchY2)
        end
        for i, ticker in pairs(self.tickers) do
            ticker(self, isTouch, touchX, touchY, isTouch2, touchX2, touchY2)
        end
    end,

    ---comment
    ---@param button simpleButton
    addButton = function(self, button)
        self.buttons[#self.buttons + 1] = button
    end,

    ---comment
    ---@param func function function that will be called every tick by the screen manager, uses same perameters as onTick(screenManager, isTouch, touchX, touchY, isTouch2, touchX2, touchY2)
    addTickerFunction = function(self, func)
        self.tickers[#self.tickers + 1] = func
    end,



    --#region Constructor
    ---@param width number
    ---@param height number
    ---@return screenManager
    new = function(width, height)
        local self = setmetatable({}, EmSeeLib.screenManager)

        self.screenWidth = width or 32
        self.screenHeight = height or 32
        self.buttons = {}

        return self
    end
}
