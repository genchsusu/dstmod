-- scripts\widgets\basebutton.lua
local ImageButton = require "widgets/imagebutton"

local BaseButton = Class(ImageButton, function(self, atlas, normal)
	-- atlas, normal, focus, disabled, down, selected, scale, offset
    self.position = Vector3(0, 0, 0)
	ImageButton._ctor(self, nil, nil, nil, nil, nil, nil, {1,1}, {0,0})
    self:SetTextures( atlas, normal,  nil, nil, nil, nil, {1,1}, {0,0} )
	self:SetImageNormalColour(1, 1, 1, 1)
	--self:SetImageFocusColour(.9, 1, .9, 1)
	self.move_on_click = false
	--self.scale_on_focus = false -- Having this on while dragging is a little annoying.

	self.drag_tolerance = 4
	self:SetDraggable(false)
	self:SetOnDragFinish(nil)
end)

function BaseButton:SetInitPosition(value)
    self.position = value
end

function BaseButton:ResetPosition()
	self:SetPosition(self.position)
end

function BaseButton:SetDraggable(bool)
	self.draggable = bool
	if self.draggable then
		self:SetOnDown(function()
			self:BeginDrag()
		end)
		self:SetWhileDown(function()
			self:DoDrag()
		end)
		self.onclick = function(...)
			self:EndDrag()
			if self.onclick2 then 
				return self.onclick2(...)
			end
		end
	else
		self:SetOnDown(nil)
		self:SetWhileDown(nil)
		self.onclick = function(...) 
			if self.onclick2 then 
				return self.onclick2(...)
			end
		end
	end
end

function BaseButton:SetOnDragFinish(fn)
	self.ondragfinish = fn
end

--- Overwrites the normal SetOnClick because we need to have a separate onclick to stop dragging, and to handle actual clicks.
function BaseButton:SetOnClick(fn)
	self.onclick2 = fn
end

function BaseButton:OnGainFocus()
	return ImageButton.OnGainFocus(self)
end

function BaseButton:OnLoseFocus()
	if self:IsDragging() then
		print('still dragging')
	end

	return ImageButton.OnLoseFocus(self)
end

function BaseButton:HasMoved()
	if self.drag_state == nil then
		return false
	end

	local bx, by, bz = self.drag_state.origin:Get()
	local x, y, z = self:GetPosition():Get()

	if math.abs(x - bx) + math.abs(y - by) >= self.drag_tolerance then
		return true
	end

	return false
end

function BaseButton:IsDragging()
	return self.drag_state ~= nil
end

function BaseButton:BeginDrag()
	if self:IsDragging() then
		print("ALREADY DRAGGING")
		return
	end

	if not TheFrontEnd.lastx or not TheFrontEnd.lasty then
		return
	end

	TheFrontEnd:LockFocus(true)

	self.o_pos = nil

	self.drag_state = {
		origin = self:GetPosition(),
		pos = self:GetPosition(),
		lastx = TheFrontEnd.lastx,
		lasty = TheFrontEnd.lasty
	}

	self.image:SetScale(self.normal_scale[1], self.normal_scale[2], self.normal_scale[3])
end

function BaseButton:DoDrag()
	if not self.drag_state then
		-- Happened once
		print("MISSING DRAG STATE???")
		return
	end
	local pos = self.drag_state.pos

	-- lastx was nil? Which one? Frontend?
	if not TheFrontEnd.lastx or not TheFrontEnd.lasty then
		print("FRONTEND MISSING LASTS")
		print(TheFrontEnd.lastx, TheFrontEnd.lasty)
	end

	if not self.drag_state.lastx or not self.drag_state.lasty then
		print("STATE MISSING LASTS")
		print(self.drag_state.lastx, self.drag_state.lasty)
	end

	local deltax = TheFrontEnd.lastx - self.drag_state.lastx
	local deltay = TheFrontEnd.lasty - self.drag_state.lasty

	local scale = self:GetScale()
	local screen_width, screen_height = TheSim:GetScreenSize()
	screen_width = screen_width / scale.x
	screen_height = screen_height / scale.y

	deltax = deltax / scale.x
	deltay = deltay / scale.y
	
	local nx = pos.x + deltax
	local ny = pos.y + deltay

	local a, b = self:GetSize()

	nx = math.clamp(nx, -screen_width + a/2, -a/2) -- 0,0 is bottom right of screen
	ny = math.clamp(ny, b/2, screen_height - b/2)
	
	self.drag_state.pos = Vector3(nx, ny, pos.z)
	self:SetPosition(self.drag_state.pos)

	self.drag_state.lastx = TheFrontEnd.lastx
	self.drag_state.lasty = TheFrontEnd.lasty
end

function BaseButton:EndDrag()
	if not self:IsDragging() then
		print'\tnot dragging?'
		return
	end

	TheFrontEnd:LockFocus(false)
	
	if self.ondragfinish and self:HasMoved() then
		self.ondragfinish(self.drag_state.origin, self:GetPosition())
	end

	self.drag_state = nil

	if self.focus then
		self.image:SetScale(self.focus_scale[1], self.focus_scale[2], self.focus_scale[3])
	end
end

return BaseButton