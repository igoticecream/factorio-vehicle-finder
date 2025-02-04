data:extend({
    -- PER PLAYER SETTINGS
    {
        type = "bool-setting",
        name = "vehicle-finder-locate-cars",
        setting_type = "runtime-per-user",
        default_value = true,
        order = 'a',
    },
    {
        type = "bool-setting",
        name = "vehicle-finder-locate-tanks",
        setting_type = "runtime-per-user",
        default_value = true,
        order = 'b',
    },
    {
        type = "bool-setting",
        name = "vehicle-finder-locate-spidertrons",
        setting_type = "runtime-per-user",
        default_value = true,
        order = 'c',
    },
    {
        type = "bool-setting",
        name = "vehicle-finder-force",
        setting_type = "runtime-per-user",
        default_value = false,
        order = 'd',
    },
    {
        type = "bool-setting",
        name = "vehicle-finder-sound",
        setting_type = "runtime-per-user",
        default_value = true,
        order = 'e',
    },
    {
        type = "bool-setting",
        name = "vehicle-finder-color",
        setting_type = "runtime-per-user",
        default_value = false,
        order = 'f',
    },
})
