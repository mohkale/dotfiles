-- SPDX-License-Identifier: GPL-3.0-or-later
-- SPDX-FileType: SOURCE
-- SPDX-FileCopyrightText: 2023 - 2024 Mohammadreza Hendiai <man2dev@fedoraproject.org>
-- SPDX-FileCopyrightText: Copyright 2023-2024 Mohammadreza Hendiai
-- SPDX-FileCopyrightText: Copyright contributors to the Boss-key-wayland project.
--
-- Adapted from: https://github.com/Man2Dev/mpv-wayland-Boss-key/blob/781c707e7b369f93c0aa000bf033463aaf7652d3/way-key.lua

local mp = require 'mp'

mp.add_key_binding("b", "minimize-window", function()
    mp.set_property("pause", "yes")
    mp.set_property("window-minimized", "yes")
end)
