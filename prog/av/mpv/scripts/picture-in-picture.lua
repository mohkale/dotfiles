local mp = require 'mp'

pip_previous_state = nil

function _desktop_set_on_top(value)
  if os.getenv("XDG_SESSION_TYPE") == "wayland" then
    if os.getenv("XDG_SESSION_DESKTOP") == "KDE" then
      print(os.getenv("XDG_SESSION_DESKTOP"))
      return
    end
  else
  end
  mp.set_property_bool("ontop", value)
end

function enable_pip()
  pip_previous_state = {
    geometry = mp.get_property("geometry")
  }
  mp.set_property_bool("border", false)
  _desktop_set_on_top(true)
  mp.set_property("geometry", "15%")
  for key, value in pairs(pip_previous_state) do
    print(key .. " " .. value)
  end
end

function disable_pip()
  mp.set_property_bool("border", true)
  _desktop_set_on_top(false)
  mp.set_property("geometry", pip_previous_state.geometry)
  pip_previous_state = nil
end

function toggle_pip()
  if pip_previous_state == nil then
    enable_pip()
  else
    disable_pip()
  end
end

mp.add_key_binding("T", "toggle-picture-in-picture", toggle_pip)
