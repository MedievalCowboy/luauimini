local utils = require("src.utils")
local UIElement = require("src.ui.UIElement")

local UIText = {}
UIText.__index = UIText

--[[ 
  Constructor de la clase UIText.
  Parámetros:
    text (string): El contenido del texto.
    font (Font, opcional): La fuente del texto (por defecto, la fuente actual de Love2D).
    color (table, opcional): El color del texto en formato RGBA (por defecto, blanco).
]]
function UIText:new(text, font, color)
  local instance = setmetatable({}, UIText)
  instance.text = text or ""
  instance.font = font or love.graphics.getFont() -- Usar la fuente actual si no se especifica
  instance.color = color or { 1, 1, 1, 1 } -- Blanco por defecto
  return instance
end

--[[ 
  Método para dibujar el texto.
  Parámetros:
    x (number): La posición x donde se dibujará el texto.
    y (number): La posición y donde se dibujará el texto.
    width (number, opcional): El ancho máximo del área de texto (para alineación).
    align (string, opcional): Alineación del texto ("left", "center", "right").
]]
function UIText:draw(x, y, width, align)
  love.graphics.push()
  love.graphics.setFont(self.font)
  love.graphics.setColor(self.color)
  if width then
    love.graphics.printf(self.text, x, y, width, align or "left")
  else
    love.graphics.print(self.text, x, y)
  end
  love.graphics.pop()
end

--[[ 
  Método para cambiar el texto.
  Parámetros:
    newText (string): El nuevo contenido del texto.
]]
function UIText:setText(newText)
  self.text = newText
end

--[[ 
  Método para cambiar la fuente.
  Parámetros:
    newFont (Font): La nueva fuente a usar.
]]
function UIText:setFont(newFont)
  self.font = newFont
end

--[[ 
  Método para cambiar el tamaño de la fuente.
  Parámetros:
    size (number): El nuevo tamaño de la fuente.
]]
function UIText:setFontSize(size)
  self.font = love.graphics.newFont(size) -- Crear una nueva fuente con el tamaño especificado
end

--[[ 
  Método para cambiar el color.
  Parámetros:
    newColor (table): El nuevo color en formato RGBA.
]]
function UIText:setColor(newColor)
  self.color = newColor
end

return UIText