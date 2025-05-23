-- eliane.lua
-- Eliane: Modular ARP 2500-style emulator for Norns with 128-grid and 16n support

engine.name = "eliane"

local g
local grid_rows = 16
local grid_cols = 16
local patches = {}
local performance_mode = false
local presets = include("eliane/presets")
local current_macro = 1

-- optional brightness levels by row or col (example setup)
local brightness_map = {}
for i = 1, grid_rows do
  brightness_map[i] = 2 + (i % 4) * 3 -- cycles through brightness values
end

function init()
  g = grid.connect()
  for i = 1, grid_rows do
    patches[i] = {}
    for j = 1, grid_cols do
      patches[i][j] = false
    end
  end

  params:add_group("Eliane Controls", 4)
  params:add_control("cutoff", "Filter Cutoff", controlspec.new(20, 18000, "exp", 0, 1000, "Hz"))
  params:add_control("resonance", "Filter Resonance", controlspec.new(0, 1, "lin", 0, 0.3))
  params:add_control("amp", "Amplitude", controlspec.new(0, 1, "lin", 0.01, 0.5))
  params:add_control("lfo_rate", "LFO Rate", controlspec.new(0.01, 10, "lin", 0.01, 0.5))

  params:set_action("cutoff", function(x) engine.cutoff(x) end)
  params:set_action("resonance", function(x) engine.res(x) end)
  params:set_action("amp", function(x) engine.amp(x) end)
  params:set_action("lfo_rate", function(x) engine.lforate(x) end)

  params:bang()
end

function key(n, z)
  if z == 1 then
    if n == 2 then
      performance_mode = not performance_mode
    elseif n == 3 then
      trigger_macro(current_macro)
    end
  end
end

function g.key(x, y, z)
  if z == 1 then
    if performance_mode then
      handle_performance_key(x, y)
    else
      patches[y][x] = not patches[y][x]
    end
    gredraw()
  end
end

function trigger_macro(id)
  if id == 1 then
    engine.gate(1)
  elseif id == 2 then
    engine.amp(0)
  elseif id == 3 then
    engine.amp(0.5)
  end
end

function handle_performance_key(x, y)
  if y == 1 and x <= 3 then
    current_macro = x
  elseif y == 2 and x == 1 then
    save_patch()
  elseif y == 2 and x == 2 then
    load_patch(1)
  end
end

function save_patch()
  local copy = {}
  for i = 1, grid_rows do
    copy[i] = {}
    for j = 1, grid_cols do
      copy[i][j] = patches[i][j]
    end
  end
  presets.save(copy)
end

function load_patch(index)
  local loaded = presets.load(index)
  for i = 1, grid_rows do
    for j = 1, grid_cols do
      patches[i][j] = loaded[i] and loaded[i][j] or false
    end
  end
  gredraw()
end

function gredraw()
  g:all(0)
  if performance_mode then
    g:led(current_macro, 1, 15)
    g:led(1, 2, 10)
    g:led(2, 2, 10)
  else
    for y = 1, grid_rows do
      for x = 1, grid_cols do
        local base_brightness = brightness_map[y]
        if patches[y][x] then
          g:led(x, y, 15)
        else
          g:led(x, y, base_brightness)
        end
      end
    end
  end
  g:refresh()
end

function redraw()
  screen.clear()
  screen.move(10, 10)
  screen.text("Eliane Modular")
  screen.move(10, 30)
  screen.text(performance_mode and "Performance Mode" or "Patch Mode")
  screen.move(10, 45)
  screen.text("Macro: " .. current_macro)
  screen.update()
end

function cleanup()
  -- reset any active engine state if needed
end
