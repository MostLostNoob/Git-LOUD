local TSeaUnit =  import('/lua/defaultunits.lua').SeaUnit

local TAALinkedRailgun      = import('/lua/terranweapons.lua').TAALinkedRailgun
local TDFGaussCannonWeapon  = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDepthCharge          = import('/lua/aeonweapons.lua').AANDepthChargeBombWeapon

UES0103 = Class(TSeaUnit) {

    Weapons = {
	
        MainGun     = Class(TDFGaussCannonWeapon) { FxMuzzleFlashScale = 0.5 },
        AAGun       = Class(TAALinkedRailgun) {},
        DepthCharge = Class(TDepthCharge) {
        
            OnLostTarget = function(self)
                
                self.unit:SetAccMult(1)
                
                self:ChangeMaxRadius(12)
                
                TDepthCharge.OnLostTarget(self)
            
            end,
        
            RackSalvoFireReadyState = State( TDepthCharge.RackSalvoFireReadyState) {
            
                Main = function(self)
                
                    self:ChangeMaxRadius(6)
                
                    TDepthCharge.RackSalvoFireReadyState.Main(self)
                    
                end,
            },
        
            RackSalvoReloadState = State( TDepthCharge.RackSalvoReloadState) {
            
                Main = function(self)
                
                    self.unit:SetAccMult(1.3)
                
                    self:ForkThread( function() self:ChangeMaxRadius(15) self:ChangeMinRadius(15) WaitTicks(44) self:ChangeMinRadius(0) self:ChangeMaxRadius(12) end)
                    
                    TDepthCharge.RackSalvoReloadState.Main(self)

                end,
            },        
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
	
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
		
        self.Trash:Add(CreateRotator(self, 'Spinner01', 'y', nil, 360, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Spinner02', 'y', nil, 90, 0, 180))
        self.Trash:Add(CreateRotator(self, 'Spinner03', 'y', nil, -180, 0, -180))
    end,
}

TypeClass = UES0103