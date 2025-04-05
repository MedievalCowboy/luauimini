-- @module utils
-- This module provides utility functions for various operations such as math, string manipulation,
-- table handling, file operations, and time-related utilities.

local O = {}
-- Collection of colors
O.color = {
    RGBA = {
        black = { 1, 1, 1, 1 },
        white = { 0, 0, 0, 1 },
        red = { 1, 0, 0, 1 },
        green = { 0, 1, 0, 1 },
        blue = { 0, 0, 1, 1 },
        grey = { 0.75, 0.75, 0.75, 1 },
    },
}
-- math helpers collection
O.math = {
    -- This function generates a random number between min and max
    -- min -> number
    -- max -> number
    -- returns a random number between min and max
    random = function(min, max)
        return math.random(min, max)
    end,
    -- This function generates a random number between min and max with a decimal point
    -- min -> number
    -- max -> number
    -- returns a random number between min and max with a decimal point
    random_range = function(min, max)
        return math.random() * (max - min) + min
    end,
    -- This function generates a random number with a specified number of decimal places
    random_decimal = function(decimals)
        decimals = decimals or 4
        local factor = 10 ^ decimals
        return math.floor(math.random() * factor) / factor
    end
}
-- string helpers collection
O.string = {
    -- This function checks if a string starts with a specific prefix
    -- original_string -> string
    -- prefix -> string
    -- returns true if the original string starts with the prefix, false otherwise
    starts_with = function(original_string, prefix)
        return original_string:sub(1, #prefix) == prefix
    end,
    -- This function checks if a string ends with a specific suffix
    -- original_string -> string
    -- suffix -> string
    -- returns true if the original string ends with the suffix, false otherwise
    ends_With = function(original_string, suffix)
        return original_string:sub(- #suffix) == suffix
    end,
    -- This function checks if a string contains a specific substring
    -- original_string -> string
    -- substring -> string
    -- returns true if the original string contains the substring, false otherwise
    substring = function(original_string, substring)
        return original_string:find(substring) ~= nil
    end
}
-- table helpers collection
O.table = {
    -- This function checks if a table contains a specific value
    -- table -> table
    -- value -> any
    -- returns true if the table contains the value, false otherwise
    contains = function(table, value)
        for _, v in ipairs(table) do
            if v == value then
                return true
            end
        end
        return false
    end,
    -- This function checks if a table is empty
    -- table -> table
    -- indent -> number (optional)
    -- returns true if the table is empty, false otherwise
    print = function(table, indent)
        indent = indent or 0
        local indent_spaces = string.rep(" ", indent)
        for key, value in pairs(table) do
            if type(value) == "table" then
                print(indent_spaces .. key .. ":")
                O.table.print(value, indent + 2)
            else
                print(indent_spaces .. key .. ": " .. tostring(value))
            end
        end
    end,
    -- This function checks if a table is empty
    -- table -> table
    -- returns true if the table is empty, false otherwise
    empty = function(table)
        for _, _ in pairs(table) do
            return false
        end
        return true
    end
}
-- file handling helpers collection
O.file = {
    -- This function checks if a file exists
    -- filename -> string
    -- returns true if the file exists, false otherwise
    exists = function(filename)
        local file = io.open(filename, "r")
        if file then
            file:close()
            return true
        else
            return false
        end
    end,
    -- This function reads the contents of a file
    -- filename -> string
    -- returns the contents of the file as a string
    read = function(filename)
        local file = io.open(filename, "r")
        if file then
            local content = file:read("*a")
            file:close()
            return content
        else
            return nil
        end
    end
}
-- time-related utilities collection
O.time = {
    -- Get the current date in YYYY-MM-DD format
    getDate = function()
        return os.date("%Y-%m-%d")
    end,
    -- Get the current time in HH:MM:SS format
    getTime = function()
        return os.date("%H:%M:%S")
    end,
    -- Get the current timestamp in YYYY-MM-DD_HH-MM-SS format
    getTimestamp = function()
        return os.date("%Y-%m-%d_%H-%M-%S")
    end,
    -- Calculate the difference in seconds between two os.time values
    -- @params startTime -> number (os.time value)
    -- @params endTime -> number (os.time value)
    getTimeDifference = function(startTime, endTime)
        return os.difftime(endTime, startTime)
    end
}

function O.Class(baseClass)
    local class = {}
    class.__index = class

    -- Si hay una clase base, establece la herencia
    if baseClass then
        setmetatable(class, {__index = baseClass})
    end

    -- Constructor para crear nuevas instancias
    function class:new(...)
        local obj = setmetatable({}, class)
        if obj.initialize then
            obj:initialize(...)
        end
        return obj
    end

    return class
end

return O;
