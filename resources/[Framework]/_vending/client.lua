local Proxy = module('_core', 'libs/Proxy')
local Tunnel = module('_core', 'libs/Tunnel')

cAPI = Proxy.getInterface('cAPI')
API = Tunnel.getInterface('API')

local dictionary = "mini@sprunk"
local thirst = -2.5
local boneIndex
local TempCan = nil
local CanModel
local method = 0
local machine
local position
local props = {
    "prop_vend_coffe_01", 
    "prop_vend_soda_01", 
    "prop_vend_soda_02"
}

function _StartMachine(machine)
    RequestScriptAudioBank("VENDING_MACHINE", false)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
    boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)
    TaskLookAtEntity(PlayerPedId(), machine, 2000, 2048, 2)
    TaskGoStraightToCoord(PlayerPedId(), position.x, position.y, position.z, 1.0, 4000, GetEntityHeading(machine), 0.5)
    method = 2
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        if method == 0 then
            position = GetEntityCoords(PlayerPedId())
            for k,v in pairs(props) do
                machine = GetClosestObjectOfType(position.x,position.y,position.z, 1.0, GetHashKey(props[k]), true)
            end
        end
    end
end)    


local idle = 2000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(idle)
        if machine ~= 0 and method == 0 then
            idle = 1
            position = GetOffsetFromEntityInWorldCoords(machine, 0.0, -0.97, 0.0)
            if GetEntityModel(machine) == GetHashKey("prop_vend_soda_01") then
                CanModel = GetHashKey("prop_ecola_can")
            elseif GetEntityModel(machine) == GetHashKey("prop_vend_soda_02") then
                CanModel = GetHashKey("prop_ld_can_01b") 
            end
            ShowMessage("VENDHLP", 2000);
            if IsControlJustPressed(1,38) then
                if API.removeMoney(GetPlayerServerId(PlayerId()), 1) then
                    _StartMachine(machine)
                end
            end
        else
            idle = 2000
        end
        if method == 2 then
            if GetScriptTaskStatus(PlayerPedId(), 0x7D8F4411) == 7 then
                if TempCan == nil then
                    if cAPI.LoadModel(CanModel) then
                        TempCan = CreateObject(CanModel, GetEntityCoords(machine), false, false, false)
                        SetPlayerControl(PlayerPedId(), false, 256)
                        cAPI.playAnim(dictionary, "PLYR_BUY_DRINK_PT1", 2.0)
                        if GetEntityAnimCurrentTime(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT1") < 0.52 then
                            AttachEntityToEntity(TempCan, PlayerPedId(), boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                            method = 3
                        end
                    end
                end
            end
        elseif method == 3 then
            if IsEntityPlayingAnim(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT1", 3) then
                if GetEntityAnimCurrentTime(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT1") > 0.985 then
                    cAPI.playAnim(dictionary, "PLYR_BUY_DRINK_PT2", 2.0)
                    N_0x2208438012482a1a(PlayerPedId(), 0, 0)
                    HintAmbientAudioBank("VENDING_MACHINE", 0)
                    method = 4;
                end
            end
        elseif method == 4 then
            if IsEntityPlayingAnim(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT2", 3) then
                if GetEntityAnimCurrentTime(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT2") > 0.98 then
                    cAPI.playAnim(dictionary, "PLYR_BUY_DRINK_PT3", 2.0)
                    N_0x2208438012482a1a(PlayerPedId(), 0, 0)
                    method = 5;
                end
            end
        elseif method == 5 then
            if IsEntityPlayingAnim(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT3", 3) then
                if GetEntityAnimCurrentTime(PlayerPedId(), dictionary, "PLYR_BUY_DRINK_PT3") > 0.306 then
                    SetPlayerControl(PlayerPedId(), false, 256)
                    DetachEntity(TempCan, false, true)
                    RemoveAnimDict(dictionary)
                    SetModelAsNoLongerNeeded(CanModel)
                    ReleaseAmbientAudioBank()
                    TempCan = nil;
                    method = 0;
                    API._varyThirst(GetPlayerServerId(PlayerId()), thirst)
                end
            end
        end
    end
end)

function ShowMessage(gtaMessage, value) 
    BeginTextCommandDisplayHelp(gtaMessage);
    EndTextCommandDisplayHelp(0, 0, 1, value);
end