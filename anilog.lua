local dupliCheck = {}
local index = 1
for i,v in pairs(game:GetDescendants()) do 
    if v:IsA("Animation") then 
        if v.AnimationId ~= nil and string.find(v.AnimationId,"rbxassetid://") then
            if not table.find(dupliCheck,v.AnimationId) then 
                rconsolewarn("Name = "..'"'..v.Name..'"'..", AnimationId = "..'"'..v.AnimationId..'"'..", Path = "..v:GetFullName())
                table.insert(dupliCheck,index,v.AnimationId)
                index += 1
            end
        end
    end
end

local consoleInput = rconsoleinput()
if consoleInput:lower() == "clear" then
    rconsoleclear()
    table.clear(dupliCheck)
    index = 1
end
