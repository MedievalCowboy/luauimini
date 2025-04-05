local utils = require("src.utils")
local UIContainer = utils.Class()

-- Método para extender la clase base
function UIContainer:extend()
  local cls = {}
  for k, v in pairs(self) do
    cls[k] = v
  end
  cls.__index = cls
  setmetatable(cls, self)
  return cls
end

--[[
  Constructor de la clase UIContainer.
  Parámetros:
    x (number): La coordenada x de la posición del contenedor.
    y (number): La coordenada y de la posición del contenedor.
    width (number): El ancho del contenedor.
    height (number): La altura del contenedor.
    layout (string, opcional): El tipo de layout a aplicar.
                                 Valores posibles: "vertical", "horizontal".
                                 Por defecto: nil (sin layout automático).
  Retorna:
    UIContainer: Una nueva instancia de la clase UIContainer.
]]
function UIContainer:initialize(x, y, width, height, layout, color, align)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 0
  self.height = height or 0
  self.children = {} -- Tabla para almacenar los elementos hijos
  self.layout = layout -- Tipo de layout a aplicar
  self.gap = 0 -- Espacio entre elementos por defecto
  self.color = color or nil
  self.align = align or { horizontal = "left", vertical = "top" } -- Alineación por defecto
end

--[[
  Método para establecer el tipo de layout del contenedor.

  Parámetros:
    layout (string): El tipo de layout a establecer ("vertical" o "horizontal").
]]
function UIContainer:setLayout(layout)
  self.layout = layout
  self:refreshLayout() -- Reorganizamos los elementos al cambiar el layout
end

--[[ 
  Método para establecer el gap (espacio) entre los elementos del layout.

  Parámetros:
    gap (number): La cantidad de espacio entre los elementos.
]]
function UIContainer:setGap(gap)
  self.gap = gap or 0
  self:refreshLayout() -- Reorganizamos los elementos al cambiar el gap
end

--[[ 
  Método para establecer el alineamiento del contenedor.

  Parámetros:
    align (table): Tabla con las claves `horizontal` y `vertical`.
                   Valores posibles:
                     - horizontal: "left", "center", "right".
                     - vertical: "top", "center", "bottom".
]]
function UIContainer:setAlign(align)
  self.align = align
  self:refreshLayout() -- Reorganizamos los elementos al cambiar el alineamiento
end

--[[
  Método para añadir un elemento hijo al contenedor.

  Este método permite agregar otros elementos de UI y, si hay un layout
  definido, posiciona el nuevo elemento automáticamente.

  Parámetros:
    child (table): El elemento de UI a añadir. Debe tener propiedades
                   como `width` y `height` si se usa el layout automático.
]]
function UIContainer:add(child)
  table.insert(self.children, child)
  self:refreshLayout() -- Reorganizamos los elementos al añadir uno nuevo
end

--[[
  Método para eliminar un elemento hijo del contenedor.

  Este método permite remover un elemento específico del contenedor y
  reorganiza el layout si está activo.

  Parámetros:
    child (table): El elemento de UI a eliminar.
]]
function UIContainer:remove(child)
  for i, v in ipairs(self.children) do
    if v == child then
      table.remove(self.children, i)
      self:refreshLayout() -- Reorganizamos el layout al eliminar un elemento
      break
    end
  end
end

--[[
  Método para refrescar (recalcular) la posición de los elementos hijos
  basándose en el layout actual.

  Este método se llama automáticamente cuando se añade o elimina un elemento
  o cuando se cambia el tipo de layout o el padding.
]]
function UIContainer:refreshLayout()
  -- Ajuste de layout 
  if self.layout == "vertical" then
    local currentY = 0
    for _, child in ipairs(self.children) do
      if child.height then
        child.y = currentY
        -- Alineación horizontal
        if self.align.horizontal == "center" then
          child.x = (self.width - (child.width or 0)) / 2
        elseif self.align.horizontal == "right" then
          child.x = self.width - (child.width or 0)
        else
          child.x = 0 -- Por defecto, alineación a la izquierda
        end
        currentY = currentY + child.height + self.gap
      end
    end
  elseif self.layout == "horizontal" then
    local currentX = 0
    for _, child in ipairs(self.children) do
      if child.width then
        child.x = currentX
        -- Alineación vertical
        if self.align.vertical == "center" then
          child.y = (self.height - (child.height or 0)) / 2
        elseif self.align.vertical == "bottom" then
          child.y = self.height - (child.height or 0)
        else
          child.y = 0 -- Por defecto, alineación superior
        end
        currentX = currentX + child.width + self.gap
      end
    end
    
    -- Ajustar alineación horizontal del grupo completo si es necesario
    if self.align.horizontal == "center" then
      local totalWidth = currentX - self.gap
      local offsetX = (self.width - totalWidth) / 2
      for _, child in ipairs(self.children) do
        child.x = child.x + offsetX
      end
    elseif self.align.horizontal == "right" then
      local totalWidth = currentX - self.gap
      local offsetX = self.width - totalWidth
      for _, child in ipairs(self.children) do
        child.x = child.x + offsetX
      end
    end
  end
