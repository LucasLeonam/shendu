local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local HARUNO_JUTSU_STORAGE = 70003

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Hello |PLAYERNAME|. I've placed a bet with Kakashi that no one would talk to me today. It seems I've lost. Again.",
        
        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================

        help = "",


        noQuest = "I have no orders for you right now. Continue your training.",
        quest2Intro = "Mebuki told me about you. If you want to endure the front line, you'll stop relying on panic healing. You'll face a pressure simulation with the field medic unit. Ready for {training}?",
        quest2Start = "Good. Talk to the {Medinin}. They control the battlefield simulation where you must stand your ground under continuous attack.",
        quest2Done = "You completed my endurance trial. Return to Mebuki. She's the one who will finalize your next technique.",

        quest4Intro = "So you've reached this far. This final test is simple: hold the central line while chaos collapses around you, and strike only at the decisive moment. Are you {ready for the final line}?",
        quest4FailItem = "Bring one ryo so I can initialize the combat seal matrix. (Testing purposes)",
        quest4Done = "You held the line until the decisive blow. That's enough. Return to Mebuki and claim what you earned.",

        alreadyCompleted = "You've already completed what I needed from you.",
    },
    ["pt"] = {
        
    }
}

local validWords = {
    ["pt"] = {"treinamento", "medinin", "pronto para a última linha", "sim", "ajudar"},
    ["en"] = {"training", "medinin", "ready for the final line", "yes", "help"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local currentLang = npcHandler.languages[cid] or "pt"

    npcHandler:addFocus(cid)

    if msgcontains(msgLower, "hi") or msgcontains(msgLower, "oi") then
        npcHandler:say(messages[currentLang].greet, cid)
        return true
    end

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
    -- HARUNO CLAN QUEST FLOW
    -- ============================================
    if player:getVocation():getId() == 11 then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu == 4 then
            if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "treinamento") or msgcontains(msgLower, "training") then
                npcHandler:say(messages[currentLang].quest2Intro, cid)
                npcHandler.topic[cid] = 1
                return true
            end

            if (msgcontains(msgLower, "treinamento") or msgcontains(msgLower, "training") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 1 then
                npcHandler:say(messages[currentLang].quest2Start, cid)
                npcHandler:releaseFocus(cid)
                npcHandler.topic[cid] = 0
                return true
            end

            return true
        end

        if harunoJutsu == 5 then
            npcHandler:say(messages[currentLang].quest2Done, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        if harunoJutsu == 10 then
            if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "pronto para a última linha") or msgcontains(msgLower, "ready for the final line") then
                npcHandler:say(messages[currentLang].quest4Intro, cid)
                npcHandler.topic[cid] = 2
                return true
            end

            if (msgcontains(msgLower, "pronto para a última linha") or msgcontains(msgLower, "ready for the final line") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 2 then
                if player:getItemCount(10549) < 1 then
                    npcHandler:say(messages[currentLang].quest4FailItem, cid)
                    return true
                end

                player:removeItem(10549, 1)
                player:setStorageValue(HARUNO_JUTSU_STORAGE, 11)
                player:save()
                npcHandler:say(messages[currentLang].quest4Done, cid)
                npcHandler:releaseFocus(cid)
                npcHandler.topic[cid] = 0
                return true
            end

            return true
        end

        if harunoJutsu >= 11 then
            npcHandler:say(messages[currentLang].alreadyCompleted, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        npcHandler:say(messages[currentLang].noQuest, cid)
        npcHandler:releaseFocus(cid)
        return true
    end
    -- ============================================
    -- END HARUNO CLAN QUEST FLOW
    -- ============================================

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
