---  /lua/seraphimunits.lua

-- SERAPHIM DEFAULT UNITS

local DefaultUnitsFile = import('defaultunits.lua')

local AirStagingPlatformUnit        = DefaultUnitsFile.AirStagingPlatformUnit
local AirUnit                       = DefaultUnitsFile.AirUnit
local ConcreteStructureUnit         = DefaultUnitsFile.ConcreteStructureUnit
local WallStructureUnit             = DefaultUnitsFile.WallStructureUnit
local ConstructionUnit              = DefaultUnitsFile.ConstructionUnit
local EnergyCreationUnit            = DefaultUnitsFile.EnergyCreationUnit
local FactoryUnit                   = DefaultUnitsFile.FactoryUnit
local MassCollectionUnit            = DefaultUnitsFile.MassCollectionUnit
local MassFabricationUnit           = DefaultUnitsFile.MassFabricationUnit
local MobileUnit                    = DefaultUnitsFile.MobileUnit
local RadarUnit                     = DefaultUnitsFile.RadarUnit
local SeaUnit                       = DefaultUnitsFile.SeaUnit
local ShieldStructureUnit           = DefaultUnitsFile.StructureUnit
local SonarUnit                     = DefaultUnitsFile.SonarUnit
local StructureUnit                 = DefaultUnitsFile.StructureUnit
local SubUnit                       = DefaultUnitsFile.SubUnit
local QuantumGateUnit               = DefaultUnitsFile.QuantumGateUnit
local RadarJammerUnit               = DefaultUnitsFile.RadarJammerUnit
local TransportBeaconUnit           = DefaultUnitsFile.TransportBeaconUnit
local WalkingLandUnit               = DefaultUnitsFile.WalkingLandUnit

DefaultUnitsFile = nil

local ConstructionUnitOnCreate      = ConstructionUnit.OnCreate
local EnergyCreationUnitOnCreate    = EnergyCreationUnit.OnCreate
local MobileUnitOnCreate            = MobileUnit.OnCreate

local FactoryUnitOnStartBuild       = FactoryUnit.OnStartBuild


local DefaultBeamWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultBeamWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

local CreateSeraphimFactoryBuildingEffects = EffectUtil.CreateSeraphimFactoryBuildingEffects
local CreateSeraphimUnitEngineerBuildingEffects = EffectUtil.CreateSeraphimUnitEngineerBuildingEffects

local ChangeState = ChangeState
local CreateAttachedEmitter = CreateAttachedEmitter
local CreateEmitterAtBone = CreateEmitterAtBone
local AttachBeamEntityToEntity = AttachBeamEntityToEntity
local EntityCategoryContains = EntityCategoryContains

local LOUDGETN = table.getn
local LOUDINSERT = table.insert

local VectorCached = { 0, 0, 0 }

local WaitSeconds = WaitSeconds
local WaitTicks = coroutine.yield

local ForkThread = ForkThread

local TrashBag = TrashBag
local TrashAdd = TrashBag.Add


