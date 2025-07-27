-- Animation system (timeline-based)
-- component list
pkd = {}
-- steps pointers and time delay counter
si,t=1,0
-- timeline schedule
-- every "step" means execute the next step in steps
-- this is a simple timeline example which means that execute one step, wait 2*30 frames, then execute the next step
tm = {"step",2,"step"}
-- a steps stack
-- each step is a list of actions
-- each action is a list of parameters:
-- {object_id, x_offset, y_offset, speed, easing_function, sound_effect}
-- object_id is the index in pkd, x_offset and y_offset are relative to the current position,
-- speed is the progress increment per frame (0 to 1), easing_function is a function that takes progress (0 to 1) and returns a value (0 to 1),
-- sound_effect is the index of the sound effect to play (0 means no sound)
steps = {
	{
	    {16,0,100,0.5,eins,2}
	},
	{
	    {15,60,-60,0.5,eout,1},
		{7,60,-60,0.5,eout,1}
	},
}

-- Create object
function crt(id,typa,x,y,w,h,c,v,l,s)
    -- Build an object representing a rectangle or sprite
    local obj = {
        id = id or #pkd+1,      -- unique ID
        t = typa,               -- Type ("rectangle" or "sprite")
        x = x, y = y,           -- Current position
        x1 = x, y1 = y,         -- Start position
        x2 = x, y2 = y,         -- Target position (set in steps declaration)
        w = w, h = h,           -- Width and height
        c = c,                  -- Color or other custom data
        v = v,                  -- Speed (progress increment per frame)
        mov = lin,              -- Default easing function
        layer = l or 1,         -- Layer (defines rendering order)
        ospr = s or 0,          -- Sprite sheet index (default 0)
        p = 0                   -- Progress (0 to 1)
    }
    add(pkd, obj)
end

-- example of creating objects using crt function
--  crt(id, typ ,x  ,y  ,w  ,h  ,c  ,v ,l ,s) 		name         index  notes
	crt(1 ,"rec",17 ,32 ,94 ,58 ,4  ,1 ,1)    		 --box 			1
	crt(2 ,"rec",22 ,35 ,86 ,52 ,7  ,1 ,1)			 --card  		2
	crt(3 ,"rec",17 ,31 ,94 ,55 ,9  ,1 ,1)			 --case			3
	crt(7 ,"spr",24 ,36 ,2  ,3  ,15 ,1 ,1 ,4) 		 --tagshader	7    --spr
	crt(15,"spr",24 ,35 ,2  ,3  ,15 ,1 ,2 ,2)		 --tag			15   --spr
	crt(16,"rec",32 ,110,1  ,1  ,1  ,1 ,4) 		 	 --hint        	16
end

-- Execute all actions in the current step
-- This function iterates through the current step's actions and applies them to the objects
-- It sets the start and target positions, speed, easing function, and plays sound effects
-- many actions can be executed in one step
function exe()
    for s in all(steps[si]) do
        local o = pkd[s[1]]
        o.x1, o.y1 = o.x, o.y             -- Set start position
        o.x2, o.y2 = s[2]+o.x2, s[3]+o.y2 -- Set target position (relative)
        o.mov = s[5]                      -- Set easing function
        o.p = 0                           -- Reset progress
        sfx(s[6])                         -- Play sound effect
        if s[4]>1 then s[4]=1 end         -- Cap max speed to 1
        o.v=s[4]                          -- Set speed
    end
end

-- Update timeline logic
-- This function executes the current node in the timeline
function upd_tm()
    if #tm == 0 then return end          -- Skip if timeline is empty
    local cur = tm[1]                    -- Get current node in timeline
    if type(cur) == "number" then        -- If current node is a number, it's a delay
        t += 1 / 30                      -- Time step (30 fps)
        if t >= cur then
        t = 0
        deli(tm, 1)                      -- pop current node in timeline
    end
    elseif cur == "step" then            -- If current node is a step
        exe()                            -- Execute step
        si += 1                          -- Step index increment
        deli(tm, 1)                      -- pop current step node in timeline
    end
end

