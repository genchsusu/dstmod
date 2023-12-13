-- 创建一个新的组件，用于生成保护圈
local function AddProtectionCircleComponent(inst)
    inst:AddComponent("protectioncircle")
    inst.components.protectioncircle:SetRadius(15) -- 设置保护圈的半径
end

-- protectioncircle 组件实现
local ProtectionCircle = Class(function(self, inst)
    self.inst = inst
    self.radius = 15 -- 默认半径
    self.hostileTag = "hostile"
end)

-- 设置保护圈半径
function ProtectionCircle:SetRadius(radius)
    self.radius = radius
end

-- 检查并阻止敌对生物靠近
function ProtectionCircle:OnUpdate(dt)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, self.radius, {self.hostileTag})
    for i, ent in ipairs(ents) do
        if ent:IsValid() and ent.components.locomotor then
            -- 将敌对生物推离保护圈
            local ex, ey, ez = ent.Transform:GetWorldPosition()
            local dx, dz = ex - x, ez - z
            local dist = math.sqrt(dx * dx + dz * dz)
            local pushDist = self.radius - dist + 1 -- 确保离开保护圈
            local pushAngle = math.atan2(dz, dx)
            ent.Physics:Teleport(ex + pushDist * math.cos(pushAngle), ey, ez + pushDist * math.sin(pushAngle))
        end
    end
end

-- 组件附加到对象上时启动周期性更新
function ProtectionCircle:OnAttached()
    self.inst:StartUpdatingComponent(self)
end

-- 组件从对象上移除时停止更新
function ProtectionCircle:OnDetached()
    self.inst:StopUpdatingComponent(self)
end

AddPrefabPostInit("campfire", AddProtectionCircleComponent)
AddPrefabPostInit("firepit", AddProtectionCircleComponent)
AddPrefabPostInit("coldfire", AddProtectionCircleComponent)
AddPrefabPostInit("coldfirepit", AddProtectionCircleComponent)