SAirFactoryUnit = Class(FactoryUnit) {

    StartBuildFx = function( self, unitBeingBuilt )
    
		local BuildBones = __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones
        
        local thread = self:ForkThread( CreateSeraphimFactoryBuildingEffects, unitBeingBuilt, BuildBones, 'Attachpoint', self.BuildEffectsBag )
        
        TrashAdd( unitBeingBuilt.Trash, thread )
    end,

    CreateRollOffEffects = function(self)
	
        local army = self.Army
        local unitB = self.UnitBeingBuilt
		
        if not self.ReleaseEffectsBag then self.ReleaseEffectsBag = {} end
		
        for k, v in self.RollOffBones do
        
            local fx = AttachBeamEntityToEntity(self, v, unitB, -1, army, EffectTemplate.TTransportBeam01)
            
            LOUDINSERT( self.ReleaseEffectsBag, fx)
            TrashAdd( self.Trash, fx )
            
            fx = AttachBeamEntityToEntity( unitB, -1, self, v, army, EffectTemplate.TTransportBeam02)
            
            LOUDINSERT( self.ReleaseEffectsBag, fx)
            TrashAdd( self.Trash, fx )
            
            fx = CreateEmitterAtBone( self, v, army, EffectTemplate.TTransportGlow01)
            
            LOUDINSERT( self.ReleaseEffectsBag, fx)
            TrashAdd( self.Trash, fx )
        end
    end,

    DestroyRollOffEffects = function(self)
        for k, v in self.ReleaseEffectsBag do
            v:Destroy()
        end
        self.ReleaseEffectsBag = {}
    end,

    RollOffUnit = function(self)
    
        if EntityCategoryContains( categories.AIR, self.UnitBeingBuilt ) then
        
            local vec = VectorCached
            local spin
		
            spin, vec[1], vec[2], vec[3] = self:CalculateRollOffPoint()
			
            self.MoveCommand = IssueMove( {self.UnitBeingBuilt}, Vector(x, y, z))
        end
        
    end,

    RolloffBody = function(self)
	
        self:SetBusy(true)
		
        local unitBuilding = self.UnitBeingBuilt
        
        -- If the unit being built isn't an engineer use normal rolloff
        if not EntityCategoryContains( categories.LAND, unitBuilding ) then
		
            FactoryUnit.RolloffBody(self)
			
        else
		
            -- Engineers need to be slid off the factory
            local bp = __blueprints[self.BlueprintID]
			
            if not self.AttachmentSliderManip then
                self.AttachmentSliderManip = CreateSlider(self, bp.Display.BuildAttachBone or 0)
				TrashAdd( self.Trash, self.AttachmentSliderManip )
            end
			
            self:CreateRollOffEffects()
            self.AttachmentSliderManip:SetSpeed(30)
            self.AttachmentSliderManip:SetGoal(0, 0, 60)
            WaitFor( self.AttachmentSliderManip )
            self.AttachmentSliderManip:SetGoal(0, -55, 60)
            WaitFor( self.AttachmentSliderManip )
			
            if not unitBuilding.Dead then
                unitBuilding:DetachFrom(true)
                self:DetachAll(bp.Display.BuildAttachBone or 0)
                --local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -15})
                --IssueMoveOffFactory({unitBuilding}, worldPos)
            end
			
            if self.AttachmentSliderManip then
                self.AttachmentSliderManip:Destroy()
                self.AttachmentSliderManip = nil
            end
			
            self:DestroyRollOffEffects()
            self:SetBusy(false)
            
            ChangeState(self, self.IdleState)
			
        end
		
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order )
        -- Set goal for rotator
        local unitid = __blueprints[self.BlueprintID].General.UpgradesTo
		
        if unitBeingBuilt.BlueprintID == unitid and order == 'Upgrade' then
            --stop pods that exist in the upgraded unit
            local savedAngle
			
            if (self.Rotator1) then
                savedAngle = self.Rotator1:GetCurrentAngle()
                self.Rotator1:SetGoal(savedAngle)
                unitBeingBuilt.Rotator1:SetCurrentAngle(savedAngle)
                unitBeingBuilt.Rotator1:SetGoal(savedAngle)
                #-- freeze the next rotator to 0, since that's where it will be
                unitBeingBuilt.Rotator2:SetCurrentAngle(0)
                unitBeingBuilt.Rotator2:SetGoal(0)
            end
            
            if (self.Rotator2) then
                savedAngle = self.Rotator2:GetCurrentAngle()
                self.Rotator2:SetGoal(savedAngle)
                unitBeingBuilt.Rotator2:SetCurrentAngle(savedAngle)
                unitBeingBuilt.Rotator2:SetGoal(savedAngle)
                unitBeingBuilt.Rotator3:SetCurrentAngle(0)
                unitBeingBuilt.Rotator3:SetGoal(0)
            end
        end
        
        FactoryUnitOnStartBuild(self,unitBeingBuilt,order)
    end,
  
    UpgradingState = State(FactoryUnit.UpgradingState) {
	
        OnStopBuild = function(self, unitBuilding)
		
            if unitBuilding:GetFractionComplete() == 1 then
			
                --start halted rotators on upgraded unit
                if (unitBuilding.Rotator1) then
                    unitBuilding.Rotator1:ClearGoal()
                end
				
                if (unitBuilding.Rotator2) then
                    unitBuilding.Rotator2:ClearGoal()
                end
				
                if (unitBuilding.Rotator3) then
                    unitBuilding.Rotator3:ClearGoal()
                end
				
            end
			
            FactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding)
        end,

        OnFailedToBuild = function(self)
		
           FactoryUnit.UpgradingState.OnFailedToBuild(self)
		   
           -- failed to build, so resume rotators
			if (self.Rotator1) then
				self.Rotator1:ClearGoal()
				self.Rotator1:SetSpeed(5)
			end
           
            if (self.Rotator2) then
				self.Rotator2:ClearGoal()
				self.Rotator2:SetSpeed(5)
			end
			
        end,
		
    },
	
}

