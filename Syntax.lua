local Syntax = {}
local RunService = game:GetService("RunService")

-- Optimized DestroyTime Function
function Syntax.DestroyTime(Time, Object)
	if Object and Object.Parent then
		task.delay(Time, function()
			if Object and Object.Parent then
				Object:Destroy()
			end
		end)
	end
end

-- Optimized ClearBV Function
function Syntax.ClearBV(Char, Target)
	if RunService:IsClient() then return end

	for _, BasePart in ipairs(Char:GetDescendants()) do
		if BasePart:IsA("BasePart") then
			BasePart.AssemblyLinearVelocity = Vector3.zero
			BasePart.AssemblyAngularVelocity = Vector3.zero
		end
	end

	for _, BV in ipairs(Target:GetChildren()) do
		if BV:IsA("BodyVelocity") or BV:IsA("BodyPosition") or BV:IsA("LinearVelocity") then
			BV:Destroy()
		end
	end
end

-- Optimized CreateRegion Function
function Syntax.CreateRegion(Owner, Position, TargetPosition, Size, KnockOut, Hit_Sound, Damage, Knockback, Knockback2, BlockRadius, Aoe, RagDoll, RagDoll_Duration)
	if not Owner then return nil end

	local NewDamageRegion = Instance.new("Folder")
	NewDamageRegion.Name = Owner.Name

	local ObjOwner = Instance.new("ObjectValue")
	ObjOwner.Name = "Owner"
	ObjOwner.Value = Owner
	ObjOwner.Parent = NewDamageRegion

	local Attributes = {
		Vec1 = (Position + TargetPosition) - (Size / 2),
		Vec2 = (Position + TargetPosition) + (Size / 2),
		Hit_Sound = Hit_Sound,
		Damage = Damage,
		Knockback = Knockback,
		Knockback2 = Knockback2,
		KnockOut = KnockOut,
		BlockRadius = BlockRadius,
		RagDoll = RagDoll,
		RagDoll_Duration = RagDoll_Duration,
		Aoe = Aoe
	}

	for Key, Value in pairs(Attributes) do
		NewDamageRegion:SetAttribute(Key, Value)
	end

	-- Ensure "DamageDetector" folder exists in ReplicatedStorage
	local DamageDetector = game.ReplicatedStorage:FindFirstChild("DamageDetector")
	if not DamageDetector then
		DamageDetector = Instance.new("Folder")
		DamageDetector.Name = "DamageDetector"
		DamageDetector.Parent = game.ReplicatedStorage
	end

	NewDamageRegion.Parent = DamageDetector
	return NewDamageRegion
end

return Syntax
