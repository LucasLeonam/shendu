local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Aprendeu Hakkeshou Kaiten (Ao se tornar Hyuuga)
-- Storage >= 1: Aprendeu Byakugan (lvl 40)
-- Storage >= 2: Aprendeu 8 Trigrams Palm (lvl 80)
-- Storage >= 3: Aprendeu 8 Trigrams Vacuum Palm (lvl 120 + graduated)
-- Storage >= 4: Aprendeu Twin Lion Palm (lvl 150 + graduated)
local HYUUGA_JUTSU_STORAGE = 70006

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Hiashi Hyuuga, and I assist ninjas of the {Hyuuga} clan. Do you need anything from me?",
        noLvl = "Sorry, but you're too weak to join the Hyuuga clan. Talk to me again when you're at least {level 5}.",
        askHyuuga = "Ah, so you want to {become} a Hyuuga, hm? Do you really think you got what it takes?",
        confirm = "I see you are very determined about this. There will be no second chances. You really want to {join} the powerful Hyuuga clan?",
        done = "So be it! You are now a Hyuuga! Train hard and come speak to me again. I will teach you {Hakkeshou Kaiten}. Use it when you have the chance.",
        isHyuuga = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "You need to be at least {level 40} to start learning from me.",
        quest1 = "I see that you have grown stronger. It's time to teach you a powerful ocular skill named {Byakugan}. Are you ready to {learn Byakugan}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Byakugan.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Byakugan.",
        quest1Done = "I never had a doubt that you would succeed. Use your new jutsu wisely and show the world the power of the Hyuuga clan.",

        noLvlQuest2 = "I know you are excited to learn new jutsus, but you need to be at least {level 80} to survive my training. Come back when you are stronger.",
        quest2 = "You have proven yourself worthy. I think it's time to teach you {8 Trigrams Palm}. Are you ready to {learn 8 Trigrams Palm}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 8 Trigrams Palm.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 8 Trigrams Palm.",
        quest2Done = "So you survived my training and learned how to use the 8 Trigrams Palm. Impressive indeed. Keep training your technique.",

        noLvlQuest3 = "So, you came to me again to learn the secrets of the Hyuuga clan. However, you need to be at least {level 120} and be {graduated}. Come back when you are stronger.",
        quest3 = "You have done well to reach this point. It's time to teach you {8 Trigrams Vacuum Palm}. Are you ready to {learn 8 Trigrams Vacuum Palm}?",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 8 Trigrams Vacuum Palm.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 8 Trigrams Vacuum Palm.",
        quest3Done = "Again you have proven yourself in my training. Use your new jutsu wisely.",

        noLvlQuest4 = "You have come far, |PLAYERNAME|. But to learn the ultimate power of the Hyuuga clan, you need to be at least {level 150} and be {graduated}.",
        quest4 = "So, you have done it... Very well, I will teach you the ultimate Hyuuga jutsu named {Twin Lion Palm}. Are you ready to {learn Twin Lion Palm}?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Twin Lion Palm.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Twin Lion Palm.",
        quest4Done = "You've done it. I will teach you Twin Lion Palm now. Use it wisely and honor the Hyuuga clan.",
        
        alreadyLearnedByakugan = "You have already learned Byakugan from me.",
        alreadyLearned8TrigramsPalm = "You have already learned 8 Trigrams Palm from me.",
        alreadyLearned8TrigramsVacuumPalm = "You have already learned 8 Trigrams Vacuum Palm from me.",
        alreadyLearnedTwinLionPalm = "You have already learned Twin Lion Palm from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Meu nome é Hiashi Hyuuga e eu auxilio os ninjas do clã {Hyuuga}. Você precisa de algo de mim?",
        noLvl = "Desculpe, mas você é muito fraco para entrar no clã Hyuuga. Fale comigo novamente quando tiver pelo menos {level 5}.",
        askHyuuga = "Ah, então você quer se {tornar} um Hyuuga, é? Você realmente acha que tem o que é preciso?",
        confirm = "Vejo que você está determinada a isso. Não haverá segunda chance. Você realmente quer {fazer parte} do poderoso clã Hyuuga?",
        done = "Assim seja! Você agora é uma Hyuuga! Treine duro e venha falar comigo novamente. Vou te ensinar {Hakkeshou Kaiten}. Tente usar quando tiver a chance.",        
        isHyuuga = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Você precisa ser pelo menos {level 40} para começar a aprender comigo.",
        quest1 = "Vejo que você ficou mais forte. É hora de te ensinar uma poderosa habilidade ocular chamada {Byakugan}. Você está pronta para {aprender Byakugan}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Byakugan.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Byakugan.",
        quest1Done = "Eu nunca duvidei que você conseguiria. Use seu novo jutsu com sabedoria e mostre ao mundo o poder do clã Hyuuga.",

        noLvlQuest2 = "Eu sei que você está animada para aprender novos jutsus, mas você precisa ter pelo menos {level 80} para sobreviver ao meu treinamento. Volte quando ficar mais forte.",
        quest2 = "Você se provou digna. Acho que é hora de eu te ensinar {8 Trigrams Palm}. Você está pronta para {aprender 8 Trigrams Palm}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 8 Trigrams Palm.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 8 Trigrams Palm.",
        quest2Done = "Então você sobreviveu ao meu treinamento e aprendeu a usar o 8 Trigrams Palm. Impressionante, de fato. Continue treinando sua técnica.",

        noLvlQuest3 = "Então, você veio a mim novamente para aprender os segredos do clã Hyuuga. Entretanto, você precisa ter pelo menos {level 120} e se {graduar}. Volte quando ficar mais forte.",
        quest3 = "Você fez bem em chegar até aqui. É hora de te ensinar {8 Trigrams Vacuum Palm}. Você está pronta para {aprender 8 Trigrams Vacuum Palm}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 8 Trigrams Vacuum Palm.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 8 Trigrams Vacuum Palm.",
        quest3Done = "Novamente você se provou em meu treinamento. Use seu novo jutsu com sabedoria.",

        noLvlQuest4 = "Você chegou longe, |PLAYERNAME|. Mas para aprender o poder supremo do clã Hyuuga, você precisa ter pelo menos {level 150} e ser {graduada}.",
        quest4 = "Então, você conseguiu... Muito bem, vou te ensinar o jutsu supremo Hyuuga chamado {Twin Lion Palm}. Você está pronta para {aprender Twin Lion Palm}?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Twin Lion Palm.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Twin Lion Palm.",
        quest4Done = "Você conseguiu. Vou te ensinar Twin Lion Palm agora. Use-o com sabedoria e honre o clã Hyuuga!",
        
        alreadyLearnedByakugan = "Você já aprendeu Byakugan de mim.",
        alreadyLearned8TrigramsPalm = "Você já aprendeu 8 Trigrams Palm de mim.",
        alreadyLearned8TrigramsVacuumPalm = "Você já aprendeu 8 Trigrams Vacuum Palm de mim.",
        alreadyLearnedTwinLionPalm = "Você já aprendeu Twin Lion Palm de mim.",
        allTechniques = "Você dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
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
    local currentLang = npcHandler.languages[cid] or "pt" -- idioma padrão pt

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

    -- Fluxo de confirmação
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

    -- Verifica qual jutsu o jogador pode aprender
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
        
        -- Determinar qual é o próximo jutsu baseado no storage
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