SLandFactoryUnit = Class(FactoryUnit) {

    StartBuildFx = function( self, unitBeingBuilt )
    
		local BuildBones = __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones
        
        local thread = self:ForkThread( CreateSeraphimFactoryBuildingEffects, unitBeingBuilt, BuildBones, 'Attachpoint', self.BuildEffectsBag )
        
        TrashAdd( unitBeingBuilt.Trash, thread )
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order )

        local unitid = __blueprints[self.BlueprintID].General.UpgradesTo
		
        if order == 'Upgrade' then
        
            if unitBeingBuilt.BlueprintID == unitid then
        
                -- stop pods that exist in the upgraded unit
                local savedAngle
            
                if (self.Rotator1) then
                    savedAngle = self.Rotator1:GetCurrentAngle()
                    self.Rotator1:SetGoal(savedAngle)
                    unitBeingBuilt.Rotator1:SetCurrentAngle(savedAngle)
                    unitBeingBuilt.Rotator1:SetGoal(savedAngle)
                    
                    -- freeze the next rotator to 0, since that's where it will be
                    unitBeingBuilt.Rotator2:SetCurrentAngle(0)
                    unitBeingBuilt.Rotator2:SetGoal(0)
                end
            
                if (self.Rotator2) then
                    savedAngle = self.Rotator2:GetCurrentAngle()
                    self.Rotator2:SetGoal(savedAngle)
                    unitBeingBuilt.Rotator2:SetCurrentAngle(savedAngle)
                    unitBeingBuilt.Rotator2:SetGoal(savedAngle)
                    unitBeingBuilt.Rotator3:SetCurrentAngle(0)
                    unitBeingBuilt.Rotator3:SetGoal(0)
                end
            end
        end
        
        FactoryUnitOnStartBuild(self,unitBeingBuilt,order)
    end,
  
    UpgradingState = State(FactoryUnit.UpgradingState) {
	
        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                if (unitBuilding.Rotator1) then
                    unitBuilding.Rotator1:ClearGoal()
                end
                if (unitBuilding.Rotator2) then
                    unitBuilding.Rotator2:ClearGoal()
                end
                if (unitBuilding.Rotator3) then
                    unitBuilding.Rotator3:ClearGoal()
                end                  
            end
            FactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding)
        end,

        OnFailedToBuild = function(self)
           FactoryUnit.UpgradingState.OnFailedToBuild(self)
           if (self.Rotator1) then
               self.Rotator1:ClearGoal()
               self.Rotator1:SetSpeed(5)
           end
           
            if (self.Rotator2) then
               self.Rotator2:ClearGoal()
               self.Rotator2:SetSpeed(5)
           end
        end,
    },  
    
}

SSeaFactoryUnit = Class(FactoryUnit) {

    StartBuildFx = function( self, unitBeingBuilt )
    
		local BuildBones = __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones
        
        local thread = self:ForkThread( CreateSeraphimFactoryBuildingEffects, unitBeingBuilt, BuildBones, 'Attachpoint', self.BuildEffectsBag )
        
        TrashAdd( unitBeingBuilt.Trash, thread )
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )

        local unitid = __blueprints[self.BlueprintID].General.UpgradesTo
		
        if unitBeingBuilt.BlueprintID == unitid and order == 'Upgrade' then
            -- stop pods that exist in the upgraded unit
            local savedAngle
            if (self.Rotator1) then
                savedAngle = self.Rotator1:GetCurrentAngle()
                self.Rotator1:SetGoal(savedAngle)
                unitBeingBuilt.Rotator1:SetCurrentAngle(savedAngle)
                unitBeingBuilt.Rotator1:SetGoal(savedAngle)
                -- freeze the next rotator to 0, since that's where it will be
                unitBeingBuilt.Rotator2:SetCurrentAngle(0)
                unitBeingBuilt.Rotator2:SetGoal(0)
            end
            
            if (self.Rotator2) then
                savedAngle = self.Rotator2:GetCurrentAngle()
                self.Rotator2:SetGoal(savedAngle)
                unitBeingBuilt.Rotator2:SetCurrentAngle(savedAngle)
                unitBeingBuilt.Rotator2:SetGoal(savedAngle)
                unitBeingBuilt.Rotator3:SetCurrentAngle(0)
                unitBeingBuilt.Rotator3:SetGoal(0)
            end
        end
        
        FactoryUnitOnStartBuild(self,unitBeingBuilt,order)
    end,
  
    UpgradingState = State(FactoryUnit.UpgradingState) {   
	
        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                -- start halted rotators on upgraded unit
                if (unitBuilding.Rotator1) then
                    unitBuilding.Rotator1:ClearGoal()
                end
                if (unitBuilding.Rotator2) then
                    unitBuilding.Rotator2:ClearGoal()
                end
                if (unitBuilding.Rotator3) then
                    unitBuilding.Rotator3:ClearGoal()
                end                  
            end
            FactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding)
        end,

        OnFailedToBuild = function(self)
           FactoryUnit.UpgradingState.OnFailedToBuild(self)
           -- failed to build, so resume rotators
           if (self.Rotator1) then
               self.Rotator1:ClearGoal()
               self.Rotator1:SetSpeed(5)
           end
           
            if (self.Rotator2) then
               self.Rotator2:ClearGoal()
               self.Rotator2:SetSpeed(5)
           end
        end,
    },      
}

