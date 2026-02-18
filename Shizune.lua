local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local HARUNO_JUTSU_STORAGE = 70003
local GLOVE_ITEM_ID = 10572

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Shizune here. If you're not bleeding, then speak quickly.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        help = "I'm glad you came. I need your help to {treat} some patients. Just control your chakra flow and don't kill anyone, ok? ",
        startTreatment = "The treatment is kinda simple. Go to the room at the end of the hall. You'll see 3 patients that need your help. Use this glove for the healing purposes. It has Shousen Jutsu inscribed on it, but you need to control the chakra flow through the glove.",
        failTreatment = "Good job, |PLAYERNAME|. You just killed a patient. I was told that you would help me, not kill people. Give my glove back, will you? Just try to control your chakra flow next time, ok? We still have a lot of patients to treat, so I hope I can count on you again, but please, be more careful next time. Do you want to {retry} helping me?",
        completeTreatment = "Good work, |PLAYERNAME|. You treated all patients successfully. I will send a word to Mebuki about your performance. Thank you again for your help. I'm getting my glove back, because other ninjas will need it to treat the patients if needed.",
        alreadyCompleted = "You already helped me treating the patients. I don't need any more help right now. Have you already reported to Mebuki?",
    },
    ["pt"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Shizune aqui. Se você não está sangrando, seja direto.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        
    }
}

local validWords = {
    ["pt"] = {"ajudar", "hospital", "paciente crítico", "estabilizar", "sim"},
    ["en"] = {"help", "yes", "treat", "retry", "mission"}
}

local function giveGlove(player)
    if player:getItemCount(GLOVE_ITEM_ID) < 1 then
        player:addItem(GLOVE_ITEM_ID, 1)
    end
end

local function removeGlove(player)
    if player:getItemCount(GLOVE_ITEM_ID) > 0 then
        player:removeItem(GLOVE_ITEM_ID, player:getItemCount(GLOVE_ITEM_ID))
    end
end

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

        if harunoJutsu < 1 then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        if harunoJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyCompleted, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        -- Handle RETRY from failed treatment
        if msgcontains(msgLower, "retry") and npcHandler.topic[cid] == 99 then
            npcHandler:say(messages[currentLang].startTreatment, cid)
            giveGlove(player)
            npcHandler.topic[cid] = 2
            return true
        end

        if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "mission") then
            -- If saying "mission" and already in treatment stage, check for ryo
            if msgcontains(msgLower, "mission") and npcHandler.topic[cid] == 2 then
                if player:getItemCount(10549) < 1 then
                    npcHandler:say("You need to bring me a ryo to complete this test. (Testing purposes)", cid)
                    return true
                end
                
                player:removeItem(10549, 1)
                npcHandler:say(messages[currentLang].completeTreatment, cid)
                player:setStorageValue(HARUNO_JUTSU_STORAGE, 2)
                removeGlove(player)
                npcHandler:releaseFocus(cid)
                return true
            end
            
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 1
            return true
        end

        if (msgcontains(msgLower, "yes") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "treat")) and npcHandler.topic[cid] == 1 then
            npcHandler:say(messages[currentLang].startTreatment, cid)
            giveGlove(player)
            npcHandler.topic[cid] = 2
            return true
        end

        -- Here would have the logic for failed treatment, but I don't know how to code this, so there's no way to fail right now.

        return true
    end
    -- ============================================
    -- END HARUNO CLAN QUEST FLOW
    -- ============================================

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
