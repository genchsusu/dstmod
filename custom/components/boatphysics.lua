AddComponentPostInit("boatphysics", function(BoatPhysics)
    BoatPhysics.GetRudderTurnSpeed = function(self)
        return TUNING.BOAT.RUDDER_TURN_SPEED
    end
end)