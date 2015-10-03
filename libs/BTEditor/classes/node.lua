local existInTable = function(t, item)
  for k,v in pairs(t) do
    if v == item then
      return true
    end
  end
  return false
end

local composite = require("nodes.composite")
local conditional = require("nodes.conditional")
local decorator = require("nodes.decorator")
local action = require("nodes.action")


--- node

local node = SECS_class:new()

function node:init(pname,ptype,pfunc,pid,px,py,pwidth,pheight,pparent,pindexchild)

  --- common properties for node
  self.name = pname or ""
  self.type = ptype or ""
  self.func = pfunc or ""
  self.id = pid
  if self.id==nil then
    self.id = generateId("node")
  end
  self.x = px
  self.y = py
  self.textwidth, self.textlines = fonts[","..EDITOR.fontsize]:getWrap(self.type.."\n"..self.name.."\n"..self.func.." ", 400)
  self.width = pwidth
  if pwidth==nil then
    self:changeWidth()
  end
  self.height = nvl(pheight,EDITOR.fontsize*2+EDITOR.fontsize*self.textlines)
  self.selected = false
  self.parent = pparent
  self.children={}
  self.level = 1
  self.sleep = false
  if self.parent then
    self.level = self.parent.level+1
  end
  self.indexchild = pindexchild
  if self.indexchild ==nil then
    self.indexchild = 1
    if self.parent then
      for i,v in ipairs(self.parent.children) do
        self.indexchild = self.indexchild +1
      end
    end
  end
  if self.x==nil then
    if self.parent then
      self.x = self.parent.x+self.parent.width/2+(self.indexchild-1)*64-self.width/2
      for i,v in ipairs (self.parent.children) do
        self.x = v.x+v.width+5
      end
    else
      self.x = (self.indexchild-1)*64
    end
  end
  if self.y==nil then
    if self.parent then
      self.y = self.parent.y+EDITOR.divisory
    else
      self.y = (self.level-1)*EDITOR.divisory*2
    end
  end
  self.levelindex = self.level*10+self.indexchild
  self.valid=nil
end

function node:update(dt)

  return true

end

