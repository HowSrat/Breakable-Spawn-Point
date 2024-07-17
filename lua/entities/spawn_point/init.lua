AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.player = self:GetCreator()

	if self.player.number ~= nil then
		if self.player.number >= 1 then
			self.player.number = (self.player.number + 1)
			self.player:SendLua([[
				surface.PlaySound("buttons/button10.wav")
				notification.AddLegacy("You've hit the Spawn Points limit!",1,2)
			]])
			self:Remove()
			return
		end
		self.player.number = (self.player.number + 1)
	else
		self.player.number = 1
	end

	self:SetModel("models/props_combine/combine_mine01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWInt("Health", 100)
	self:SetNWString("owners", self:GetCreator():Nick())
	self:GetCreator():SetNWBool("has_spawn", true)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	self:SetAngles(Angle(0, 0, 0))

end

function ENT:Think()

	if self:GetNWInt("Health") <= 0 then
		self:Remove()
	end

	self:GetCreator():SetNWBool("has_spawn", true)
	self:GetCreator():SetNWVector("spawn_position", self:GetPos())

end

function ENT:OnTakeDamage(dmg)

	if dmg:IsBulletDamage() then
		if not self.Damaged then
			self.Damaged = true
			self:TakePhysicsDamage(dmg)
			local dmg = math.Clamp(math.floor(self:GetNWInt("Health") - dmg:GetDamage()), 0, 100)
			self:SetNWInt("Health", dmg)
			self.Damaged = false
		end
	end

end

function ENT:OnRemove()
	local pt = self:GetPos()
	local e = EffectData()
	e:SetOrigin( pt )
	util.Effect( "glassimpact", e )

	self:GetCreator():SetNWBool("has_spawn", false)
	self.player.number = self.player.number and (self.player.number - 1)
end