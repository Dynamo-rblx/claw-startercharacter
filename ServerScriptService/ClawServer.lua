-- @ScriptType: Script
local Claw_Action_RE = game:GetService("ReplicatedStorage"):WaitForChild("ClawAction")
local anim_folder = script:WaitForChild("Animations")
local sounds = script:WaitForChild("Sounds")
local attacks, transitions, status = anim_folder:WaitForChild("Attacks"), anim_folder:WaitForChild("Transitions"), anim_folder:WaitForChild("Status")
local status_anim: {AnimationTrack} = {}
local equipped: {boolean} = {}
local Debris = game:GetService("Debris")

game.Players.PlayerAdded:Connect(function(plr)
	status_anim[plr.Name] = nil
	
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild('Humanoid').Died:Connect(function()
			equipped[plr.Name] = false
		end)
	end)
end)

game.Players.PlayerRemoving:Connect(function(plr)
	status_anim[plr.Name] = nil
end)

Claw_Action_RE.OnServerEvent:Connect(function(plr: Player, request: string)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local animator: Animator = char:WaitForChild("Humanoid"):WaitForChild("Animator")

	if request == "Equip" and not equipped[plr.Name] then
		if status_anim[plr.Name] then status_anim[plr.Name]:Stop(); status_anim[plr.Name]:Destroy(); end


		local init_anim = animator:LoadAnimation(transitions:WaitForChild("EquipClaws"))

		init_anim:GetMarkerReachedSignal("KnucklesTogether"):Connect(function()
			local temp_sound = sounds:WaitForChild("Equip"):Clone()
			temp_sound.Parent = char["HumanoidRootPart"]
			temp_sound:Play()
			Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		end)

		init_anim:GetMarkerReachedSignal("war cry"):Connect(function()
			local temp_sound = sounds:WaitForChild("Grizzly Bear Roar"):Clone()
			temp_sound.Parent = char["HumanoidRootPart"]
			temp_sound:Play()
			Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		end)

		init_anim.Looped = false
		init_anim.Priority = Enum.AnimationPriority.Action2
		init_anim:Play(0)

		init_anim.Ended:Wait()

		local equipped_anim = animator:LoadAnimation(status:WaitForChild("ClawsEquipped"))


		status_anim[plr.Name] = equipped_anim
		equipped[plr.Name] = true
		equipped_anim.Looped = true
		equipped_anim.Priority = Enum.AnimationPriority.Action3
		equipped_anim:Play(0, 1)

		plr.PlayerGui:WaitForChild("ClawsEquipped").Enabled = true
		plr.PlayerGui:WaitForChild("ClawsUnequipped").Enabled = false

	elseif request == "Unequip" and equipped[plr.Name] then
		if status_anim[plr.Name] then status_anim[plr.Name]:Stop(); status_anim[plr.Name]:Destroy(); end

		local init_anim = animator:LoadAnimation(transitions:WaitForChild("UnequipClaws"))
		init_anim:GetMarkerReachedSignal("Fully Extended"):Connect(function()
			local temp_sound = sounds:WaitForChild("Unequip"):Clone()
			temp_sound.Parent = char["HumanoidRootPart"]
			temp_sound:Play()
			Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		end)
		init_anim.Looped = false
		init_anim.Priority = Enum.AnimationPriority.Action2
		init_anim:Play(0)

		init_anim.Ended:Wait()

		local unequipped_anim = animator:LoadAnimation(status:WaitForChild("ClawsUnequipped"))
		
		status_anim[plr.Name] = unequipped_anim
		equipped[plr.Name] = false
		unequipped_anim.Looped = true
		unequipped_anim.Priority = Enum.AnimationPriority.Action3
		unequipped_anim:Play(0, 1)

		plr.PlayerGui:WaitForChild("ClawsUnequipped").Enabled = true
		plr.PlayerGui:WaitForChild("ClawsEquipped").Enabled = false

	elseif request == "Attack0" and equipped[plr.Name] then
		local attack0_anim = animator:LoadAnimation(attacks:WaitForChild("Left"))
		attack0_anim.Looped = false
		attack0_anim:AdjustSpeed(4)
		attack0_anim.Priority = Enum.AnimationPriority.Action4
		local temp_sound = sounds:WaitForChild("Slash1"):Clone()
		temp_sound.Parent = char["Left Arm"]["Claw"]
		temp_sound:Play()
		Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		attack0_anim:Play(.3, 1)
		char:WaitForChild("Head"):WaitForChild("SFX"):Play()

		local ovlprms = OverlapParams.new()
		ovlprms.FilterType = Enum.RaycastFilterType.Exclude
		ovlprms.FilterDescendantsInstances = {char}
		local already_hit = {}
		while attack0_anim.IsPlaying do
			task.wait()
			local touching = workspace:GetPartsInPart(char["Left Arm"]["Claw"], ovlprms)
			if touching then
				for i, part in pairs(touching) do
					if part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char and not(table.find(already_hit, part.Parent)) then
						table.insert(already_hit, part.Parent)
						part.Parent:WaitForChild("Humanoid"):TakeDamage(math.random(15, 30))
					end
				end
			end
		end


	elseif request == "Attack1" and equipped[plr.Name] then
		local attack1_anim = animator:LoadAnimation(attacks:WaitForChild("Right"))
		attack1_anim.Looped = false
		attack1_anim:AdjustSpeed(4)
		attack1_anim.Priority = Enum.AnimationPriority.Action4
		local temp_sound = sounds:WaitForChild("Slash2"):Clone()
		temp_sound.Parent = char["Right Arm"]["Claw2"]
		temp_sound:Play()
		Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		attack1_anim:Play(0.3, 1)
		char:WaitForChild("Head"):WaitForChild("SFX"):Play()



		local ovlprms = OverlapParams.new()
		ovlprms.FilterType = Enum.RaycastFilterType.Exclude
		ovlprms.FilterDescendantsInstances = {char}
		local already_hit = {}
		while attack1_anim.IsPlaying do
			task.wait()
			local touching = workspace:GetPartsInPart(char["Right Arm"]["Claw2"], ovlprms)
			if touching then
				for i, part in pairs(touching) do
					if part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char and not(table.find(already_hit, part.Parent)) then
						table.insert(already_hit, part.Parent)
						part.Parent:WaitForChild("Humanoid"):TakeDamage(math.random(15, 30))
					end
				end
			end
		end

	elseif request == "Attack2" and equipped[plr.Name] then
		local attack2_anim = animator:LoadAnimation(attacks:WaitForChild("Combo"))
		attack2_anim.Looped = false
		attack2_anim:AdjustSpeed(4)
		attack2_anim.Priority = Enum.AnimationPriority.Action4
		local temp_sound = sounds:WaitForChild("Slash1"):Clone()
		temp_sound.Parent = char["Left Arm"]["Claw"]
		temp_sound:Play()
		Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		attack2_anim:Play(0.3, 1)
		char:WaitForChild("Head"):WaitForChild("SFX"):Play()
		temp_sound.Destroying:Connect(function()
			local temp_sound = sounds:WaitForChild("Slash2"):Clone()
			temp_sound.Parent = char["Right Arm"]["Claw2"]
			temp_sound:Play()
			Debris:AddItem(temp_sound, temp_sound.TimeLength+0.02)
		end)

		local ovlprms = OverlapParams.new()
		ovlprms.FilterType = Enum.RaycastFilterType.Exclude
		ovlprms.FilterDescendantsInstances = {char}
		local already_hit = {}

		while attack2_anim.IsPlaying do
			task.wait()
			local touching1 = workspace:GetPartsInPart(char["Left Arm"]["Claw"], ovlprms)
			if touching1 then
				for i, part in pairs(touching1) do
					if part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char and not(table.find(already_hit, part.Parent)) then
						table.insert(already_hit, part.Parent)
						part.Parent:WaitForChild("Humanoid"):TakeDamage(math.random(15, 30))
					end
				end
			end
			task.wait()
			already_hit = {}
			local touching2 = workspace:GetPartsInPart(char["Right Arm"]["Claw2"], ovlprms)
			if touching2 then
				for i, part in pairs(touching2) do
					if part.Parent:FindFirstChild("Humanoid") and part.Parent ~= char and not(table.find(already_hit, part.Parent)) then
						table.insert(already_hit, part.Parent)
						part.Parent:WaitForChild("Humanoid"):TakeDamage(math.random(15, 30))
					end
				end
			end
		end

	end
end)