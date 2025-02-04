local sounds = {
    ["found"]     = { path = "car-found" },
    ["not-found"] = { path = "utility/cannot_build" },
    -- ["test-0"]    = { path = "car-engine-start" },
    -- ["test-1"]    = { path = "utility/new_objective" },
    -- ["test-2"]    = { path = "utility/scenario_message" },
}

--- @param event EventData.CustomInputEvent|EventData.on_lua_shortcut
local function locate_vehicles(event)
    local player = game.get_player(event.player_index)

    if player and player.valid and player.connected then
        local surface  = player.surface
        local force    = player.force
        local vehicles = {}

        -- Find all vehicles (cars, tanks, spidertrons) on the surface that belong to the player's force
        for _, vehicle in pairs(surface.find_entities_filtered({ type = { "car", "spider-vehicle" }, force = force })) do
            if vehicle.last_user == player then
                -- Vehicles that belongs to the player
                table.insert(vehicles, vehicle)
            elseif player.mod_settings["vehicle-finder-force"].value then
                -- Vehicles that belongs to the same force
                table.insert(vehicles, vehicle)
            end
        end

        -- Remove cars vehicles from the list
        if not player.mod_settings["vehicle-finder-locate-cars"].value then
            for i = #vehicles, 1, -1 do -- Iterate backward to avoid index shifting when removing
                if vehicles[i].name == "car" then
                    table.remove(vehicles, i)
                end
            end
        end

        -- Remove tanks vehicles from the list
        if not player.mod_settings["vehicle-finder-locate-tanks"].value then
            for i = #vehicles, 1, -1 do -- Iterate backward to avoid index shifting when removing
                if vehicles[i].name == "tank" then
                    table.remove(vehicles, i)
                end
            end
        end

        -- Remove spidertrons vehicles from the list
        if not player.mod_settings["vehicle-finder-locate-spidertrons"].value then
            for i = #vehicles, 1, -1 do -- Iterate backward to avoid index shifting when removing
                if vehicles[i].type == "spider-vehicle" then
                    table.remove(vehicles, i)
                end
            end
        end

        -- Check if no vehicles were found
        if #vehicles == 0 then
            player.create_local_flying_text {
                text = { "vehicle-finder.vehicles-not-found" },
                position = player.position,
                color = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 }
            }
            player.play_sound(sounds["not-found"])
            return
        end

        -- Sort vehicles from farthest to closest
        table.sort(vehicles, function(a, b)
            local dist_a = (a.position.x - player.position.x) ^ 2 + (a.position.y - player.position.y) ^ 2
            local dist_b = (b.position.x - player.position.x) ^ 2 + (b.position.y - player.position.y) ^ 2
            return dist_a > dist_b -- Sort descending (farthest first)
        end)

        -- Send an alert for each found vehicle
        for _, vehicle in pairs(vehicles) do
            local message
            local icon = { type = "item", name = vehicle.name }
            local name = vehicle.entity_label or vehicle.localised_name

            if player.mod_settings["vehicle-finder-color"].value and vehicle.color and vehicle.color.a > 0 then
                local r = math.floor((255 * vehicle.color.r) + 0.5)
                local g = math.floor((255 * vehicle.color.g) + 0.5)
                local b = math.floor((255 * vehicle.color.b) + 0.5)
                message = { "vehicle-finder.vehicles-found-colored", name, r, g, b }
            else
                message = { "vehicle-finder.vehicles-found", name }
            end
            player.add_custom_alert(vehicle, icon, message, true)

            -- player.print({ "vehicle-finder.vehicles-found-gps", name, vehicle.gps_tag })
        end

        -- Play notification sound
        if player.mod_settings["vehicle-finder-sound"].value then -- or settings.get_player_settings(player)["vehicle-finder-sound"]
            player.play_sound(sounds["found"])
        end
    end
end

--- @param event EventData.CustomInputEvent
script.on_event("vehicle-finder-input", function(event)
    if event then
        locate_vehicles(event)
    end
end)

--- @param event EventData.on_lua_shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event and event.prototype_name == "vehicle-finder-shortcut" then
        locate_vehicles(event)
    end
end)