SConstructionUnit = Class(ConstructionUnit) {

    OnCreate = function(self)
    
        ConstructionUnitOnCreate(self)
        
        if self.BuildingOpenAnim then
            if self.BuildArm2Manipulator then
                self.BuildArm2Manipulator:Disable()
            end
        end
        
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
    
        CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, __blueprints[self.BlueprintID].General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,    

    OnStopBuild = function(self, unitBeingBuilt)
    
        if self.BuildEmitters then
            for _, emit in self.BuildEmitters do
                emit:ScaleEmitter( .01 )
            end
        end
        
        ConstructionUnit.OnStopBuild(self, unitBeingBuilt)
    end,
    
    SetupBuildBones = function(self)
    
        local bp = __blueprints[self.BlueprintID]
        
        ConstructionUnit.SetupBuildBones(self)
        
        local buildbones = bp.General.BuildBones
		
        if self.BuildArmManipulator then
            self.BuildArmManipulator:SetAimingArc(buildbones.YawMin or -180, buildbones.YawMax or 180, buildbones.YawSlew or 360, buildbones.PitchMin or -90, buildbones.PitchMax or 90, buildbones.PitchSlew or 360)
        end
		
        if bp.General.BuildBonesAlt1 then
            self.BuildArm2Manipulator = CreateBuilderArmController(self, bp.General.BuildBonesAlt1.YawBone or 0 , bp.General.BuildBonesAlt1.PitchBone or 0, bp.General.BuildBonesAlt1.AimBone or 0)
            self.BuildArm2Manipulator:SetAimingArc(bp.General.BuildBonesAlt1.YawMin or -180, bp.General.BuildBonesAlt1.YawMax or 180, bp.General.BuildBonesAlt1.YawSlew or 360, bp.General.BuildBonesAlt1.PitchMin or -90, bp.General.BuildBonesAlt1.PitchMax or 90, bp.General.BuildBonesAlt1.PitchSlew or 360)
            self.BuildArm2Manipulator:SetPrecedence(5)
            
            if self.BuildingOpenAnimManip and self.Build2ArmManipulator then
                self.BuildArm2Manipulator:Disable()
            end
            
            TrashAdd( self.Trash, self.BuildArm2Manipulator )
        end
    end,

    BuildManipulatorSetEnabled = function(self, enable)

        ConstructionUnit.BuildManipulatorSetEnabled(self, enable)
        
        if not self or self.Dead then return end
        
        if not self.BuildArm2Manipulator then return end

        if enable then
            self.BuildArm2Manipulator:Enable()
        else
            self.BuildArm2Manipulator:Disable()
        end
    end,
    
    WaitForBuildAnimation = function(self, enable)

        if self.BuildArmManipulator then
            
            WaitFor(self.BuildingOpenAnimManip)
            
            if (enable) then
                self:BuildManipulatorSetEnabled(enable)
            end
        end
    end,

    OnStopBuilderTracking = function(self)
    
        ConstructionUnit.OnStopBuilderTracking(self)
        
        if self.StoppedBuilding then
            self:BuildManipulatorSetEnabled(disable)
        end
    end,      
}

SEnergyCreationUnit = Class(EnergyCreationUnit) {

    OnCreate = function(self)
        EnergyCreationUnitOnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        EnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
		
        local army = self.Army
		
        if self.AmbientEffects then
            for k, v in EffectTemplate[self.AmbientEffects] do
                CreateAttachedEmitter(self, 0, army, v)
            end
        end
    end,
}

SMassCollectionUnit = Class(MassCollectionUnit) {}

SMassFabricationUnit = Class(MassFabricationUnit) {}

SMassStorageUnit = Class(StructureUnit) {}

SRadarUnit = Class(RadarUnit) {}

SSonarUnit = Class(SonarUnit) {}

SSeaUnit = Class(SeaUnit) {}

SShieldHoverLandUnit = Class(MobileUnit) {}

SShieldLandUnit = Class(MobileUnit) {}

