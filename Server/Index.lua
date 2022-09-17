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

Player.Subscribe("Spawn", function(player)
    MySQL:Select("SELECT * FROM players WHERE steam = "..player:GetSteamID(), function(rows)
        if #rows <= 0 then

            MySQL:Execute([[
            INSERT INTO `players` (`steam`,`rank`) VALUES (?,?)]], function()
                xPlayer[player:GetSteamID()] = {
                    steam = player:GetSteamID(),
                }
                SpawnCharacter(player, 0, 0, 50)
            end, player:GetSteamID(),'user')
            print('New player '..player:GetName())

        else
            for k,v in pairs(rows) do
                xPlayer[player:GetSteamID()] = {
                    steam = player:GetSteamID(),
                }
                SpawnCharacter(player, v.position_x, v.position_y, v.position_z)
                print('Existing player '..player:GetName())
            end
        end
    end)
end)

Player.Subscribe("Destroy", function(player)
    local character = player:GetControlledCharacter()
    print(character)

    MySQL:Execute([[UPDATE players SET position_x=(?),position_y=(?),position_z=(?) WHERE steam=(?)]], function(_, sError)
      if sError then print( sError ) end
    end, math.ceil(character:GetLocation().X), math.ceil(character:GetLocation().Y), math.ceil(character:GetLocation().Z), player:GetSteamID())

    if (character) then
        character:Destroy()
    end
end)