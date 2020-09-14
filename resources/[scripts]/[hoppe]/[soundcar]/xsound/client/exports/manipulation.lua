function Distance(name_, distance_)
    if not _name then return end
    SendNUIMessage({
        status = "distance",
        name = name_,
        distance = distance_,
    })
    -- https://www.youtube.com/watch?v=
    soundInfo[name_].distance = distance_

end

exports('Distance', Distance)

function Position(name_, pos)
    SendNUIMessage({
        status = "soundPosition",
        name = name_,
        x = pos.x,
        y = pos.y,
        z = pos.z,
    })
    soundInfo[name_].position = pos
    soundInfo[name_].id = name_
end

exports('Position', Position)

function Destroy(name_)
    SendNUIMessage({
        status = "delete",
        name = name_
    })
    soundInfo[name_] = nil
end

exports('Destroy', Destroy)

function Resume(name_)
    SendNUIMessage({
        status = "resume",
        name = name_
    })
    soundInfo[name_].playing = true
    soundInfo[name_].paused = false
end

exports('Resume', Resume)

function Pause(name_)
    SendNUIMessage({
        status = "pause",
        name = name_
    })
    soundInfo[name_].playing = false
    soundInfo[name_].paused = true
end

exports('Pause', Pause)

function setVolume(name_, vol)
    if (name_ ~= nil ) then 
        if (vol ~= nil) then
            SendNUIMessage({
                status = "volume",
                volume = vol,
                name = name_,
            })
            soundInfo[name_].volume = vol
        end
    end
end

exports('setVolume', setVolume)

function setVolumeMax(name_, vol)
    SendNUIMessage({
        status = "max_volume",
        volume = vol,
        name = name_,
    })
    soundInfo[name_].volume = vol
end

exports('setVolumeMax', setVolumeMax)