SShieldStructureUnit = Class(ShieldStructureUnit) {

    OnShieldEnabled = function(self)
        ShieldStructureUnit.OnShieldEnabled(self)
        
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            
            TrashAdd( self.Trash, self.AnimationManipulator )
            
            self.AnimationManipulator:PlayAnim(__blueprints[self.BlueprintID].Display.AnimationActivate, false)
        end
        
        self.AnimationManipulator:SetRate(1)
    end,
    
    OnShieldDisabled = function(self)
        ShieldStructureUnit.OnShieldDisabled(self)
		if not self.AnimationManipulator then return end
		
        self.AnimationManipulator:SetRate(-1)
    end,
}

SStructureUnit = Class(StructureUnit) {}

SSubUnit = Class(SubUnit) {}

STransportBeaconUnit = Class(TransportBeaconUnit) {}

SWalkingLandUnit = Class(WalkingLandUnit) {}

SWallStructureUnit = Class(WallStructureUnit) {}

SCivilianStructureUnit = Class(StructureUnit) {}

SQuantumGateUnit = Class(QuantumGateUnit) {}

SRadarJammerUnit = Class(RadarJammerUnit) {}

SEnergyBallUnit = Class(MobileUnit) {
    timeAlive = 0,
    
    OnCreate = function(self)

        MobileUnitOnCreate(self)

        self:SetCanTakeDamage(false)
        self:SetCanBeKilled(false)
        self:PlayUnitSound('Spawn')

        ChangeState( self, self.KillingState )
    end,

    KillingState = State { 
	
        LifeThread = function(self)
            WaitTicks( __blueprints[self.BlueprintID].Lifetime * 10)
            ChangeState( self, self.DeathState )
        end,
        
        Main = function(self)
            local bp = __blueprints[self.BlueprintID]
            local aiBrain = self:GetAIBrain()
            
            --Queue up random moves
			local pos = self:GetPosition()
            local x = pos[1]
			local y = pos[2]
			local z = pos[3]
			
            for i=1, 100 do
                IssueMove({self}, {x + Random(-bp.MaxMoveRange, bp.MaxMoveRange), y, z + Random(-bp.MaxMoveRange, bp.MaxMoveRange)})
            end

            -- weapon information
            local weaponMaxRange = bp.Weapon[1].MaxRadius
            local weaponMinRange = bp.Weapon[1].MinRadius or 0
            local beamLifetime = bp.Weapon[1].BeamLifetime or 1
            
            local reaquireTime = bp.Weapon[1].RequireTime or 0.5
            
            local weapon = self:GetWeapon(1)

            self:ForkThread(self.LifeThread)

		    while true do
			
		        local location = self:GetPosition()
		        local targets = aiBrain:GetUnitsAroundPoint( categories.LAND - categories.UNTARGETABLE, location, weaponMaxRange )
		        local filteredUnits = {}
				
		        for k,v in targets do
		            if VDist3( location, v:GetPosition() ) >= weaponMinRange and v ~= self then
                        LOUDINSERT( filteredUnits, v )
                    end
                end
				
                local target = filteredUnits[Random(1, LOUDGETN(filteredUnits))]
				
                if target then
                    weapon:SetTargetEntity(target)
                else
                    weapon:SetTargetGround( { location[1] + Random(-20, 20), location[2], location[3] + Random(-20, 20) } )
                end
				
                -- Wait a tick to let the target update awesomely.
                WaitTicks(1)
                self.timeAlive = self.timeAlive + .1
                weapon:FireWeapon()

                WaitTicks( beamLifetime * 10)
                DefaultBeamWeapon.PlayFxBeamEnd(weapon,weapon.Beams[1].Beam)
                WaitTicks( reaquireTime * 10)
                --self:ComputeWaitTime()
		    end
		    -- ChangeState( self, self.DeathState )
        end,
        
        ComputeWaitTime = function(self)
            local timeLeft = __blueprints[self.BlueprintID].Lifetime - self.timeAlive
            
            local maxWait = 75
            if timeLeft < 7.5 and timeLeft > 2.5 then
                maxWait = timeLeft * 10
            end
            local waitTime = timeLeft
            if timeLeft > 2.5 then
                waitTime = Random(5,maxWait)
            end
            
            self.timeAlive = self.timeAlive + (waitTime * .1)
            WaitTicks( waitTime )
        end,
    },

    DeathState = State {
        Main = function(self)
            self:SetCanBeKilled(true)
            if self:GetCurrentLayer() == 'Water' then
                self:PlayUnitSound('HoverKilledOnWater')
            end            
            self:PlayUnitSound('Destroyed')
            self:Destroy()
        end,
    },
}
