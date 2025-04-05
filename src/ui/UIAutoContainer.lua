local UIContainer = require("src.ui.UIContainer")
local utils = require("src.utils")
local UIAutoContainer = utils.Class(UIContainer)

--[[ 
  Constructor de la clase UIAutoContainer.
  Parámetros:
    x (number): La coordenada x de la posición del contenedor.
    y (number): La coordenada y de la posición del contenedor.
    layout (string, opcional): El tipo de layout a aplicar ("vertical" o "horizontal").
    color (table, opcional): Color del contenedor.
]]
function UIAutoContainer:initialize(x, y, layout, color)
  UIContainer.initialize(self, x, y, 0, 0, layout, color) -- Llamamos al constructor base
end

--[[ 
  Método para establecer la posición del contenedor automático.
  Parámetros:
    x (number): La nueva coordenada x del contenedor.
    y (number): La nueva coordenada y del contenedor.
]]
function UIAutoContainer:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

--[[ 
  Método para recalcular las posiciones de los elementos hijos y ajustar el tamaño del contenedor.
]]
function UIAutoContainer:refreshLayout()
  local totalWidth, totalHeight = 0, 0
  local currentX, currentY = 0, 0

  if self.layout == "horizontal" then
    for i, child in ipairs(self.children) do
      if child.width and child.height then
        -- Posicionar el hijo horizontalmente
        child.x = currentX
        child.y = 0 -- Alineación vertical por defecto (parte superior)
        currentX = currentX + child.width
        if i < #self.children then
          currentX = currentX + self.gap -- Agregar gap entre elementos
        end
        -- Ajustar el alto total del contenedor
        totalHeight = math.max(totalHeight, child.height)
      end
    end
    totalWidth = currentX -- Ajustar el ancho total
  elseif self.layout == "vertical" then
    for i, child in ipairs(self.children) do
      if child.width and child.height then
        -- Posicionar el hijo verticalmente
        child.x = 0 -- Alineación horizontal por defecto (izquierda)
        child.y = currentY
        currentY = currentY + child.height
        if i < #self.children then
          currentY = currentY + self.gap -- Agregar gap entre elementos
        end
        -- Ajustar el ancho total del contenedor
        totalWidth = math.max(totalWidth, child.width)
      end
    end
    totalHeight = currentY -- Ajustar el alto total
  end

  -- Actualizar el tamaño del contenedor según el contenido
  self.width = totalWidth
  self.height = totalHeight
end

--[[ 
  Método para dibujar el contenedor y sus elementos hijos.
]]
function UIAutoContainer:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y) -- Trasladar al origen del contenedor

  -- Dibujar el contenedor (borde opcional para depuración)
  if self.color then
    love.graphics.setColor(self.color)
    love.graphics.rectangle("line", 0, 0, self.width, self.height) -- Dibujar borde del contenedor
  end

  -- Dibujar los elementos hijos
  for _, child in ipairs(self.children) do
    if child.draw then
      love.graphics.push()
      love.graphics.translate(child.x or 0, child.y or 0) -- Trasladar al origen del hijo
      child:draw()
      love.graphics.pop()
    end
  end

  love.graphics.pop()
end

return UIAutoContainer
