addEventHandler("onClientPlayerJoin",
	getRootElement(),
	function()
		local r,g,b = getPlayerNametagColor(localPlayer)
		appendMessage("#089c19[INFO] "..getPlayerName(localPlayer).." #FFFFFFhas joined the server.",0,0,0,5000)
	end)

