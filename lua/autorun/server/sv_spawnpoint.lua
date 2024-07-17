hook.Add("PlayerSpawn", "spawn_point", function(ply)
	
	if ply:GetNWBool("has_spawn", false) then
		local position = ply:GetNWVector("spawn_position") + Vector(0,0,20)
		ply:SetPos(position)
		local pt = ply:GetNWVector("spawn_position")
		local e = EffectData()
		e:SetOrigin( pt )
		e:SetMagnitude(10)
		e:SetScale(10)
		util.Effect( "ManhackSparks", e )
	end

end)