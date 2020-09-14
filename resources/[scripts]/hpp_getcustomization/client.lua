local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_mechanic")

hppC = {}
Tunnel.bindInterface("hpp_mechanic", hppC)

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

RegisterCommand("getCustom", function(source, args, rawCommand)
    local custom = ""
    local content = getCustomization()
    for k,v in pairs(content) do
        custom = custom..k.." => "..json.encode(v).."\n"
    end

    print(custom)
end)

function getCustomization()
    local ped = GetPlayerPed(-1)
  
    local custom = {}
  
    custom.modelhash = GetEntityModel(ped)
  
    -- ped parts
    for i=0,20 do -- index limit to 20
      custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
    end
  
    -- props
    for i=0,10 do -- index limit to 10
      custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
    end
  
    return custom
end