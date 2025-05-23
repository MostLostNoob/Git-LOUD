--local EffectTemplate = import('/lua/EffectTemplates.lua')

local EmtBpPath = '/effects/emitters/'
local EmtBpPathAlt = '/mods/TotalMayhem/effects/emitters/'


AeonEnforcerMainGuns = {
    EmtBpPath .. 'aeon_bomber_hit_01_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_02_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_03_emit.bp',
    EmtBpPath .. 'aeon_bomber_hit_04_emit.bp',
    EmtBpPath .. 'phalanx_muzzle_glow_01_emit.bp',
}

AeonNocaCatBlueLaserHit = {
    EmtBpPath .. 'oblivion_cannon_hit_05_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_06_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_07_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_08_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_09_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_10_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_11_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_12_emit.bp',
    EmtBpPath .. 'oblivion_cannon_hit_13_emit.bp',
    EmtBpPath .. 'cybran_corsair_missile_hit_ring.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_03_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_05_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_06_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_07_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_08_emit.bp',
    EmtBpPath .. 'seraphim_khu_anti_nuke_hit_09_emit.bp',
	EmtBpPath .. 'seraphim_heavyquarnon_cannon_frontal_glow_01_emit.bp',
}

AeonT3HeavyRocketHit01 = {
    EmtBpPath .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_08_emit.bp',
    EmtBpPath .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPath .. 'antimatter_ring_02_emit.bp',	--	ring11
    EmtBpPath .. 'antimatter_hit_01_emit.bp',	--	glow	
    EmtBpPath .. 'antimatter_hit_02_emit.bp',	--	flash	     
    EmtBpPath .. 'antimatter_hit_03_emit.bp', 	--	sparks
    EmtBpPath .. 'napalm_hvy_flash_emit.bp',
    EmtBpPath .. 'napalm_hvy_thick_smoke_emit.bp',
    #EmtBpPath .. 'napalm_hvy_fire_emit.bp',
    EmtBpPath .. 'napalm_hvy_thin_smoke_emit.bp',
    EmtBpPath .. 'napalm_hvy_01_emit.bp',
    EmtBpPath .. 'napalm_hvy_02_emit.bp',
    EmtBpPath .. 'napalm_hvy_03_emit.bp',
}

AeonT3EMPburst = {
    EmtBpPath .. 'shockwave_01_emit.bp',  
    EmtBpPath .. 'proton_bomb_hit_02_emit.bp',
}

CybranRocketTrail = {
	EmtBpPath .. 'electron_bolter_trail_02_emit.bp',
	EmtBpPath .. 'disintegrator_polytrail_05_emit.bp', -- White trail
}

CybranRocketTrailOffset = {0,0,0}

CybranRocketFXTrail = import('/lua/EffectTemplates.lua').CDisintegratorFxTrails01

CybranHeavyRocketTrail = {
	EmtBpPath .. 'electron_bolter_trail_02_emit.bp',
	EmtBpPath .. 'disintegrator_polytrail_04_emit.bp' -- purple trail
}

CybranRocketHeavyTrailOffset = {0, 0}

CybranHeavyRocketFXTrail = { EmtBpPath .. 'electron_bolter_munition_01_emit.bp' }

CybranHeavyRocketHit = {
	EmtBpPathAlt .. 'cybranheavyrocket_hit_01_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_02_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_05_emit.bp',
	EmtBpPathAlt .. 'cybranheavyrocket_hit_distort_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05a_emit.bp', -- Red glow,
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', -- Red glow explosion with smoke,
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', -- black dots on ground
	EmtBpPathAlt .. 'bm2rockethit_06_emit.bp', -- ring
}

CybranRocketHit = {
	EmtBpPathAlt .. 'bm2rockethit_01_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_02_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_03_emit.bp',
	EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'tm_kamibomb_hit_05_emit.bp', -- Red glow,
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', -- Red glow explosion with smoke
}

CYBRANHEAVYPROTONARTILLERYHIT01 = {
	EmtBpPath .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_09_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPath .. 'dust_cloud_06_emit.bp',
    EmtBpPath .. 'dirtchunks_01_emit.bp',
    EmtBpPath .. 'molecular_resonance_cannon_ring_02_emit.bp',
}

CybranT1BattleTankHit = {
	EmtBpPath .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPath .. 'hvyproton_cannon_hit_03_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_04_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_05_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_07_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_09_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_10_emit.bp',
    EmtBpPath .. 'hvyproton_cannon_hit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank3_emit.bp',
    EmtBpPathAlt .. 'tmcybrant1battletank2_emit.bp',
}

