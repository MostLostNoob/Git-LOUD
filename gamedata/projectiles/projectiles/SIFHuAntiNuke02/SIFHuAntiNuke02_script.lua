local SIFHuAntiNuke = import('/lua/seraphimprojectiles.lua').SIFHuAntiNuke

local EffectTemplate = import('/lua/EffectTemplates.lua')

local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local RandomInt = import('/lua/utilities.lua').GetRandomInt

SIFHuAntiNuke01 = Class(SIFHuAntiNuke) {

    OnImpact = function(self, TargetType, TargetEntity) 

        local FxHitEffect = EffectTemplate.SKhuAntiNukeHit 
        local LargeTendrilProjectile = '/effects/Entities/SIFHuAntiNuke02/SIFHuAntiNuke02_proj.bp'  
        local SmallTendrilProjectile = '/effects/Entities/SIFHuAntiNuke03/SIFHuAntiNuke03_proj.bp'  

        for k, v in FxHitEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
    
        local vx, vy, vz = self:GetVelocity()
        local velocity = 19

        local num_projectiles = 5
        local horizontal_angle = 6.28 / num_projectiles
        local angleInitial = RandomFloat( 0, horizontal_angle )
        
        local angleVariation = horizontal_angle * 0.25
        local spreadMul = 0.15
        
        local xVec
        local yVec
        local zVec

        for i = 0, (num_projectiles -1) do

            xVec = (math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))) * RandomFloat(1,5)
            yVec =  RandomFloat(-3,33)
            zVec = (math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))) * RandomFloat(1,5)

            local proj = self:CreateChildProjectile(LargeTendrilProjectile):SetLifetime( RandomFloat(0.4,0.65) ) :SetVelocity(velocity)

            proj:SetBallisticAcceleration(0,-89.92,0)
            proj:SetVelocity(xVec,yVec,zVec)
        end
        
        num_projectiles= RandomInt((num_projectiles + 3),(num_projectiles*2 + 3) )
        horizontal_angle = 6.28 / num_projectiles
        
        for i = 0, (num_projectiles -1) do

            xVec = vx + (math.sin(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))) * RandomFloat(1,5)
            yVec = RandomFloat(-3,33)
            zVec = vz + (math.cos(angleInitial + (i*horizontal_angle) + RandomFloat(-angleVariation, angleVariation))) * RandomFloat(1,5)

            local proj = self:CreateChildProjectile(SmallTendrilProjectile):SetLifetime(RandomFloat(0.25,0.35)):SetVelocity(xVec,yVec,zVec):SetVelocity(velocity)

            proj:SetBallisticAcceleration(0,-89.92,0)
        end
        
        SIFHuAntiNuke.OnImpact(self, TargetType, TargetEntity)
    end,

}
TypeClass = SIFHuAntiNuke01

