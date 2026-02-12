local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Unique storage to track Uchiha clan progress
local UCHIHA_JUTSU_STORAGE = 70002

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Kukuku... An interesting visitor. What brings you here?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        noQuest = "You're not worthy of my attention yet. Leave before I lose my patience.",
        hasQuest = "Ah... I can sense it. You were sent to {capture} me, weren't you? How amusing. The Uchiha clan still thinks they can control everything.",
        challenge = "Very well, little Uchiha. If you want to take me back, you'll have to {fight} me. But I warn you — this won't end the way you expect.",
        beforeBattle = "Let's see if that Sharingan of yours is more than just decoration. Come, show me the power of the Uchiha! Tell me when you're {ready to fight}.",
        defeat = "Kukuku... Impressive. You actually managed to corner me. But did you really think it would be that simple?",
        manipulation = "You see, |PLAYERNAME|, I didn't come here to fight seriously. I came to plant a {seed}. A seed of doubt, of curiosity... of power.",
        reveal = "The massacre of the Uchiha clan... Do you really know the {truth} behind it? Or do you just believe what they told you?",
        curse = "Your eyes... Such potential. But you lack the resolve to truly awaken them. Let me help you with that. Consider this... a {gift}.",
        curseMark = "This curse mark will remind you of our encounter. Perhaps it will help you see things more clearly. Or perhaps it will consume you. Kukuku...",
        escape = "Now, if you'll excuse me, I have more important matters to attend to. Tell Fugaku that capturing me was never really an option. The Uchiha should know better than anyone — true power comes from understanding the {darkness}.",
        
        -- ============================================
        -- OTHER CLANS MESSAGES (ADD HERE)
        -- ============================================
    },
    
    ["pt"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Kukuku... Um visitante interessante. O que você quer?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        noQuest = "Você não é digno da minha atenção ainda. Vá embora antes que eu perca a paciência.",
        hasQuest = "Ah... Posso sentir. Você foi enviado para me {capturar}, não foi? Que divertido. O clã Uchiha ainda acha que pode controlar tudo.",
        challenge = "Muito bem, pequeno Uchiha. Se quer me levar de volta, terá que {lutar} comigo. Mas eu te aviso — isso não vai terminar do jeito que você espera.",
        beforeBattle = "Vamos ver se esse Sharingan seu é mais que decoração. Venha, me mostre o poder dos Uchiha! Me diga quando estiver {pronto para lutar}.",
        defeat = "Kukuku... Impressionante. Você realmente conseguiu me encurralar. Mas achou mesmo que seria tão simples assim?",
        manipulation = "Veja bem, |PLAYERNAME|, eu não vim aqui para lutar seriamente. Vim para plantar uma {semente}. Uma semente de dúvida, de curiosidade... de poder.",
        reveal = "O massacre do clã Uchiha... Você realmente conhece a {verdade} por trás disso? Ou apenas acredita no que te contaram?",
        curse = "Seus olhos... Tanto potencial. Mas falta a determinação para realmente despertá-los. Deixe-me ajudá-lo com isso. Considere isto... um {presente}.",
        curseMark = "Esta marca amaldiçoada vai te lembrar do nosso encontro. Talvez te ajude a ver as coisas mais claramente. Ou talvez te consuma. Kukuku...",
        escape = "Agora, se me der licença, tenho assuntos mais importantes. Diga ao Fugaku que me capturar nunca foi realmente uma opção. Os Uchiha deveriam saber melhor que ninguém — o verdadeiro poder vem de compreender a {escuridão}.",
        
        -- ============================================
        -- OTHER CLANS MESSAGES (ADD HERE)
        -- ============================================
    }
}

