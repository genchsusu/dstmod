local ProtectionWall = Class(function(self, inst)
    self.inst = inst
    self.radius = 10
    self.walls = {}
end)

function ProtectionWall:SetRadius(radius)
    self.radius = radius
end

function ProtectionWall:CreateWalls()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local number = self.radius * 5
    for i = 1, number do
        local angle = (i-1) * (360 / number)
        local wx = x + self.radius * math.cos(angle * DEGREES)
        local wz = z + self.radius * math.sin(angle * DEGREES)

        -- local wall = SpawnPrefab("wall_stone")
        local wall = SpawnPrefab("fire_wall")
        wall.Transform:SetPosition(wx, 0, wz)
        if wall.components.health then
            wall.components.health:SetPercent(1)
        end

        table.insert(self.walls, wall)
    end
end

function ProtectionWall:RemoveWalls()
    for _, wall in ipairs(self.walls) do
        if wall and wall:IsValid() then
            wall:Remove()
        end
    end
    self.walls = {}
end

return ProtectionWall
