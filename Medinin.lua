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
        greet = "Field Medic Unit. State your objective.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        noQuest = "No authorization found for your participation in this simulation.",
        hasQuest = "Authorization confirmed from Tsunade. This survival trial forbids attacking. You must remain in position and manage your healing under pressure. Tell me when you're {ready}.",
        failItem = "Simulation seal requires one ryo to initialize. (Testing purposes)",
        success = "Trial complete. You endured the pressure window. Report back to Mebuki.",
        retry = "Failure in this simulation means loss of battlefield awareness. Regain focus and tell me when you're {ready} again.",
        alreadyCompleted = "You already completed this simulation. Return to Mebuki.",
    },
    ["pt"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Unidade Médica de Campo. Informe seu objetivo.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        noQuest = "Nenhuma autorização encontrada para sua participação nesta simulação.",
        hasQuest = "Autorização confirmada pela Tsunade. Este teste de sobrevivência proíbe atacar. Você deve permanecer na posição e controlar sua cura sob pressão. Me avise quando estiver {pronto}.",
        failItem = "O selo da simulação exige um ryo para inicializar. (Testing purposes)",
        success = "Teste concluído. Você suportou a janela de pressão. Reporte para a Mebuki.",
        retry = "Falhar nesta simulação significa perder leitura de batalha. Refoque e me diga quando estiver {pronto} novamente.",
        alreadyCompleted = "Você já concluiu esta simulação. Volte para a Mebuki.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "pronto", "sim"},
    ["en"] = {"help", "ready", "yes"}
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

        if harunoJutsu < 4 then
            npcHandler:say(messages[currentLang].noQuest, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        if harunoJutsu >= 5 then
            npcHandler:say(messages[currentLang].alreadyCompleted, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "pronto") or msgcontains(msgLower, "ready") then
            npcHandler:say(messages[currentLang].hasQuest, cid)
            npcHandler.topic[cid] = 1
            return true
        end

        if (msgcontains(msgLower, "pronto") or msgcontains(msgLower, "ready") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 1 then
            if player:getItemCount(10549) < 1 then
                npcHandler:say(messages[currentLang].failItem, cid)
                npcHandler.topic[cid] = 100
                return true
            end

            player:removeItem(10549, 1)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 5)
            player:save()
            npcHandler:say(messages[currentLang].success, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if npcHandler.topic[cid] == 100 and (msgcontains(msgLower, "pronto") or msgcontains(msgLower, "ready") or msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help")) then
            npcHandler:say(messages[currentLang].retry, cid)
            npcHandler.topic[cid] = 1
            return true
        end

        return true
    end
    -- ============================================
    -- END HARUNO CLAN QUEST FLOW
    -- ============================================

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
