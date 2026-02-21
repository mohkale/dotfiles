-- Exit fullscreen when playback ends, if keep-open=yes
--
-- Sourced from https://github.com/zc62/mpv-scripts/blob/a8920592a4dbda574b51ddc6c2000851a13549a5/exit-fullscreen.lua

mp.observe_property("eof-reached", "bool", function(name, value)
    if value then
        local pause = mp.get_property_native("pause")
        if pause then
            local fullscreen = mp.get_property_native("fullscreen")
            if fullscreen then
                mp.set_property_native("fullscreen", false)
            end
        end
    end
end)
