--[[

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 

 Copyright (C) 2014	Pilot <ricky@friendsconnect.nl>

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this license document, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

  0. You just DO WHAT THE FUCK YOU WANT TO.
--]]
server = {}
server.index = server


function server:isAccount(user)
	local acc = getAccount(user)
	if acc then
		return true
	end
	return false
end

function server:register(client,user,pass)
	if not self:isAccount(user) then
		local acc = addAccount(user, pass)
		if acc then
			message = "Account created."
			triggerClientEvent(client, "gui:modeToggle", getRootElement())
		else
			message = "ERROR: Consult admin!"
		end
	else
		message = "Username already exists!"
	end
	triggerClientEvent(client, "gui:warning", getRootElement(), message)
end

addEvent("server:register", true)
addEventHandler("server:register", getRootElement(), 
	function (user,pass)
		server:register(client, user, pass)
	end)

function server:login ( thePlayer, username, password )
	local account = getAccount ( username, password )-- Return the account
	local isPlayerLoggedIn = getAccountPlayer(getPlayerAccount(thePlayer))
		if ( account ~= false and not isElement(isPlayerLoggedIn) ) then -- If the account exists.
			local event = logIn ( thePlayer, account, password ) -- Log them in.
			if event then
				triggerClientEvent(thePlayer, "gui:warning", getRootElement(), "Successfully logged in!")
				triggerClientEvent(thePlayer, "gui:toggle", getRootElement())
			end
		elseif isElement(isPlayerLoggedIn) then
			triggerClientEvent(thePlayer, "gui:warning", getRootElement(), "You are already logged in.")
		else
			triggerClientEvent(thePlayer, "gui:warning", getRootElement(), "Wrong username or password!")
		end
end

addEvent("server:login", true)
addEventHandler("server:login", getRootElement(), 
	function (user,pass)
		server:login(client, user, pass)
	end)