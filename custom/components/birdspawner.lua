AddComponentPostInit("birdspawner", function(self)
    local oldSpawnBird=self.SpawnBird
    self.SpawnBird = function(self,spawnpoint,ignorebait)
        if spawnpoint and spawnpoint.x and spawnpoint.z then
            if #(TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 100, {"drive_bird_scarecrow"})) >0 then
                return
            end
        end
        if oldSpawnBird then
            return oldSpawnBird(self,spawnpoint,ignorebait)
        end
    end
end)
