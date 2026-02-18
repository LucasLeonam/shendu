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
        greet = "Doton Jounnin on guard. Identify yourself.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        noQuest = "You don't have operation clearance for this cave route.",
        hasQuest = "Mebuki sent you. Good. I've sealed the cave entrance, but civilians are trapped while enemy waves keep pushing inside. I can open the barrier and send you in. Are you {ready} to defend them?",
        plan = "Once you're inside, I close the barrier behind you. Enemies come in waves through three lanes. Don't let them reach the civilians.",
        failItem = "I need one ryo to stabilize the earth seal before opening the barrier. (Testing purposes)",
        success = "Barrier opening complete. Operation recorded as successful. Return to Mebuki.",
        alreadyCompleted = "You've already completed this cave defense operation.",
    },
    ["pt"] = {
        -- ============================================
        -- GENERIC MESSAGES (FOR ALL PLAYERS)
        -- ============================================
        greet = "Doton Jounnin de guarda. Identifique-se.",

        -- ============================================
        -- HARUNO CLAN MESSAGES
        -- ============================================
        noQuest = "Você não possui autorização para operar nesta rota da caverna.",
        hasQuest = "A Mebuki te enviou. Ótimo. Eu selei a entrada da caverna, mas há civis presos enquanto ondas inimigas seguem avançando por dentro. Posso abrir a barreira e te lançar lá. Está {pronto} para defender eles?",
        plan = "Quando você entrar, eu fecho a barreira atrás de você. Os inimigos virão em waves por três rotas. Não deixe alcançarem os civis.",
        failItem = "Preciso de um ryo para estabilizar o selo de terra antes de abrir a barreira. (Testing purposes)",
        success = "Abertura de barreira concluída. Operação registrada como sucesso. Volte para a Mebuki.",
        alreadyCompleted = "Você já concluiu esta operação de defesa da caverna.",
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

        if harunoJutsu < 7 then
            npcHandler:say(messages[currentLang].noQuest, cid)
            npcHandler:releaseFocus(cid)
            return true
        end

        if harunoJutsu >= 8 then
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
            npcHandler:say(messages[currentLang].plan, cid)
            npcHandler.topic[cid] = 2
            return true
        end

        if (msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes") or msgcontains(msgLower, "pronto") or msgcontains(msgLower, "ready")) and npcHandler.topic[cid] == 2 then
            if player:getItemCount(10549) < 1 then
                npcHandler:say(messages[currentLang].failItem, cid)
                return true
            end

            player:removeItem(10549, 1)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 8)
            player:save()
            npcHandler:say(messages[currentLang].success, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
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
