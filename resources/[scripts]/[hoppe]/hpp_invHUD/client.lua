local Tunnel = module('_core', 'libs/Tunnel')
local Proxy = module('_core', 'libs/Proxy')

local hpp = Tunnel.getInterface("hpp_invHUD")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface('cAPI')

local capacity = 0
local weight = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        capacity = hpp.getCapacity()
        weight =  hpp.getWeight()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if weight ~= nil and capacity ~= 0 then
            if weight ~= nil and capacity ~= nil then
                if weight >= capacity then
                    drawTxt("INVENTÁRIO: ~r~"..weight.."kg~w~ / "..capacity.."kg",4,0.92,0.934,0.36,255,255,255,240)
                end

                if weight >= capacity * 0.7 and weight < capacity then
                    drawTxt("INVENTÁRIO: ~y~"..weight.."kg~w~ / "..capacity.."kg",4,0.92,0.934,0.36,255,255,255,240)
                end

                if weight < capacity * 0.7 then
                    drawTxt("INVENTÁRIO: ~g~"..weight.."kg~w~ / "..capacity.."kg",4,0.92,0.934,0.36,255,255,255,240)
                end
            end
        end
    end
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end