local AMissileSerpentineProjectile = import('/lua/aeonprojectiles.lua').AMissileSerpentineProjectile

local ForkThread = ForkThread
local KillThread = KillThread
local WaitSeconds = WaitSeconds

AIFMissileSerpentine02 = Class(AMissileSerpentineProjectile) {

    FxWaterHitScale = 1.65,

    OnCreate = function(self)
        AMissileSerpentineProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self:ForkThread( self.MovementThread )
    end,

    MovementThread = function(self)        
        self.WaitTime = 0.1
        self:SetTurnRate(8)
        WaitSeconds(0.3)        
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()

        -- Get the nuke as close to 90 deg as possible
        if dist > 50 then        
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(20)

        elseif dist > 64 and dist <= 107 then
			self:SetTurnRate(30)
			WaitSeconds(1.5)
            self:SetTurnRate(30)

        elseif dist > 21 and dist <= 53 then
            WaitSeconds(0.3)
            self:SetTurnRate(50)

		elseif dist > 0 and dist <= 21 then
            self:SetTurnRate(100)   
            KillThread(self.MoveThread)         
        end
    end,        

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
    
    OnExitWater = function(self)
        AMissileSerpentineProjectile.OnExitWater(self)
        self:SetDestroyOnWater(true)
    end,
}

TypeClass = AIFMissileSerpentine02