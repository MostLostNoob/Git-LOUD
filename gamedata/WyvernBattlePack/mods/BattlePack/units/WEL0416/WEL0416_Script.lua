local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit

local TerranWeaponFile = import('/lua/terranweapons.lua')
local BattlePackWeaponFile      = import('/mods/BattlePack/lua/BattlePackweapons.lua')

local EffectUtil    = import('/lua/EffectUtilities.lua')

local utilities     = import('/lua/Utilities.lua')
local RandomFloat   = utilities.GetRandomFloat

local EffectTemplate = import('/lua/EffectTemplates.lua')
local explosion     = import('/lua/defaultexplosions.lua')

local CreateBuildCubeThread = EffectUtil.CreateBuildCubeThread
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

local Riot  = TerranWeaponFile.TDFRiotWeapon
local Beam  = import('/lua/sim/defaultweapons.lua').DefaultBeamWeapon
local Hiro  = TerranWeaponFile.TDFHiroPlasmaCannon
local SAM   = TerranWeaponFile.TSAMLauncher
local Gauss = TerranWeaponFile.TDFLandGaussCannonWeapon
local PPC   = BattlePackWeaponFile.PlasmaPPC

explosion = nil
TerranWeaponFile = nil
BattlePackWeaponFile = nil 

local MissileRedirect = import('/lua/defaultantiprojectile.lua').MissileTorpDestroy

local TrashBag = TrashBag
local TrashAdd = TrashBag.Add
local TrashDestroy = TrashBag.Destroy

