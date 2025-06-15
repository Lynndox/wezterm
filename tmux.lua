local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

---@param config unknown
---@param opts { pane_resize: number? }
function M.apply_to_config(config, opts)
	local pane_resize = opts.pane_resize or 5

	local keys = {
		-- "standard" tmux bindings

		-- Tabs
		{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "c", mods = "LEADER|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
		{
			key = "d",
			mods = "LEADER|CTRL",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "p", mods = "LEADER|CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "n", mods = "LEADER|CTRL", action = act.ActivateTabRelative(1) },
		{ key = "l", mods = "LEADER", action = act.ActivateLastTab },
		{ key = "l", mods = "LEADER|CTRL", action = act.ActivateLastTab },

		-- Panes
		{ key = "{", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
		{ key = "{", mods = "LEADER|CTRL", action = act.RotatePanes("CounterClockwise") },
		{ key = "}", mods = "LEADER", action = act.RotatePanes("Clockwise") },
		{ key = "}", mods = "LEADER|CTRL", action = act.RotatePanes("Clockwise") },
		-- { key = "q",          mods = "LEADER",      action = act.PaneSelect({ mode = "Activate" }) },
		-- { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
		-- { key = "!",          mods = "LEADER",      action = M.action.MovePaneToNewTab },
		{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "x", mods = "LEADER|CTRL", action = act.CloseCurrentPane({ confirm = true }) },

		-- Navigation
		{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

		-- Resizing Panes
		{
			key = "h",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Left", pane_resize }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "j",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Down", pane_resize }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "k",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Up", pane_resize }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},
		{
			key = "l",
			mods = "LEADER|SHIFT",
			action = act.Multiple({
				act.AdjustPaneSize({ "Right", pane_resize }),
				act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
			}),
		},

		-- Splitting Panes
		{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "\\", mods = "LEADER|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "LEADER|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- Swapping Windows
		{ key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "<", mods = "LEADER|CTRL|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
		{ key = ">", mods = "LEADER|CTRL|SHIFT", action = act.MoveTabRelative(1) },
	}

	local index_offset = config.tab_and_split_indices_are_zero_based and 0 or 1
	for i = index_offset, 9 do
		table.insert(keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - index_offset) })
	end

	if not config.keys then
		config.keys = {}
	end
	for _, key in ipairs(keys) do
		table.insert(config.keys, key)
	end

	if not config.key_tables then
		config.key_tables = {}
	end
	config.key_tables.resize_pane = {
		{ key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", pane_resize }) },
		{ key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", pane_resize }) },
		{ key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", pane_resize }) },
		{ key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", pane_resize }) },
		{ key = "Escape", action = act.PopKeyTable },
	}
end

return M
