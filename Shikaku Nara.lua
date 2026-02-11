local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Unique storage to track learned jutsus
-- Storage = 0: Learned Kage no Hou Jutsu (When becoming Nara)
-- Storage >= 1: Learned Kagemane no Jutsu (lvl 40)
-- Storage >= 2: Learned Kage Nui no Jutsu (lvl 80)
-- Storage >= 3: Learned Kage Kubi Shibari no Jutsu (lvl 120 + graduated)
-- Storage >= 4: Learned Kage Tsukami no Jutsu (lvl 150 + graduated)
local NARA_JUTSU_STORAGE = 70007

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "{Nara}",
        noLvl = "{level 5}",
        askNara = "{become}",
        confirm = "{join}",
        done = "{Kage no Hou Jutsu}",
        isNara = "{brings}",
        hasOtherClan = "",

        noLvlQuest1 = "{level 40}",
        quest1 = "{learn Kagemane no Jutsu}",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kagemane no Jutsu.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kagemane no Jutsu.",
        quest1Done = "",

        noLvlQuest2 = "{level 80}",
        quest2 = "{learn Kage Nui no Jutsu}",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Nui no Jutsu.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Nui no Jutsu.",
        quest2Done = "",

        noLvlQuest3 = "{level 120} {graduated}",
        quest3 = "{learn Kage Kubi Shibari no Jutsu}",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Kubi Shibari no Jutsu.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Kubi Shibari no Jutsu.",
        quest3Done = "",

        noLvlQuest4 = "{level 150} {graduated}",
        quest4 = "{learn Kage Tsukami no Jutsu}",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Tsukami no Jutsu.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Tsukami no Jutsu.",
        quest4Done = "",
        
        alreadyLearnedKagemane = "You have already learned Kagemane no Jutsu from me.",
        alreadyLearnedKageNui = "You have already learned Kage Nui no Jutsu from me.",
        alreadyLearnedKageKubiShibari = "You have already learned Kage Kubi Shibari no Jutsu from me.",
        alreadyLearnedKageTsukami = "You have already learned Kage Tsukami no Jutsu from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "{Nara}",
        noLvl = "{level 5}",
        askNara = "{tornar}",
        confirm = "{fazer parte}",
        done = "{Kage no Hou Jutsu}",        
        isNara = "{traz}",
        hasOtherClan = "",

        noLvlQuest1 = "{level 40}",
        quest1 = "{aprender Kagemane no Jutsu}",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kagemane no Jutsu.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kagemane no Jutsu.",
        quest1Done = "",

        noLvlQuest2 = "{level 80}",
        quest2 = "{aprender Kage Nui no Jutsu}",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Nui no Jutsu.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Nui no Jutsu.",
        quest2Done = "",

        noLvlQuest3 = "{level 120} {graduar}",
        quest3 = "{aprender Kage Kubi Shibari no Jutsu}",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Kubi Shibari no Jutsu.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Kubi Shibari no Jutsu.",
        quest3Done = "",

        noLvlQuest4 = "{level 150} {graduado}",
        quest4 = "{aprender Kage Tsukami no Jutsu}",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Tsukami no Jutsu.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Tsukami no Jutsu.",
        quest4Done = "",

        alreadyLearnedKagemane = "Você já aprendeu Kagemane no Jutsu de mim.",
        alreadyLearnedKageNui = "Você já aprendeu Kage Nui no Jutsu de mim.",
        alreadyLearnedKageKubiShibari = "Você já aprendeu Kage Kubi Shibari no Jutsu de mim.",
        alreadyLearnedKageTsukami = "Você já aprendeu Kage Tsukami no Jutsu de mim.",
        allTechniques = "Você dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "nara", "tornar", "fazer parte", "traz", "aprender kagemane no jutsu", "aprender kage nui no jutsu", "aprender kage kubi shibari no jutsu", "aprender kage tsukami no jutsu"},
    ["en"] = {"help", "nara", "become", "join", "brings", "learn kagemane no jutsu", "learn kage nui no jutsu", "learn kage kubi shibari no jutsu", "learn kage tsukami no jutsu"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local naraVocationId = 14
    local playerVocation = player:getVocation():getId()
    local currentLang = npcHandler.languages[cid] or "pt" -- default language pt

    npcHandler:addFocus(cid)

    -- Bloquear mensagens fora do idioma definido
    local isValid = false
    for _, word in ipairs(validWords[currentLang]) do
        if msgcontains(msgLower, word) then
            isValid = true
            break
        end
    end
    if not isValid then
        return true
    end

    -- Comandos de ajuda
    if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Fluxo Uchiha
    if msgcontains(msgLower, "nara") then
        if playerVocation ~= 0 and playerVocation ~= naraVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == naraVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isNara, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askNara, cid)
            npcHandler.topic[cid] = 1
            return true
        end
    end

    -- Confirmation flow
    if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become")) then
        if player:getLevel() < 5 then
            npcHandler:say(messages[currentLang].noLvl, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler:say(messages[currentLang].confirm, cid)
        npcHandler.topic[cid] = 2
        return true
    elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join")) then
        player:setVocation(Vocation(naraVocationId))
        player:save()
        player:setOutfit({lookType = 430})
        player:addOutfit(430)
        player:learnSpell("Kage no Hou Jutsu")
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Check which jutsu the player can learn
    if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
        if playerVocation ~= naraVocationId then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        local naraJutsu = player:getStorageValue(NARA_JUTSU_STORAGE)
        if naraJutsu == -1 then
            naraJutsu = 0
        end
        
        -- Determine which is the next jutsu based on storage
        if naraJutsu == 0 then
            if player:getLevel() < 40 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif naraJutsu == 1 then
            if player:getLevel() < 80 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif naraJutsu == 2 then
            if player:getLevel() < 100 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif naraJutsu == 3 then
            if player:getLevel() < 120 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
            else
                npcHandler:say(messages[currentLang].quest4, cid)
                npcHandler.topic[cid] = 40
            end
        else
            npcHandler:say(messages[currentLang].allTechniques, cid)
        end
        return true
    end

    -- Learn Kagemane no Jutsu
    if msgcontains(msgLower, "learn kagemane no jutsu") or msgcontains(msgLower, "aprender kagemane no jutsu") then
        local naraJutsu = player:getStorageValue(NARA_JUTSU_STORAGE)
        if naraJutsu == -1 then
            naraJutsu = 0
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
        end
        
        if naraJutsu >= 1 then
            npcHandler:say(messages[currentLang].alreadyLearnedKagemane, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kagemane no Jutsu")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARA_JUTSU_STORAGE, 1)
        player:save()
        npcHandler:say(messages[currentLang].quest1Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Kage Nui no Jutsu
    if msgcontains(msgLower, "learn kage nui no jutsu") or msgcontains(msgLower, "aprender kage nui no jutsu") then
        local naraJutsu = player:getStorageValue(NARA_JUTSU_STORAGE)
        if naraJutsu == -1 then
            naraJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if naraJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearnedKageNui, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kage Nui no Jutsu")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARA_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Kage Kubi Shibari no Jutsu
    if msgcontains(msgLower, "learn kage kubi shibari no jutsu") or msgcontains(msgLower, "aprender kage kubi shibari no jutsu") then
        local naraJutsu = player:getStorageValue(NARA_JUTSU_STORAGE)
        if naraJutsu == -1 then
            naraJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if naraJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedKageKubiShibari, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kage Kubi Shibari no Jutsu")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARA_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Kage Tsukami no Jutsu
    if msgcontains(msgLower, "learn kage tsukami no jutsu") or msgcontains(msgLower, "aprender kage tsukami no jutsu") then
        local naraJutsu = player:getStorageValue(NARA_JUTSU_STORAGE)
        if naraJutsu == -1 then
            naraJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if naraJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearnedKageTsukami, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kage Tsukami no Jutsu")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARA_JUTSU_STORAGE, 4)
        player:save()
        npcHandler:say(messages[currentLang].quest4Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