local validWords = {
    ["pt"] = {"capturar", "lutar", "pronto para lutar", "sim", "semente", "verdade", "presente", "escuridão"},
    ["en"] = {"capture", "fight", "ready to fight", "yes", "seed", "truth", "gift", "darkness"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local currentLang = npcHandler.languages[cid] or "pt"
    
    npcHandler:addFocus(cid)
    
    -- ============================================
    -- GENERIC GREETING (FOR ALL PLAYERS)
    -- ============================================
    if msgcontains(msgLower, "hi") or msgcontains(msgLower, "oi") then
        npcHandler:say(messages[currentLang].greet, cid)
        return true
    end
    -- ============================================
    -- END GENERIC GREETING
    -- ============================================
    
    -- Block messages outside the defined language
    local isValid = false
    for _, word in ipairs(validWords[currentLang]) do
        if string.find(msgLower, string.lower(word)) then
            isValid = true
            break
        end
    end
    if not isValid then
        return true
    end
    
    -- ============================================
    -- UCHIHA CLAN QUEST FLOW (vocationId == 9)
    -- ============================================
    if player:getVocation():getId() == 9 then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Check if has the quest
        if uchihaJutsu < 7 then
        npcHandler:say(messages[currentLang].noQuest, cid)
        npcHandler:releaseFocus(cid)
        return true
    end
    
    -- Quest flow (Storage 7)
    if msgcontains(msgLower, "capturar") or msgcontains(msgLower, "capture") then
        npcHandler:say(messages[currentLang].hasQuest, cid)
        npcHandler.topic[cid] = 1
        return true
    end
    
    if (msgcontains(msgLower, "lutar") or msgcontains(msgLower, "fight") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 1 then
        npcHandler:say(messages[currentLang].beforeBattle, cid)
        npcHandler.topic[cid] = 2
        return true
    end
    
    if (msgcontains(msgLower, "pronto para lutar") or msgcontains(msgLower, "ready to fight") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 2 then
        -- Here you would implement the fight with Orochimaru
        -- For now, simulates that the player won
        npcHandler:say(messages[currentLang].defeat, cid)
        npcHandler.topic[cid] = 3
        
        -- Continue the dialogue automatically after a few seconds
        addEvent(function()
            if Player(cid) then
                npcHandler:say(string.gsub(messages[currentLang].manipulation, "|PLAYERNAME|", player:getName()), cid)
                npcHandler.topic[cid] = 4
            end
        end, 3000)
        return true
    end
    
    if (msgcontains(msgLower, "semente") or msgcontains(msgLower, "seed")) and npcHandler.topic[cid] == 4 then
        npcHandler:say(messages[currentLang].reveal, cid)
        npcHandler.topic[cid] = 5
        return true
    end
    
    if (msgcontains(msgLower, "verdade") or msgcontains(msgLower, "truth")) and npcHandler.topic[cid] == 5 then
        npcHandler:say(messages[currentLang].curse, cid)
        npcHandler.topic[cid] = 6
        return true
    end
    
    if (msgcontains(msgLower, "presente") or msgcontains(msgLower, "gift")) and npcHandler.topic[cid] == 6 then
        npcHandler:say(messages[currentLang].curseMark, cid)
        -- Here you could add a visual effect or temporary debuff
        player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
        npcHandler.topic[cid] = 7
        
        addEvent(function()
            if Player(cid) then
                npcHandler:say(messages[currentLang].escape, cid)
                npcHandler.topic[cid] = 8
            end
        end, 3000)
        return true
    end
    
    if (msgcontains(msgLower, "escuridão") or msgcontains(msgLower, "darkness")) and npcHandler.topic[cid] == 8 then
        -- Check if has the ryo (ID: 10549) for testing
        if player:getItemCount(10549) < 1 then
            npcHandler:say("Kukuku... You need to bring me a ryo first. (Testing purposes)", cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Remove the ryo and complete the mission
        player:removeItem(10549, 1)
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 8) -- Completed encounter with Orochimaru
        player:save()
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        -- Here you would make Orochimaru disappear/teleport and the player be expelled from the hideout
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    return true
    -- ============================================
    -- END UCHIHA CLAN QUEST FLOW
    -- ============================================
    
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
