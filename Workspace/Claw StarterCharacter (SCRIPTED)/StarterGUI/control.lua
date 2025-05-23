-- @ScriptType: LocalScript
local StarterGUI = script.Parent

local equippedContext = StarterGUI:WaitForChild("ClawsEquipped")
local unequippedContext = StarterGUI:WaitForChild("ClawsUnequipped")
local mechanicsContext = StarterGUI:WaitForChild("Mechanics")

local equipAction = unequippedContext:WaitForChild("EquipClaws")
local unequipAction = equippedContext:WaitForChild("UnequipClaws")
local attackAction = equippedContext:WaitForChild("Attack")

local current_step = 0 -- 0, 1, 2
local attack_db, attack_offset = false, 0.6

local claw_action_RE = game:GetService("ReplicatedStorage"):WaitForChild("ClawAction")

local debounce, equip_offset = false, 1

equipAction.Pressed:Connect(function()
	if not debounce then
		debounce = true
		claw_action_RE:FireServer("Equip")
		task.wait(equip_offset)
		debounce = false
	end
end)

attackAction.Pressed:Connect(function()
	if not attack_db then
		attack_db = true
		
		claw_action_RE:FireServer("Attack"..current_step)
		
		current_step += 1
		current_step %= 3
		task.wait(attack_offset)
		attack_db = false
	end
end)

unequipAction.Pressed:Connect(function()
	if not debounce then
		debounce = true
		claw_action_RE:FireServer("Unequip")
		task.wait(equip_offset)
		debounce = false
	end
end)

