local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Aprendeu Kage no Hou Jutsu (Ao se tornar Nara)
-- Storage >= 1: Aprendeu Kagemane no Jutsu (lvl 40)
-- Storage >= 2: Aprendeu Kage Nui no Jutsu (lvl 80)
-- Storage >= 3: Aprendeu Kage Kubi Shibari no Jutsu (lvl 120 + graduated)
-- Storage >= 4: Aprendeu Kage Tsukami no Jutsu (lvl 150 + graduated)
local NARA_JUTSU_STORAGE = 70007

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Shikamaru Nara, and I assist ninjas of the {Nara} clan. Do you need anything from me?",
        noLvl = "Sorry, but you're too weak to join the Nara clan. Talk to me again when you're at least {level 5}.",
        askNara = "Ah, so you want to {become} a Nara, hm? Do you really think you got what it takes?",
        confirm = "I see you are very determined about this. There will be no second chances. You really want to {join} the powerful Nara clan?",
        done = "So be it! You are now a Nara! Train hard and come speak to me again. I will teach you {Kage no Hou Jutsu}. Use it when you have the chance.",
        isNara = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "You need to be at least {level 40} to start learning from me.",
        quest1 = "I see that you have grown stronger. It's time to teach you a powerful technique named {Kagemane no Jutsu}. Are you ready to {learn Kagemane no Jutsu}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kagemane no Jutsu.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kagemane no Jutsu.",
        quest1Done = "I never had a doubt that you would succeed. Use your new jutsu wisely and show the world the power of the Nara clan.",

        noLvlQuest2 = "I know you are excited to learn new jutsus, but you need to be at least {level 80} to survive my training. Come back when you are stronger.",
        quest2 = "You have proven yourself worthy. I think it's time to teach you {Kage Nui no Jutsu}. Are you ready to {learn Kage Nui no Jutsu}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Nui no Jutsu.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Nui no Jutsu.",
        quest2Done = "So you survived my training and learned how to use Kage Nui no Jutsu. Impressive indeed. Keep training your technique.",

        noLvlQuest3 = "So, you came to me again to learn the secrets of the Nara clan. However, you need to be at least {level 120} and be {graduated}. Come back when you are stronger.",
        quest3 = "You have done well to reach this point. It's time to teach you {Kage Kubi Shibari no Jutsu}. Are you ready to {learn Kage Kubi Shibari no Jutsu}?",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Kubi Shibari no Jutsu.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Kubi Shibari no Jutsu.",
        quest3Done = "Again you have proven yourself in my training. Use your new jutsu wisely.",

        noLvlQuest4 = "You have come far, |PLAYERNAME|. But to learn the ultimate power of the Nara clan, you need to be at least {level 150} and be {graduated}.",
        quest4 = "So, you have done it... Very well, I will teach you the ultimate Nara jutsu named {Kage Tsukami no Jutsu}. Are you ready to {learn Kage Tsukami no Jutsu}?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kage Tsukami no Jutsu.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kage Tsukami no Jutsu.",
        quest4Done = "You've done it. I will teach you Kage Tsukami no Jutsu now. Use it wisely and honor the Nara clan.",
        
        alreadyLearnedKagemane = "You have already learned Kagemane no Jutsu from me.",
        alreadyLearnedKageNui = "You have already learned Kage Nui no Jutsu from me.",
        alreadyLearnedKageKubiShibari = "You have already learned Kage Kubi Shibari no Jutsu from me.",
        alreadyLearnedKageTsukami = "You have already learned Kage Tsukami no Jutsu from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Meu nome é Shikamaru Nara e eu auxilio os ninjas do clã {Nara}. Você precisa de algo de mim?",
        noLvl = "Desculpe, mas você é muito fraco para entrar no clã Nara. Fale comigo novamente quando tiver pelo menos {level 5}.",
        askNara = "Ah, então você quer se {tornar} um Nara, é? Você realmente acha que tem o que é preciso?",
        confirm = "Vejo que você está determinado a isso. Não haverá segunda chance. Você realmente quer {fazer parte} do poderoso clã Nara?",
        done = "Assim seja! Você agora é um Nara! Treine duro e venha falar comigo novamente. Vou te ensinar {Kage no Hou Jutsu}. Tente usar quando tiver a chance.",        
        isNara = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Você precisa ser pelo menos {level 40} para começar a aprender comigo.",
        quest1 = "Vejo que você ficou mais forte. É hora de te ensinar uma técnica poderosa chamada {Kagemane no Jutsu}. Você está pronto para {aprender Kagemane no Jutsu}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kagemane no Jutsu.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kagemane no Jutsu.",
        quest1Done = "Eu nunca duvidei que você conseguiria. Use seu novo jutsu com sabedoria e mostre ao mundo o poder do clã Nara.",

        noLvlQuest2 = "Eu sei que você está animado para aprender novos jutsus, mas você precisa ter pelo menos {level 80} para sobreviver ao meu treinamento. Volte quando ficar mais forte.",
        quest2 = "Você se provou digno. Acho que é hora de eu te ensinar {Kage Nui no Jutsu}. Você está pronto para {aprender Kage Nui no Jutsu}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Nui no Jutsu.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Nui no Jutsu.",
        quest2Done = "Então você sobreviveu ao meu treinamento e aprendeu a usar Kage Nui no Jutsu. Impressionante, de fato. Continue treinando sua técnica.",

        noLvlQuest3 = "Então, você veio a mim novamente para aprender os segredos do clã Nara. Entretanto, você precisa ter pelo menos {level 120} e se {graduar}. Volte quando ficar mais forte.",
        quest3 = "Você fez bem em chegar até aqui. É hora de te ensinar {Kage Kubi Shibari no Jutsu}. Você está pronto para {aprender Kage Kubi Shibari no Jutsu}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Kubi Shibari no Jutsu.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Kubi Shibari no Jutsu.",
        quest3Done = "Novamente você se provou em meu treinamento. Use seu novo jutsu com sabedoria.",

        noLvlQuest4 = "Você chegou longe, |PLAYERNAME|. Mas para aprender o poder supremo do clã Nara, você precisa ter pelo menos {level 150} e ser {graduado}.",
        quest4 = "Então, você conseguiu... Muito bem, vou te ensinar o jutsu supremo Nara chamado {Kage Tsukami no Jutsu}. Você está pronto para {aprender Kage Tsukami no Jutsu}?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kage Tsukami no Jutsu.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kage Tsukami no Jutsu.",
        quest4Done = "Você conseguiu. Vou te ensinar Kage Tsukami no Jutsu agora. Use-o com sabedoria e honre o clã Nara!",
        
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

    -- Verifica qual jutsu o jogador pode aprender
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
        
        -- Determinar qual é o próximo jutsu baseado no storage
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
