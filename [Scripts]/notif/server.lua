

--------------------------------------------
-- Warn players of their wrong doings. 
--------------------------------------------
addCommandHandler("warn",
	function(thePlayer, cmd, player, ...)
		if hasObjectPermissionTo(thePlayer, "command.slap", false) then
			player = player or ""
			local element = getPlayerFromName(player)
			if isElement(element) then
				triggerClientEvent(element, "bar:message", getRootElement(), "#FF0000[WARNING] "..getPlayerName(thePlayer):upper()..":  #FFFFFF"..table.concat(arg, " "), 0,0,0)
				playSoundFrontEnd(element, 33)
			else
				outputChatBox("#FF0000[WARN] #FFFFFFPlayer: "..player.." doesn't exist.", thePlayer, 0, 0, 0, true)
			end
		else
			outputServerLog("[WARN] Player "..getPlayerName(thePlayer).." attempted to warn without authorization.")
		end
	end
)

--------------------------------------------
-- 
--------------------------------------------
addCommandHandler("alert",
	function(thePlayer, cmd, ...)
		if hasObjectPermissionTo(thePlayer, "command.slap", false) then
			local text = table.concat (arg, " ")
			local players = getElementsByType("player")
			if #text ~= 0 and #players ~= 0 then
				for k, v in ipairs(players) do
					triggerClientEvent(v, "bar:message", getRootElement(), "#FF0000[ALERT] "..getPlayerName(thePlayer):upper()..":  #FFFFFF"..text:upper(),0,0,0, 4000)
				end
			else
				outputChatBox("#FF0000[ALERT] #FFFFFFPlease enter text.", thePlayer, 0,0,0, true)
			end
		else
			outputServerLog("[ALERT] Player "..getPlayerName(thePlayer).." attempted to warn without authorization.")
		end
	end)

addEventHandler("onPlayerMute",
	getRootElement(),
	function()
		if isPlayerMuted(source) then
			triggerClientEvent(source, "bar:message", getRootElement(), "You have been muted. Please read the rules.",255,0,0, 2000)
			local players = getElementsByType("player")
			for k, v in ipairs(players) do
				if v ~= source then
					triggerClientEvent(v, "bar:message", getRootElement(),getPlayerName(v).." has been muted." ,255,0,0)
				end
			end
		end
	end)

addEventHandler("onPlayerUnmute",
	getRootElement(),
	function()
		triggerClientEvent(source, "bar:message", getRootElement(), "You are now unmuted. Think before you speak.",0,255,0, 2500)
	end)

--------------------------------------------
-- EXPORT FUNCTION
-- doc: 
-- src = Define if you don't want the source's client triggered
-- to = Define as specific target or all players (exluding src if defined.)
--------------------------------------------
function addMessage(src, to, message, r,g,b, delay, pri)
	if	message and type(r,g,b) == "number" then

		delay = delay or 2000
		pri = pri or nil
		src = src or nil
		if src ~= nil and not (isElement(src)) then assert("source isn't an element."); src = nil end 
		if not isElement(to) then to = getElementsByType("player") end
		-- pri - short for priority

		if pri then
			pri = "bar:alert"
		else
			pri = "bar:message"
		end

			if type(to) == "table" then
				for k, v in ipairs(to) do
					if v ~= src then
						triggerClientEvent(v, pri, getRootElement(),message, r,g,b, delay )
					end
				end
				return true
			else
				triggerClientEvent(to, pri, getRootElement(),message, r,g,b, delay)
				return true
			end
	end
	return false
end

