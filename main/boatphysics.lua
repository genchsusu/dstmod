AddComponentPostInit("boatphysics", function(BoatPhysics)
    BoatPhysics.GetRudderTurnSpeed = function(self)
        local speed = TUNING.BOAT.RUDDER_TURN_SPEED
        return speed
    end
end)