CybranT2BattleTankHit = {
    EmtBpPathAlt .. 'tmcybrant2battletankhit_distort_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', -- Exploding flames
	EmtBpPathAlt .. 'tmcybrant2battletankhit_02_emit.bp', -- Red glow
	EmtBpPathAlt .. 'tmcybrant2battletankhit_03_emit.bp', -- white sparks flying opposite direction of impact
	EmtBpPathAlt .. 'tmcybrant2battletankhit_04_emit.bp', -- dirt flying
	EmtBpPathAlt .. 'tmcybrant2battletankhit_06_emit.bp', -- white glow in middle
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', -- black dots on ground
	EmtBpPathAlt .. 'tmcybrant2battletankhit_08_emit.bp', -- white exploding glow in middle
}

CybranT3BattleTankHit = {
	EmtBpPathAlt .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', -- black dots on ground
}

Beetleprojectilehit01 = {
	EmtBpPathAlt .. 'hvyproton_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'hvyproton_cannon_hit_10_emit.bp',

	EmtBpPathAlt .. 'tm_kamibomb_hit_05a_emit.bp', -- Red glow,
	EmtBpPathAlt .. 'bm2rockethit_09_emit.bp', -- Red glow explosion with smoke,
	EmtBpPathAlt .. 'tmcybrant2battletankhit_07_emit.bp', -- black dots on ground
	EmtBpPathAlt .. 'tmcybrant2battletankhit_03_emit.bp', -- white sparks flying opposite direction of impact
	EmtBpPathAlt .. 'tmcybrant3battletankhit_distort_emit.bp',
	EmtBpPathAlt .. 'bm2rockethit_07_emit.bp', -- Ring effect
	EmtBpPathAlt .. 'bm2rockethit_08_emit.bp', -- Yellow Afterglow
}

UEFArmoredBattleBotTrails = {
	EmtBpPath .. 'seraphim_tau_cannon_projectile_01_emit.bp',
	EmtBpPath .. 'seraphim_tau_cannon_projectile_02_emit.bp',	
}

UEFArmoredBattleBotPolyTrails = {
	EmtBpPath .. 'seraphim_tau_cannon_projectile_polytrail_01_emit.bp',
    EmtBpPath .. 'seraphim_heavyquarnon_cannon_projectile_trail_02_emit.bp',
}

UEFArmoredBattleBotHit = {
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_tau_cannon_projectile_hit_03_flat_emit.bp',
}

UEFHEAVYROCKET02 = {
    EmtBpPathAlt .. 'quantum_hit_flash_01_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_02_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_03_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_04_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_05_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_06_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_07_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_09_emit.bp',
    EmtBpPathAlt .. 'quantum_hit_flash_08_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02b_emit.bp',
}

UEFHeavyMechHit01 = {
	EmtBpPathAlt .. 'uefepd_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_05_emit.bp',

	EmtBpPathAlt .. 'uefepd_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_08_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_11_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_12_emit.bp',
	EmtBpPath .. 'seraphim_expnuke_prelaunch_09_emit.bp',	-- blueish glow
}

UefT2EPDPlasmaHit01 = {
	EmtBpPathAlt .. 'uefepd_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_06_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_07_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_08_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_09_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_10_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_11_emit.bp',
	EmtBpPathAlt .. 'uefepd_cannon_hit_12_emit.bp',
}

UEFHighExplosiveShellHit01 = {
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_02_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'uefexmgauss_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'uefexm_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'uefexm_cannon_hit_02_emit.bp',
}

UefT1MedTankHit = {
	EmtBpPathAlt .. 'landgauss_cannon_hit_01_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_05_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_01_emit.bp',
}

UefT3BattletankHit = {
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
    EmtBpPathAlt .. 'tmcybrant2battletankhit_01_emit.bp', -- Exploding flames
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01_emit.bp',
}

UefT3BattletankRocketHit = {
	EmtBpPathAlt .. 'gauss_cannon_hit_01a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'gauss_cannon_hit_02b_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_02a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_03a_emit.bp',
	EmtBpPathAlt .. 'landgauss_cannon_hit_04a_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_01_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_02_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_03_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_04_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_05_emit.bp',
	EmtBpPathAlt .. 'ueft3rocket_06_emit.bp',
}