end

--[[
  Método para dibujar el contenedor y todos sus elementos hijos.

  Este método itera a través de los elementos hijos y llama a su método `draw`.
  Es importante que los elementos hijos implementen un método `draw`.

  Parámetros:
    No recibe parámetros.
]]
function UIContainer:draw()
  
  love.graphics.push() -- Guardamos la transformación actual
  love.graphics.translate(self.x, self.y) -- Trasladamos el contexto al origen del contenedor

  if self.color then
    love.graphics.setColor(self.color)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)  
  end

  for _, child in ipairs(self.children) do
    if child.draw then
      love.graphics.push() -- Guardamos la transformación para el hijo
      love.graphics.translate(child.x or 0, child.y or 0) -- Trasladamos al hijo
      child:draw()
      love.graphics.pop() -- Restauramos la transformación del hijo
    end
  end

  love.graphics.pop() -- Restauramos la transformación anterior
end

--[[
  Método para actualizar el contenedor y todos sus elementos hijos.
  Parámetros:
    dt (number): El tiempo transcurrido desde la última actualización (delta time).
]]
function UIContainer:update(dt)
  for _, child in ipairs(self.children) do
    if child.update then
      child:update(dt)
    end
  end
end

--[[
  Método para manejar el evento de presión del ratón.
  Parámetros:
    x (number): La coordenada x del clic del ratón.
    y (number): La coordenada y del clic del ratón.
    button (number): El botón del ratón presionado.
    istouch (boolean): Indica si el evento fue un toque (para dispositivos táctiles).
]]
function UIContainer:mousepressed(x, y, button, istouch)
  local relativeX = x - self.x
  local relativeY = y - self.y

  for _, child in ipairs(self.children) do
    if child.mousepressed then
      local childX = child.x or 0
      local childY = child.y or 0
      -- Verificamos si el clic está dentro de los límites del hijo
      if relativeX >= childX and relativeX < childX + (child.width or 0) and
         relativeY >= childY and relativeY < childY + (child.height or 0) then
        child:mousepressed(relativeX - childX, relativeY - childY, button, istouch)
      end
    end
  end
end

--[[
  Método para manejar el evento de liberación del ratón.
  Parámetros:
    x (number): La coordenada x de la liberación del ratón.
    y (number): La coordenada y del ratón liberado.
    button (number): El botón del ratón liberado.
    istouch (boolean): Indica si el evento fue un toque.
]]
function UIContainer:mousereleased(x, y, button, istouch)
  local relativeX = x - self.x
  local relativeY = y - self.y

  for _, child in ipairs(self.children) do
    if child.mousereleased then
      local childX = child.x or 0
      local childY = child.y or 0
      -- Verificamos si la liberación está dentro de los límites del hijo
      if relativeX >= childX and relativeX < childX + (child.width or 0) and
         relativeY >= childY and relativeY < childY + (child.height or 0) then
        child:mousereleased(relativeX - childX, relativeY - childY, button, istouch)
      end
    end
  end
end

--[[
  Método para manejar el evento de movimiento del ratón.
  Parámetros:
    x (number): La coordenada x del ratón.
    y (number): La coordenada y del ratón.
    dx (number): Cambio en la coordenada x desde el último movimiento.
    dy (number): Cambio en la coordenada y desde el último movimiento.
    istouch (boolean): Indica si el evento fue un toque.
]]
function UIContainer:mousemoved(x, y, dx, dy, istouch)
  local relativeX = x - self.x
  local relativeY = y - self.y

  for _, child in ipairs(self.children) do
    if child.hover then
      local childX = child.x or 0
      local childY = child.y or 0
      local childWidth = child.width or 0
      local childHeight = child.height or 0

      -- Verificamos si el cursor está dentro de los límites del hijo
      local isHovered = relativeX >= childX and relativeX < childX + childWidth and
                        relativeY >= childY and relativeY < childY + childHeight

      -- Llamamos a hover solo si el estado cambia
      if isHovered ~= (child.isHovered or false) then
        child.isHovered = isHovered
        if child.hover then
          child:hover(relativeX - childX, relativeY - childY, isHovered)
        end
      end
    end
  end
end

--[[ 
  Método para establecer la posición del contenedor.
  Parámetros:
    x (number): La nueva coordenada x del contenedor.
    y (number): La nueva coordenada y del contenedor.
]]
function UIContainer:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

return UIContainer