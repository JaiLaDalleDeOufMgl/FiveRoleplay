Package.Log("Loading Five RôlePlay Server")

local xPlayer = {}

local MySQL = Database(DatabaseEngine.SQLite, "db=five-roleplay.db timeout=2")

MySQL:Execute([[
    CREATE TABLE IF NOT EXISTS players (
    steam VARCHAR(255) PRIMARY KEY,
    rank TEXT DEFAULT "user" NOT NULL,
    position_x INTEGER,
    position_y INTEGER,
    position_z INTEGER
)]])

function SpawnCharacter(player, x, y, z)
    local new_character = Character(Vector(x,y,z), 0)
    player:Possess(new_character)
end

Player.Subscribe("Spawn", function()
    for k, player in pairs(Player.GetAll()) do
        MySQL:Select("SELECT * FROM players WHERE steam = "..player:GetSteamID(), function(rows)
            if #rows <= 0 then
    
                MySQL:Execute([[
                INSERT INTO `players` (`steam`,`rank`) VALUES (?,?)]], function()
                    xPlayer[player:GetSteamID()] = {
                        steam = player:GetSteamID(),
                        position = {}
                    }
                    SpawnCharacter(player, 0, 0, 50)
                end, player:GetSteamID(),'user')
    
            else
                for k,v in pairs(rows) do
                    xPlayer[player:GetSteamID()] = {
                        steam = player:GetSteamID(),
                        position_x = v.position_x,
                        position_y = v.position_y,
                        position_z = v.position_z
                    }
                    SpawnCharacter(player, v.position_x, v.position_y, v.position_z)
                end
            end
        end)
    end
end)

Player.Subscribe("Destroy", function(player)
    local character = player:GetControlledCharacter()
    if (character) then
        character:Destroy()
    end
end)

Server.Subscribe("Tick", function()
    for k, player in pairs(Player.GetAll()) do
        local character = player:GetControlledCharacter()
        if (character) then
            if xPlayer[player:GetSteamID()] then
                xPlayer[player:GetSteamID()].position_x = character:GetLocation().X
                xPlayer[player:GetSteamID()].position_y = character:GetLocation().Y
                xPlayer[player:GetSteamID()].position_z = character:GetLocation().Z
                MySQL:Execute([[UPDATE players SET position_x=(?),position_y=(?),position_z=(?) WHERE steam=(?)]], function()
                end, character:GetLocation().X, character:GetLocation().Y, character:GetLocation().Z + 50, player:GetSteamID())
            end
        end
    end
end)