function node:draw(pclipifoutsidecamera)
  local _draw = true
  if pclipifoutsidecamera then
    if self.x+self.width < EDITOR.cameraworld.x1 or self.x > EDITOR.cameraworld.x2 or self.y+self.height < EDITOR.cameraworld.y1 or self.y > EDITOR.cameraworld.y2 then
      _draw = false
    end
  end
  if _draw then
    if self.selected then
      love.graphics.setLine(3, "smooth")
    else
      love.graphics.setLine(1, "smooth")
    end
    love.graphics.setFont(fonts[","..EDITOR.fontsize])
    self:drawShape("fill")
    love.graphics.setColor(0,0,0,255)
    self:drawShape("line")
    if self.selected then
      love.graphics.setLine(1, "smooth")
      love.graphics.setColor(255,255,0,255)
      self:drawShape("line")
      love.graphics.setLine(3, "smooth")
      love.graphics.setColor(0,0,0,255)
    end
    if self.type=="Selector" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(images.selector,self.x+2,self.y+2)
    end
    if self.type=="RandomSelector" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(images.randomselector,self.x+2,self.y+2)
    end
    if self.type=="Sequence" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(images.sequence,self.x+2,self.y+2)
      if self.children and #self.children>0 then
        local _minx, _maxx, _avgy, _child
        for i=1,#self.children do
          _child = self.children[i]
          if i==1 or _child.x+_child.width/2<_minx then
            _avgy = (self.y+self.height+_child.y)/2
            _minx = _child.x+_child.width/2
          end
          if i==1 or _child.x+_child.width/2>_maxx then
            _maxx = _child.x+_child.width/2
          end
        end
        if _minx == _maxx then
          _minx = _minx - 10
          _maxx = _maxx + 10
        end
        love.graphics.setColor(128,128,128,255)
        EDITOR.drawArrow(_minx,_avgy,_maxx,_avgy,EDITOR.arrowsize)
      end
    end
    if self.type=="Action" or self.type=="ActionResume" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(images.action,self.x+2,self.y+2)
    end
    if self.type=="Decorator" or self.type=="RepeatUntil" or self.type=="Continue"  or self.type=="Wait" or self.type=="WaitContinue" or self.type == "Filter" or self.type == "Sleep"  or self.type == "DecoratorContinue" then
      if self.type == "Filter" then
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(images.condition,self.x+2,self.y+2)
      end
    end
    if self.type=="Condition" then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(images.condition,self.x+2,self.y+2)
    end
    love.graphics.setColor(0,0,0,255)
    if self.type=="Start" then
      love.graphics.printf(self.type.."\n"..self.name.."\n"..self.func,self.x,self.y+EDITOR.fontsize*3/2,self.width,"center")
    else
      love.graphics.printf(self.type.."\n"..self.name.."\n"..self.func,self.x,self.y+EDITOR.fontsize/2,self.width,"center")
    end
    if self.validtext then
      love.graphics.setColor(255,0,0,255)
      love.graphics.print(self.validtext,self.x,self.y+self.height+2)
    end
  end
  love.graphics.setLineWidth(1)

  if self.parent and self.parent.children then
    local _drawarrow = true
    if _draw==false then
      -- TODO: add filter to avoid drawing arrows outside 'screen'
    end
    if _drawarrow then
      love.graphics.setColor(0,0,0,255)
      local _position_child = 0.25+(self.indexchild/(#self.parent.children+1))/2
      EDITOR.drawArrow(self.parent.x+self.parent.width*_position_child,self.parent.y+self.parent.height+2,self.x+self.width/2,self.y-2,EDITOR.arrowsize)
    end
  end
  --if self.children then
  --  for i,v in ipairs(self.children) do
  --    love.graphics.setColor(64,64,64,255)
  --    EDITOR.drawArrow(self.x+self.width/2,self.y+self.height+2,v.x+v.width/2,v.y-2,EDITOR.arrowsize)
  --  end
  --end
end

function node:changeWidth()
  self.textwidth, self.textlines = fonts[","..EDITOR.fontsize]:getWrap(self.type.."\n"..self.name.."\n"..self.func.." ", 400)
  local _increment = 28
  if (self.type=="Condition") then
    _increment =EDITOR.fontsize*4+28
  end
  self.width = self.textwidth+_increment
end

function node:validate()

  local _valid = true
  local _validtext = ""
  if self.type == "Start" then
    if self.children==nil or #self.children==0 then
      _valid = false
      _validtext = _validtext..", At least one child node"
    end
    if self.children~=nil and #self.children>1 then
      _valid = false
      _validtext = _validtext..", Only one child allowed"
    end

  elseif existInTable(composite, self.type) then
    if self.children==nil or #self.children==0 then
      _valid = false
      _validtext = _validtext..", At least one child node"
    end

  elseif existInTable(conditional, self.type) then
    if self.children~=nil and #self.children>0 then
      _valid = false
      _validtext = _validtext..", Childs are forbidden"
    end


  elseif existInTable(action, self.type) then
    if self.children~=nil and #self.children>0 then
      _valid = false
      _validtext = _validtext..", Children are forbidden"
    end
  
  elseif existInTable(decorator, self.type) then
    if self.children==nil or #self.children==0 then
      _valid = false
      _validtext = _validtext..", At least one child"
    end
    if self.children~=nil and #self.children>1 then
      _valid = false
      _validtext = _validtext..", Only one child allowed"
    end
  end
  if _validtext =="" then
    _validtext = nil
  elseif string.sub(_validtext,1,2) == ", " then
    _validtext = string.sub(_validtext,3,string.len(_validtext))
  end
  self.valid = _valid
  self.validtext = _validtext
  return self.valid, self.validtext
end

function node:drawShape(pmode)
  self:drawShape2(self.type,pmode,self.x-5,self.y,self.width+10,self.height)
end
-- function node:drawShape2(ptype,pmode,px,py,pwidth,pheight)
--   if ptype=="Start" then
--     if pmode=="fill" then
--       love.graphics.setColor(255,255,255,255)
--     end
--     love.graphics.circle(pmode,px+pwidth/2,py+pheight/2,pheight/2)
--   elseif ptype=="Selector" or ptype=="RandomSelector" then
--     if pmode=="fill" then
--       love.graphics.setColor(255,150,70,255)
--     end
--     love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
--   elseif ptype=="Sequence" then
--     if pmode=="fill" then
--       love.graphics.setColor(150,255,150,255)
--     end
--     love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
--   elseif ptype=="Action" or ptype=="ActionResume" then
--     if pmode=="fill" then
--       love.graphics.setColor(150,150,255,255)
--     end
--     love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
--   elseif ptype=="Decorator" or ptype=="RepeatUntil" or ptype=="Continue"  or ptype=="Wait" or ptype=="WaitContinue" or ptype == "Filter" or ptype == "Sleep"  or ptype == "DecoratorContinue" then
--     if pmode=="fill" then
--       love.graphics.setColor(255,255,100,255)
--     end
--     love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
--   elseif ptype=="Condition" then
--     if pmode=="fill" then
--       love.graphics.setColor(150,255,150,255)
--     end
--     love.graphics.polygon(pmode,px+pwidth/2,py,px+pwidth,py+pheight/2,px+pwidth/2,py+pheight,px,py+pheight/2)
--   else
--     if pmode=="fill" then
--       love.graphics.setColor(100,0,100,255)
--     end
--     love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
--   end
-- end



function node:drawShape2(ptype,pmode,px,py,pwidth,pheight)
  -- 起始节点
  if ptype=="Start" then
    if pmode=="fill" then
      love.graphics.setColor(255,255,255,255)
    end
    love.graphics.circle(pmode,px+pwidth/2,py+pheight/2,pheight/2)

    -- 组合节点
  elseif existInTable(composite, ptype) then
    if pmode=="fill" then
      love.graphics.setColor(100,200,100,255)
    end
    love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)

    -- Action
  elseif existInTable(action, ptype) then
    if pmode=="fill" then
      love.graphics.setColor(255,255,100,255)
    end
    love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
  
    -- Decorator
  elseif existInTable(decorator, ptype) then
    if pmode=="fill" then
      love.graphics.setColor(150,150,255,255)
    end
    love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
  
    -- Conditional
  elseif existInTable(conditional, ptype) then
    if pmode=="fill" then
      love.graphics.setColor(255,150,70,255)
    end
    love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
  else
    if pmode=="fill" then
      love.graphics.setColor(100,100,100,255)
    end
    love.graphics.polygon(pmode,px,py,px+pwidth,py,px+pwidth,py+pheight,px,py+pheight)
  end
end

return node