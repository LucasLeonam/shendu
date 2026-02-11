local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Unique storage to track learned jutsus
-- Storage = 0: Learned Hakkeshou Kaiten (When becoming Hyuuga)
-- Storage >= 1: Learned Byakugan (lvl 40)
-- Storage >= 2: Learned 8 Trigrams Palm (lvl 80)
-- Storage >= 3: Learned 8 Trigrams Vacuum Palm (lvl 120 + graduated)
-- Storage >= 4: Learned Twin Lion Palm (lvl 150 + graduated)
local HYUUGA_JUTSU_STORAGE = 70006

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "{Hyuuga}",
        noLvl = "{level 5}",
        askHyuuga = "{become}",
        confirm = "{join}",
        done = "{Hakkeshou Kaiten}",
        isHyuuga = "{brings}",
        hasOtherClan = "",

        noLvlQuest1 = "{level 40}",
        quest1 = "{learn Byakugan}",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Byakugan.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Byakugan.",
        quest1Done = "",

        noLvlQuest2 = "{level 80}",
        quest2 = "{learn 8 Trigrams Palm}",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 8 Trigrams Palm.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 8 Trigrams Palm.",
        quest2Done = "",

        noLvlQuest3 = "{level 120} {graduated}",
        quest3 = "{learn 8 Trigrams Vacuum Palm}",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 8 Trigrams Vacuum Palm.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 8 Trigrams Vacuum Palm.",
        quest3Done = "",

        noLvlQuest4 = "{level 150} {graduated}",
        quest4 = "{learn Twin Lion Palm}",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Twin Lion Palm.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Twin Lion Palm.",
        quest4Done = "",
        
        alreadyLearnedByakugan = "You have already learned Byakugan from me.",
        alreadyLearned8TrigramsPalm = "You have already learned 8 Trigrams Palm from me.",
        alreadyLearned8TrigramsVacuumPalm = "You have already learned 8 Trigrams Vacuum Palm from me.",
        alreadyLearnedTwinLionPalm = "You have already learned Twin Lion Palm from me.",
        allTechniques = "",
    },

    ["pt"] = {
        help = "{Hyuuga}",
        noLvl = "{level 5}",
        askHyuuga = "{tornar}",
        confirm = "{fazer parte}",
        done = "{Hakkeshou Kaiten}",        
        isHyuuga = "{traz}",
        hasOtherClan = "",

        noLvlQuest1 = "{level 40}",
        quest1 = "{aprender Byakugan}",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Byakugan.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Byakugan.",
        quest1Done = "",

        noLvlQuest2 = "{level 80}",
        quest2 = "{aprender 8 Trigrams Palm}",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 8 Trigrams Palm.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 8 Trigrams Palm.",
        quest2Done = "",

        noLvlQuest3 = "{level 120} {graduar}",
        quest3 = "{aprender 8 Trigrams Vacuum Palm}",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 8 Trigrams Vacuum Palm.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 8 Trigrams Vacuum Palm.",
        quest3Done = "",

        noLvlQuest4 = "{level 150} {graduada}",
        quest4 = "{aprender Twin Lion Palm}",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Twin Lion Palm.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Twin Lion Palm.",
        quest4Done = "",
        
        alreadyLearnedByakugan = "Você já aprendeu Byakugan de mim.",
        alreadyLearned8TrigramsPalm = "Você já aprendeu 8 Trigrams Palm de mim.",
        alreadyLearned8TrigramsVacuumPalm = "Você já aprendeu 8 Trigrams Vacuum Palm de mim.",
        alreadyLearnedTwinLionPalm = "Você já aprendeu Twin Lion Palm de mim.",
        allTechniques = "",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "hyuuga", "tornar", "fazer parte", "traz", "aprender byakugan", "aprender 8 Trigrams palm", "aprender 8 Trigrams vacuum palm", "aprender twin lion palm"},
    ["en"] = {"help", "hyuuga", "become", "join", "brings", "learn byakugan", "learn 8 Trigrams palm", "learn 8 Trigrams vacuum palm", "learn twin lion palm"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local hyuugaVocationId = 13
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
    if msgcontains(msgLower, "hyuuga") then
        if playerVocation ~= 0 and playerVocation ~= hyuugaVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == hyuugaVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isHyuuga, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askHyuuga, cid)
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
        player:setVocation(Vocation(hyuugaVocationId))
        player:save()
        player:setOutfit({lookType = 420})
        player:addOutfit(420)
        player:learnSpell("Hakkeshou Kaiten")
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Check which jutsu the player can learn
    if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
        if playerVocation ~= hyuugaVocationId then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
        end
        
        -- Determine which is the next jutsu based on storage
        if hyuugaJutsu == 0 then
            if player:getLevel() < 40 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif hyuugaJutsu == 1 then
            if player:getLevel() < 80 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif hyuugaJutsu == 2 then
            if player:getLevel() < 100 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif hyuugaJutsu == 3 then
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

    -- Learn Byakugan
    if msgcontains(msgLower, "learn byakugan") or msgcontains(msgLower, "aprender byakugan") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
        end
        
        if hyuugaJutsu >= 1 then
            npcHandler:say(messages[currentLang].alreadyLearnedByakugan, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Byakugan")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 1)
        player:save()
        npcHandler:say(messages[currentLang].quest1Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn 8 Trigrams Palm
    if msgcontains(msgLower, "learn 8 Trigrams palm") or msgcontains(msgLower, "aprender 8 Trigrams palm") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if hyuugaJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearned8TrigramsPalm, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("8 Trigrams Palm")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn 8 Trigrams Vacuum Palm
    if msgcontains(msgLower, "learn 8 Trigrams vacuum palm") or msgcontains(msgLower, "aprender 8 Trigrams vacuum palm") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if hyuugaJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearned8TrigramsVacuumPalm, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("8 Trigrams Vacuum Palm")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Twin Lion Palm
    if msgcontains(msgLower, "learn twin lion palm") or msgcontains(msgLower, "aprender twin lion palm") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if hyuugaJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearnedTwinLionPalm, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Twin Lion Palm")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 4)
        player:save()
        npcHandler:say(messages[currentLang].quest4Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