-- Update position of a single object
-- This function moves an object based on its speed and easing function
-- It updates the object's position and checks if the animation is complete
-- it always been called in the main loop
function mov(o)
    o.p += o.v / 30                   -- Progress per frame (30 fps)
    if o.p > 1 then o.p = 1 end       -- Clamp to 1
    local t = o.mov(o.p)              -- Apply easing function
    o.x = o.x1 + (o.x2 - o.x1) * t    -- Interpolate x
    o.y = o.y1 + (o.y2 - o.y1) * t    -- Interpolate y
    return o.p >= 1                   -- Return whether animation is done
end

-- Check if all animations are done
function all_steps_finished()
    if #tm > 0 then return false end            -- Timeline not empty
        for obj in all(pkd) do
            if obj.p < 1 then return false end  -- Still animating
        end
    return true
end

--
function maincontrol_up()
	upd_tm()                -- Update timeline logic
	local done = true       -- Assume all animations are done
    -- Iterate through all objects and move them，the movement always happens in the main loop
	for o in all(pkd) do    -- Iterate through all objects
		if not mov(o) then  -- Move object and check if animation is done
	 		done = false    -- If any object is not done, set done to false
		end
 	end
 	--out animation logic
 	if all_steps_finished() == true then    -- If all steps are finished
		-- your next step logic here
        -- for example, you can reset the timeline or start a new animation
	end
end

-- Draw all components
-- It sorts them by layer attribute and draws rectangles, sprites, and print texts
-- You can change the texts and visibility of elements by modifying the hide table
-- The hide table allows you to hide specific elements by their ID
-- Set hide[id] to true to hide the element with that ID
function drawcomponents()
    -- these are texts examples, you can change them to your own
	local co = "line one \nline two\nline three"
	local h1 = "Hello, world!\nThis is a simple\nanimation system"
	local h2 = "Who are you?"
	local mask = false
    -- if you want to hide some elements, set them to true
	hide={[7]=false,[15]=false,[8]=mask,[9]=true,[10]=mask,[11]=mask,[16]=false}

	-- put elements in new list
    local sorted_pkd = {}
    for o in all(pkd) do
        add(sorted_pkd,o)
    end
    -- bubble sort by layer
    -- this is not the most efficient way, but it is simple and works for small lists
    for i = 1, #sorted_pkd - 1 do
        for j = 1, #sorted_pkd - i do
            if sorted_pkd[j].layer>sorted_pkd[j+1].layer then
                sorted_pkd[j],sorted_pkd[j+1]=sorted_pkd[j+1],sorted_pkd[j]
            end
        end
    end
    -- Rendering
    for obj in all(sorted_pkd) do
        if not hide[obj.id] then
            -- draw the rectangle
            if obj.t == "rec" then
                rectfill(obj.x,obj.y,obj.x+obj.w,obj.y+obj.h, obj.c)
            end
            -- draw the sprite
            if obj.t == "spr" then
                spr(obj.ospr, obj.x, obj.y, obj.w,obj.h)
            -- print the text one these
            elseif obj.id == 3 then
                print("fROM \n   gEORGE",obj.x+55,obj.y+40,4)
            elseif obj.id == 16 then
                print(h1,obj.x,obj.y,4)
            elseif obj.id == 18 then
                print(h2,obj.x,obj.y,4)
            end
        end
    end
    end
end

-- Easing functions for moves
function lin(t) return t end                                -- Linear
function ein(t) return t*t end                              -- Ease-in (quadratic)
function eout(t) t -= 1 return 1 - t*t end                  -- Ease-out (quadratic)
function eins(t) return 2.7*t*t*t-1.7*t*t end               -- Custom cubic in
function eouts(t) t-=1 return 1+2.7*t*t*t+1.7*t*t end       -- Custom cubic out
function eine(t)                                            -- Exponential ease-in + cosine shake
    if(t==0) return 0
        return 2^(10*t-10)*cos(2*t-2)
end
function eoute(t)                                           -- Exponential ease-out + cosine shake
    if(t==1) return 1
    return 1-2^(-10*t)*cos(2*t)
end
function inbounce(t)                                        -- Bounce-in effect (inverse of out-bounce)
    t=1-t local n1=7.5625 local d1=2.75
    if(t<1/d1) return 1-n1*t*t
    t-=1.5/d1 if(t<1/d1) return 1-n1*t*t-.75
    t-=.75/d1 if(t<1/d1) return 1-n1*t*t-.9375
    t-=.375/d1 return 1-n1*t*t-.984375
end