WEL0416 = Class(TWalkingLandUnit) {

    Weapons = {
    
		EXTargetPainter = Class(Beam) {},
        
		HeadWeapon      = Class(Beam) {
        
            OnWeaponFired = function(self, muzzle)
            
                if not self.JawTopRotator then 
                    self.JawBottomRotator = CreateRotator(self.unit, 'Jaw_Bone', 'x')
                    
                    self.unit.Trash:Add(self.JawBottomRotator)
                end
                
                self.JawBottomRotator:SetGoal(30):SetSpeed(100)
                
                Beam.OnWeaponFired(self, muzzle)
                
                self:ForkThread(function()
                    WaitSeconds(1.5)
                    
                    self.JawBottomRotator:SetGoal(0):SetSpeed(50)
                end)
            end,
        },
        
		Arm             = Class(PPC) { FxMuzzleFlashScale = 0.5 },  

		ChinGun         = Class(Riot) { FxMuzzleFlashScale = 0.5, PlayOnlyOneSoundCue = true },
        
		CheekGun        = Class(Hiro) { FxMuzzleFlashScale = 0.8, PlayOnlyOneSoundCue = true },
        
		Missiles        = Class(SAM) {}, 
        
		ShoulderTurret  = Class(Gauss) { FxMuzzleFlashScale = 0.25 },
        
		AA              = Class(SAM) {},
    },
	
	OnCreate = function(self,builder,layer)
    
        TWalkingLandUnit.OnCreate(self)

    end,
	
	StartBeingBuiltEffects = function(self, builder, layer)
    
		TWalkingLandUnit.StartBeingBuiltEffects(self, builder, layer)
        
		self.OnBeingBuiltEffectsBag:Add( self:ForkThread( CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag )	)			
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
    
		TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)

        -- create Anti-Torp/TMD emitters
        local bp = __blueprints[self.BlueprintID].Defense.MissileTorpDestroy
        
        for _,v in bp.AttachBone do

            local antiMissile1 = MissileRedirect { Owner = self, Radius = bp.Radius, AttachBone = v, RedirectRateOfFire = bp.RedirectRateOfFire }

            TrashAdd( self.Trash, antiMissile1)
            
        end        

        self.Rotator1 = CreateRotator(self, 'Jaw_Bone', 'x')
        self.Rotator2 = CreateRotator(self, 'Head', 'x')
        self.Rotator3 = CreateRotator(self, 'Head', 'y')
		self.Rotator4 = CreateRotator(self, 'NewTorso', 'x')
        self.Rotator5 = CreateRotator(self, 'Right_Cannon', 'x')
        self.Rotator6 = CreateRotator(self, 'Left_Cannon', 'x')
		self.Rotator7 = CreateRotator(self, 'Right_Cannon', 'y')
        self.Rotator8 = CreateRotator(self, 'Left_Cannon', 'y')

        self.Trash:Add(self.Rotator1)
		self.Trash:Add(self.Rotator2)
		self.Trash:Add(self.Rotator3)
		self.Trash:Add(self.Rotator4)
		self.Trash:Add(self.Rotator5)
		self.Trash:Add(self.Rotator6)
		
		if self.Rotator4 then
            self.Rotator4:SetGoal(-30):SetSpeed(50)
        end
        
        self:ForkThread(function()

        	WaitSeconds(1)
        	self.Rotator4:SetGoal(0):SetSpeed(25)
        end)
        
		if self.Rotator5 then
            self.Rotator5:SetGoal(30):SetSpeed(50)
        end
        
		if self.Rotator7 then
            self.Rotator7:SetGoal(30):SetSpeed(50)
        end
        
        self:ForkThread(function()
        	WaitSeconds(1)
            self.Rotator5:SetGoal(0):SetSpeed(25)        
        	self.Rotator7:SetGoal(0):SetSpeed(25)
        end)
        
		if self.Rotator6 then
            self.Rotator6:SetGoal(30):SetSpeed(50)
        end
        
		if self.Rotator8 then
            self.Rotator8:SetGoal(-30):SetSpeed(50)
        end
        
        self:ForkThread(function()
        	WaitSeconds(1)
            self.Rotator6:SetGoal(0):SetSpeed(25)			
        	self.Rotator8:SetGoal(0):SetSpeed(25)
        end)
		
		
        if self.Rotator1 then
            self.Rotator1:SetGoal(30):SetSpeed(100)
        end
        
        self:ForkThread(function()

        	WaitSeconds(1)
        	self.Rotator1:SetGoal(0):SetSpeed(50)
        end)
        
        if self.Rotator2 then
            self.Rotator2:SetGoal(-40):SetSpeed(100)
        end
        
        self:ForkThread(function()

        	WaitSeconds(1)
        	self.Rotator2:SetGoal(0):SetSpeed(50)
        end)
        
        if self.Rotator3 then
            self.Rotator3:SetGoal(-20):SetSpeed(100)
        end
        
        self:ForkThread(function()

        	WaitSeconds(1)
        	self.Rotator3:SetGoal(20):SetSpeed(100)
        	WaitSeconds(1)
        	self.Rotator3:SetGoal(0):SetSpeed(100)
        end)        
    end,
	
	DestroyOnKilled = false,

    -- Just tosses parts everywhere
    DestructionPartsHighToss = {
        'Left_MissileRack','Right_MissileRack','Left_Gauss_TurretYaw','Right_Gauss_TurretYaw','Right_Gauss_TurretPitch','Left_Gauss_TurretPitch','Right_PlasmaGun',
        'Left_PlasmaGun',
    },
    
    DestructionPartsLowToss = {
        'Left_AAYaw','Right_AAYaw','Left_Cannon','Right_Cannon','Right_Cannont_Recoil',
		'Left_Cannon_Recoil','ChinGun_Pitch','Left_ChinGun','Right_ChinGun',
		'KneeGuard_Right','KneeGuard_Left','Leg_Addon001_Left','Leg_Addon002_Right','Head',
    },

    MechDestructionEffectBones = {
        'Left_MissileMuzzle001','Left_MissileMuzzle007','Right_MissileMuzzle004','Right_MissileMuzzle006',
		'Left_AATurret_Muzzle001','Right_AATurret_Muzzle001','Left_AAYaw','Right_AAYaw',
        'Left_Cannon','Right_Cannon','Left_MissileRack','Right_MissileRack',
		'Left_ChinGun','Right_ChinGun','ChinGun_Pitch','Leg_Addon002_Right','Head',
		'Right_Gauss_TurretPitch','Left_Gauss_TurretPitch','Right_PlasmaGun','Left_PlasmaGun',
    },

    OnKilled = function(self, inst, type, okr)
    
        self.Trash:Destroy()
        self.Trash = TrashBag()
        
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
        end
        
        TWalkingLandUnit.OnKilled(self, inst, type, okr)
    end,

    CreateDamageEffects = function(self, bone )
    
        for k, v in EffectTemplate.TNapalmCarpetBombHitLand01 do  
            CreateAttachedEmitter( self, bone, self.Army, v ):ScaleEmitter(0.3)
        end
    end,

    CreateExplosionDebris = function( self )
    
        for k, v in EffectTemplate.ExplosionEffectsSml01 do
            CreateAttachedEmitter( self, 'NewTorso', self.Army, v )
        end
    end,

    CreateFirePlumes = function( self, Army, bones, yBoneOffset )
    
        local proj, position, offset, velocity
        local basePosition = self:GetPosition()
        
        for k, vBone in bones do
        
            position = self:GetPosition(vBone)
            offset = utilities.GetDifferenceVector( position, basePosition )
            
            velocity = utilities.GetDirectionVector( position, basePosition )  
            
            velocity[1] = velocity[1] + utilities.GetRandomFloat(-0.45, 0.45)
            velocity[2] = velocity[2] + utilities.GetRandomFloat(-0.45, 0.45)
            velocity[3] = velocity[3] + utilities.GetRandomFloat( 0.0, 0.45)
            
            proj = self:CreateProjectile('/effects/entities/DestructionFirePlume01/DestructionFirePlume01_proj.bp', offset.x, offset.y + yBoneOffset, offset.z, velocity[1], velocity[2], velocity[3])
            proj:SetBallisticAcceleration(utilities.GetRandomFloat(-1, -2)):SetVelocity(utilities.GetRandomFloat(1, 4)):SetCollision(false)            
            
            local emitter = CreateEmitterOnEntity(proj, self.Army, '/effects/emitters/destruction_explosion_fire_plume_01_emit.bp')
            local lifetime = utilities.GetRandomFloat( 10, 20 )
        end
    end,

    InitialRandomExplosions = function(self)
    
        local position = self:GetPosition()
        local numExplosions = math.floor( table.getn( self.MechDestructionEffectBones ) * 0.3 )

        -- Create small explosions all over
        for i = 0, numExplosions do
        
            local ranBone = utilities.GetRandomInt( 1, numExplosions )
            local duration = utilities.GetRandomFloat( 0.2, 0.5 )
            
            self:PlayUnitSound('Destroyed')
            CreateDeathExplosion( self, self.MechDestructionEffectBones[ ranBone ], Random(0.125,0.5) )
            self:CreateFirePlumes( self.Army, {ranBone}, Random(0,2) )
            self:CreateDamageEffects( ranBone, self.Army )
            self:CreateExplosionDebris( self.Army )
            self:ShakeCamera(1, 0.5, 0.25, duration)
            WaitSeconds( duration )
        end

        -- Create main body explosions
        CreateDeathExplosion( self, 'Left_MissileRack', Random(1,5))
        self:CreateDamageEffects( 'Left_MissileRack', self.Army )
        self:ShakeCamera(2, 1, 0.5, 0.5)
        self:PlayUnitSound('Destroyed')  
        CreateDeathExplosion( self, 'Right_MissileRack', Random(1,5))
        self:CreateDamageEffects( 'Right_MissileRack', self.Army )
        self:ShakeCamera(2, 1, 0.5, 0.5)
        self:PlayUnitSound('Destroyed')
        WaitSeconds( 0.5 )
        CreateDeathExplosion( self, 'Body', Random(1,10))
        self:CreateDamageEffects( 'Body', self.Army )
        self:ShakeCamera(4, 2, 1, 1)
        self:PlayUnitSound('Destroyed')
    end,

    NukeExplosion = function(self)
    
        local position = self:GetPosition()

        -- Create full-screen glow flash
        self:PlayUnitSound('Nuke')
        CreateAttachedEmitter(self, 'NewTorso', self.Army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp'):ScaleEmitter(0.2)
        self:ForkThread(self.CreateOuterRingWaveSmokeRing)
        CreateLightParticle(self, -1, self.Army, 10, 4, 'glow_02', 'ramp_red_02')
        WaitSeconds( 0.25 )
        CreateLightParticle(self, -1, self.Army, 10, 20, 'glow_03', 'ramp_fire_06')
        WaitSeconds( 0.55 )        
        CreateLightParticle(self, -1, self.Army, 20, 250, 'glow_03', 'ramp_nuke_04')
      
        -- Create ground decals
        local orientation = RandomFloat( 0, 6.28 )
        CreateDecal(position, orientation, 'Crater01_albedo', '', 'Albedo', 8, 8, 400, 120, self.Army)
        CreateDecal(position, orientation, 'Crater01_normals', '', 'Normals', 8, 8, 400, 120, self.Army)      
        CreateDecal(position, orientation, 'nuke_scorch_003_albedo', '', 'Albedo', 12, 12, 400, 120, self.Army)
   
        -- Knockdown force rings
        DamageRing(self, position, 0.1, 20, 1, 'Force', false)
        WaitSeconds(0.1)

        -- Nuke damage and camera shake
        DamageRing(self, position, 0.1, 9, 1000, 'Force', true)
		DamageRing(self, position, 0.1, 6, 2000, 'Force', true)
		DamageRing(self, position, 0.1, 3, 3000, 'Force', true)
        self:ShakeCamera(6, 3, 2, 2)  
    end,

    CreateOuterRingWaveSmokeRing = function(self)
    
        local sides = 24
        local angle = 6.28 / sides
        local velocity = 1.2
        local OffsetMod = 4
        local projectiles = {}
        
        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/SCUDeathShockwave01/SCUDeathShockwave01_proj.bp', X * OffsetMod , 2, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert( projectiles, proj )
        end       
        
        WaitSeconds( 3 )
        
        -- Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end        
    end,


    DeathThread = function(self)

        self:InitialRandomExplosions()       

        self:NukeExplosion()   

        self:HideBone('NewTorso', true)
        self:CreateWreckage(Random(0.1,1))
        self:Destroy()
    end,
	
}
	
TypeClass = WEL0416