local USUARIO = "_USER_"
local relay = peripheral.find("redstone_relay")
local chaty = peripheral.find("chat_box")
while true do
    local event, user, device = os.pullEvent("playerClick")
    if user == USUARIO then
        relay.setOutput("top",true)
        sleep(3)
        relay.setOutput("top",false)
    else
        chaty.sendMessageToPlayer("Te intentan robar, calva",USUARIO,os.getComputerLabel(),"<>","&6")
    end
end
