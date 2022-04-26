function AccessorFuncDT(tab, membername, type, id)
	local emeta = FindMetaTable("Entity")
	local setter = emeta["SetDT" .. type]
	local getter = emeta["GetDT" .. type]

	tab["Set" .. membername] = function(me, val)
		setter(me, id, val)
	end

	tab["Get" .. membername] = function(me)
		return getter(me, id)
	end
end
