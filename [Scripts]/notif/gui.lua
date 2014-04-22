

--------------------------------------------
-- GUI data
-- table msg will change this data accordingly.
--------------------------------------------
local gui = {
	text = "",
	Y = -28,
}
local limit = 0
local stack = {
}
--------------------------------------------
-- Make absolute value compatible to 
-- the clients resolution.
--------------------------------------------
local x, y = guiGetScreenSize()
local function X( p )
    return p / 1366 * x
end
 
local function Y( p )
    return p / 768 * y
end

--------------------------------------------
-- Move text out of stack.
--------------------------------------------
local function popText()
	if #stack ~= 0 then
		table.remove(stack, 1)	-- Remove top element.
		return true
	end
	return false	-- Return false otherwise.
end

--------------------------------------------
-- Add text from message
-- onto the bottom of the stack.
--------------------------------------------
function appendText(text, r,g,b, delay)
	if stack then
		if text ~= nil and type(r,g,b) == "number" then
			local delay = delay or 1000
			table.insert(stack ,{text, r,g,b, delay})
			return true
		end
	end
	return false
end

addEvent("bar:message", true)
addEventHandler("bar:message",getRootElement(), appendText)

--------------------------------------------
-- Handle alerting
--------------------------------------------
function messageAlert(text, r,g,b, delay)
	if stack then
		if text ~= nil and type(r,g,b) == "number" then
			local delay = delay or 5000
			if #stack > 1 then
				table.insert(stack,1 , {text, r,g,b, delay})
				return true
			else
				table.insert(stack, {text, r,g,b, delay})
				return true
			end
		end
	end
	return false
end

addEvent("bar:alert", true)
addEventHandler("bar:alert", getRootElement(), messageAlert)

--------------------------------------------
-- Remove text and pop off of stack.
--------------------------------------------
function gui:remove()
	for i = 0, 150 do
		self.text = string.rep (" ", i)..self.text
	end
	popText()
end
--------------------------------------------
-- Hide the interface. 
--------------------------------------------

function gui:hide()
	self.Y = 0
	for i = 0, -280 do
		gui.Y = gui.Y - 0.1
	end
	self.visible = false
end

--------------------------------------------
-- Show interface
--------------------------------------------


function gui:show()
	self.Y = -28
	for i = -280, 0 do
		gui.Y = gui.Y + 0.1
	end
end 

addCommandHandler("toast", 
	function()
		appendText("HELLO",0,0,0,5000)
		appendText("#FF0000[WARNING]",0,0,0,1000)
		appendText("HELLO",0,0,0,2000)
	end)


--------------------------------------------
-- Build GUI.
--------------------------------------------
local it = 0
addEventHandler("onClientRender", root, 
	function()

			if #stack ~= 0 and gui.visible then
    			local tick = getTickCount()
    			if not delay then delay = stack[1][5] + tick end
        		gui.text = stack[1][1]
        		local r, g, b, a = stack[1][2], stack[1][3], stack[1][4], 255
        		local value = nil 
        		for i = 1, 2 do
        			--if i == 2 then value =  else value= gui.Y-(gui.Y*i) end
        			dxDrawRectangle(X(306), Y(gui.Y-(gui.Y*i)), X(756), Y(28), tocolor((25+r)/2, 25+g/2, 25+b/2, 100*i), false)
     				dxDrawText(gui.text, X(501), Y(gui.Y-(gui.Y*i)+i*28), X(874), Y(28), tocolor(255, 255, 255, a), 1.00, "default-bold", "center", "center", false, false, false, true, false)
     			end
    			if tick >= delay then
    				if #stack >= 2 then
    					if it < 150 then
    						gui.text = string.rep(" ", it)..gui.text
    						it = it + 1
    					else
    						delay = nil
    						it = 0
    						popText()
    					end
    				else
    					gui:remove()
    					delay = nil
    					gui.visible = false
    				end
    			end
    		elseif #stack ~= 0 then
    			gui.visible = true
    		end
    end)

