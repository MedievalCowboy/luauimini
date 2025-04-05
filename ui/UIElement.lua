local utils = require("src.utils")
local UIElement = utils.Class()

function UIElement:initialize(x, y, width, height, backgroundColor, hoverColor)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 50
  self.height = height or 30
  self.backgroundColor = backgroundColor or utils.color.RGBA.white
  self.hoverColor = hoverColor or nil
  self.color = self.backgroundColor
  self.text = nil -- Texto simple o instancia de UIText
  self.textColor = utils.color.RGBA.white
  self.isHovered = false
  self.pressCallback = nil
  self.releaseCallback = nil
  self.hoverCallback = nil
end

function UIElement:onMousePress(callback)
  self.pressCallback = callback
end

function UIElement:onMouseRelease(callback)
  self.releaseCallback = callback
end

function UIElement:onMouseHover(callback)
  self.hoverCallback = callback
end

function UIElement:draw()
  -- Dibujar fondo
  self.color = self.isHovered and self.hoverColor or self.backgroundColor
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height)

  -- Dibujar texto
  if self.text then
    love.graphics.setColor(self.textColor)
    if type(self.text) == "string" then
      -- Texto simple
      love.graphics.print(self.text, 0, self.height / 2 - 6)
    elseif self.text.draw then
      -- Instancia de UIText
      self.text:draw(0, self.height / 2 - (self.text.font:getHeight() / 2), self.width, "center")
    end
  end

  love.graphics.setColor(1, 1, 1) -- Restablecer el color
end

function UIElement:setText(text, textColor)
  self.text = text
  self.textColor = textColor or utils.color.RGBA.white
end

function UIElement:mousepressed(x, y, button, istouch)
  print("is pressed: ")
  if self.pressCallback then
    self.pressCallback(self)
  end
end

function UIElement:mousereleased(x, y, button, istouch)
  print("is released: ")
  if self.releaseCallback then
    self.releaseCallback(self)
  end
end

function UIElement:hover(x, y)
  print("is hovered: ")

  if self.isHovered then
    
    if self.hoverCallback then
      self.hoverCallback(self)
    end
  end
end

return UIElement