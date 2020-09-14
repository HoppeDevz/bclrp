_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Som Automotivo", "~b~Locomotiva Xero de Pneu Queimado")
_menuPool:Add(mainMenu)

function FirstItem(menu) 
    local click = NativeUI.CreateItem("Continuar Música", "Continue a música e depois você pausar nela")
    menu:AddItem(click)
    click.Activated = function(sender, item)
        print("Resume Music")
        TriggerEvent("hoppe:resumemusic")
    end
end

function SecondItem(menu) 
    local click = NativeUI.CreateItem("Pausar Música", "Pause a música e depois você pode dar um resume nela")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            print("Stop Music")
            TriggerEvent("hoppe:pausemusic")
        end
    end
end

function ThirdItem(menu)
    local click = NativeUI.CreateItem("Tirar Música", "Cancele a música que está tocando")
    menu:AddItem(click)
    click.Activated = function(sender, item)
        print("Cancel Music")
        TriggerEvent("hoppe:stopmusic")
    end
end

volums = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 }
function volume(menu)
    local volume = NativeUI.CreateSliderItem("Volume", volums, 1)
    menu.OnSliderChange = function(sender, item, index)
        volum = item:IndexToItem(index)
        TriggerEvent("hoppe:changeVolum", volum)
    end
    menu:AddItem(volume)
end
-- used in "FourthItem"
function FourthItem(menu) 
   local submenu = _menuPool:AddSubMenu(menu, "~b~Músicas") 
   local artist00 = _menuPool:AddSubMenu(submenu, "Orochi")
   local artist01 = _menuPool:AddSubMenu(submenu, "Recayd")

   local playlist00 = _menuPool:AddSubMenu(submenu, "Só funk zika")
   local playlist01 = _menuPool:AddSubMenu(submenu, "Swingueira")
   local playlist02 = _menuPool:AddSubMenu(submenu, "Anúncios")

   --orochi
   local orochi00 = NativeUI.CreateItem("24 Horas", "24 Horas")
   orochi00.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=Ebu1s7kwO_s
        --play music
        TriggerEvent("hoppe:playmusic", "https://www.youtube.com/watch?v=Ebu1s7kwO_s")
   end
   local orochi01 = NativeUI.CreateItem("Balão", "Balão")
   orochi01.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=L8_116bLouo
        --play music
        TriggerEvent("hoppe:playmusic", "https://www.youtube.com/watch?v=L8_116bLouo")
   end
   local orochi02 = NativeUI.CreateItem("MITSUBISHI", "MITSUBISHI")
   orochi02.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=UvYYABiJV2E
        --play music
        TriggerEvent("hoppe:playmusic", "https://www.youtube.com/watch?v=UvYYABiJV2E")
   end
   local orochi03 = NativeUI.CreateItem("American pie", "American pie")
   orochi03.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=UvYYABiJV2E
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/americanpie.mp3")
   end

   --SóFunkZika
   local sfz00 = NativeUI.CreateItem("Maconha Buceta", "Maconha Buceta")
   sfz00.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=ssFih83vtHE
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/maconhabuceta.mp3")
   end
   local sfz01 = NativeUI.CreateItem("Adestrador Madeon", "Adestrador Madeon")
   sfz01.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=ssFih83vtHE
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/adestradormadeon.mp3")
   end
   local sfz02 = NativeUI.CreateItem("Xero de Pneu Queimado", "Xero de Pneu Queimado")
   sfz02.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=ssFih83vtHE
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/xeropneuqueimado.mp3")
   end
   local sfz03 = NativeUI.CreateItem("Na Raba Toma Tapao", "Na Raba Toma Tapao")
   sfz03.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=ssFih83vtHE
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/narabatomatapao.mp3")
   end


   --recayd
   local recayd00 = NativeUI.CreateItem("Recayd FlackJack", "Recayd FlackJack")
   recayd00.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "https://www.youtube.com/watch?v=_R5e_BB66lk")
   end
   local recayd01 = NativeUI.CreateItem("Recayd BabyHair", "Recayd BabyHair")
   recayd01.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/babyhair.mp3")
   end
   local recayd02 = NativeUI.CreateItem("Plaqtudum", "Plaqtudum")
   recayd02.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/plaqtudum.mp3")
   end

   --Swingueira
   local swing00 = NativeUI.CreateItem("Saveiro Pega No Breu", "Saveiro Pega No Breu")
   swing00.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/saveiropegabreu.mp3")
   end
   local swing01 = NativeUI.CreateItem("Barões Nunca Vai Ser Eu", "Barões Nunca Vai Ser Eu")
   swing01.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/nuncavaisereu.mp3")
   end

   --Anuncios
   local ann00 = NativeUI.CreateItem("Vinheta Abacaxi", "Vinheta Abacaxi")
   ann00.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/vinhetaabavaxi.mp3")
   end
   local ann01 = NativeUI.CreateItem("Carro do Ovo", "Carro do Ovo")
   ann01.Activated = function(sender, item)
    --https://www.youtube.com/watch?v=_R5e_BB66lk
        --play music
        TriggerEvent("hoppe:playmusic", "../html/sounds/carrodoovo.mp3")
   end

   --orochi
   artist00:AddItem(orochi00)
   artist00:AddItem(orochi01)
   artist00:AddItem(orochi02)
   artist00:AddItem(orochi03)

   --recayd
   artist01:AddItem(recayd00)
   artist01:AddItem(recayd01)
   artist01:AddItem(recayd02)

   --sfz
   playlist00:AddItem(sfz00)
   playlist00:AddItem(sfz01)
   playlist00:AddItem(sfz02)
   playlist00:AddItem(sfz03)

   --swingueira
   playlist01:AddItem(swing00)
   playlist01:AddItem(swing01)

   --anuncios
   playlist02:AddItem(ann00)
   playlist02:AddItem(ann01)
end

FirstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
FourthItem(mainMenu)
volume(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        --[[ The "e" button will activate the menu ]]
        if IsControlJustPressed(0, 244) then
            if (IsPedInAnyVehicle(GetPlayerPed(-1), true)) then
                mainMenu:Visible(not mainMenu:Visible())
            end
        end
    end
end)