local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Nenhum jutsu
-- Storage >= 1: Aprendeu Chidori
-- Storage >= 2: Aprendeu Sharingan
-- Storage >= 3: Aprendeu Kirin
-- Storage >= 4: Aprendeu Amaterasu
local UCHIHA_JUTSU_STORAGE = 70002

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello. My name is Fugaku Uchiha, and I assist ninjas of the {Uchiha} clan. Do you need anything from me?",
        noLvl = "Sorry, but you're too weak to join Uchiha clan. Talk to me again when you're at least level 5.",
        askUchiha = "Ah, so you want to {become} a Uchiha, hm? Do you really think you got what it takes?",
        confirm = "I see you are very determined about this. There will be no second chances. You really want to {join} the powerful Uchiha clan?",
        done = "So be it! You are now an Uchiha! Train hard and come speak to me again. When the time comes, I will tell you more details. I will also teach you a powerful fire spell named {Katon Goukakyuu}. Try using it when you have the chance.",
        isUchiha = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "You need to be at least level 50 to start learning from me.",
        quest1 = "I see that you have grown stronger. It's time to teach you a powerful skill named {learn Chidori}. This skill uses the raiton element to create a strong lightning in your hand. Are you ready to learn it?",
        quest1Done = "I never had a doubt that you would suceed. Use your new jutsu wisely, and show the world the power of the Uchiha clan.",

        noLvlQuest2 = "I know you are excited to learn new jutsus, but you need to be at least level 80 to survive my training. Come back when you are stronger.",
        quest2 = "You have proven yourself worthy. I can feel the power in you. I think it's time for me to teach you a powerful ocular skill named {learn Sharingan}. Are you ready to take the next step?",
        quest2Done = "So you survived my training and learned how to use the Sharingan. Impressive indeed. Now train your eyes and some day you might even awaken its full potential.",

        noLvlQuest3 = "So, you came to me again to learn the secrets of the Uchiha clan. However, you need to be at least level 100 and be graduated. If I try to teach this skill to you now, you will surely die, and we both don't want that. Come back when you are stronger.",
        quest3 = "You have done well to reach this point. I can't remember the last time I saw an Uchiha with so much talent. So, let's teach you the raiton element jutsu named {learn Kirin}. Are you ready to control the lightning itself?",
        quest3Done = "Again you have proven yourself in my training, and now thunder bows to your will. Use Kirin wisely, for it is a powerful jutsu that can turn the tide of any battle. I feel that your power will be recognized far and wide.",

        noLvlQuest4 = "You have come far, |PLAYERNAME|. But to learn the ultimate power of the Uchiha clan, you need to be at least level 120 and have awakened your Sharingan to its Mangekyou form. Hah... I think your best friend will not like what will happen next.",
        quest4 = "So, you have done it... You have awakened your Mangekyou Sharingan. Impressive. Very well, I will teach you the ultimate Uchiha jutsu named {learn Amaterasu}. Are you ready to control the black flames that burn anything in their path?",
        quest4Done = "You've done it. I didn't think you had it in you, but you actually did it. I will teach you Amaterasu now, but remember that such power can be a double-edged sword. Maybe one day you will understand its true meaning. Now go fourth and show the world the might of the Uchiha clan!",
    },

    ["pt"] = {
        help = "Eu sou Fugaku Uchiha e auxilio os ninjas do clã {Uchiha}. Você precisa de algo comigo?",
        noLvl = "Desculpe, mas você é muito fraco para entrar no clã Uchiha. Fale comigo novamente quando tiver pelo menos level 5.",
        askUchiha = "Ah, então você quer se {tornar} um Uchiha, é? Você realmente acha que tem o que é preciso?",
        confirm = "Vejo que você está determinado a isso. Não haverá segunda chance. Você realmente quer {fazer parte} do poderoso clã Uchiha?",
        done = "Assim seja! Você agora é um Uchiha! Treine duro e venha falar comigo novamente. Quando chegar a hora, contarei mais detalhes. Também vou te ensinar um poderoso jutsu de fogo chamado Katon Goukakyuu. Tente usar quando tiver a chance.",        
        isUchiha = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Você precisa ser pelo menos level 50 para começar a aprender comigo.",
        quest1 = "Vejo que você ficou mais forte. É hora de te ensinar uma habilidade poderosa chamada {aprender Chidori}. Esta habilidade usa o elemento raiton para criar um poderoso raio em sua mão. Você está pronto para aprender?",
        quest1Done = "",

        noLvlQuest2 = "Eu sei que você está animado para aprender novos jutsus, mas você precisa ter pelo menos level 80 para sobreviver ao meu treinamento. Volte quando ficar mais forte.",
        quest2 = "Você se provou digno. Posso sentir o poder em você. Acho que é hora de eu te ensinar uma poderosa habilidade ocular chamada {aprender Sharingan}. Você está pronto para dar o próximo passo?",
        quest2Done = "",

        noLvlQuest3 = "Então, você veio a mim novamente para aprender os segredos do clã Uchiha. Entretanto, você precisa ter pelo menos level 100 e se graduar. Se eu tentar te ensinar esta habilidade agora, você com certeza morrerá, e nenhum de nós dois gostaria disso. Volte quando ficar mais forte.",
        quest3 = "Você fez bem em chegar até aqui. Não consigo lembrar da última vez que vi um Uchiha com tanto talento. Então, vamos te ensinar o jutsu do elemento raiton chamado {aprender Kirin}. Você está pronto para controlar o próprio raio?",
        quest3Done = "",

        noLvlQuest4 = "Você chegou longe, |PLAYERNAME|. Mas para aprender o poder supremo do clã Uchiha, você precisa ter pelo menos level 120 e ter despertado seu Sharingan em sua forma Mangekyou. Hah... Acho que seu melhor amigo não vai gostar do que irá acontecer.",
        quest4 = "Então, você conseguiu... Você despertou seu Mangekyou Sharingan. Impressionante. Muito bem, vou te ensinar o jutsu supremo Uchiha chamado {aprender Amaterasu}. Você está pronto para controlar as chamas negras que queimam qualquer coisa em seu caminho?",
        quest4Done = "",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "uchiha", "tornar", "fazer parte", "traz", "aprender Chidori", "aprender Sharingan", "aprender Kirin", "aprender Amaterasu"},
    ["en"] = {"help", "uchiha", "become", "join", "brings", "learn Chidori", "learn Sharingan", "learn Kirin", "learn Amaterasu"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local uchihaVocationId = 9
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
    if msgcontains(msgLower, "uchiha") then
        if playerVocation ~= 0 and playerVocation ~= uchihaVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == uchihaVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isUchiha, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askUchiha, cid)
            npcHandler.topic[cid] = 1
            return true
        end
    end

    -- Fluxo de confirmação
if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become")) then
    -- Verifica level mínimo
    if player:getLevel() < 5 then
        npcHandler:say(messages[currentLang].noLvl, cid)
        npcHandler.topic[cid] = 0
        return true
    end

    npcHandler:say(messages[currentLang].confirm, cid)
    npcHandler.topic[cid] = 2
    return true
elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join")) then
    player:setVocation(Vocation(uchihaVocationId))
    player:save()
    player:setOutfit({lookType = 390})
    player:addOutfit(390)
    player:learnSpell("Katon Goukakyuu")
    npcHandler:say(messages[currentLang].done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end

-- Fluxo de BRINGS/TRAZ - Verifica qual jutsu o jogador pode aprender
if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
    if playerVocation ~= uchihaVocationId then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    -- Determinar qual é o próximo jutsu baseado no storage
    if uchihaJutsu == 0 then
        -- Ainda não aprendeu Chidori
        if player:getLevel() < 50 then
            npcHandler:say(messages[currentLang].noLvlQuest1, cid)
        else
            npcHandler:say(messages[currentLang].quest1, cid)
            npcHandler.topic[cid] = 10
        end
    elseif uchihaJutsu == 1 then
        -- Já tem Chidori, pode aprender Sharingan
        if player:getLevel() < 80 then
            npcHandler:say(messages[currentLang].noLvlQuest2, cid)
        else
            npcHandler:say(messages[currentLang].quest2, cid)
            npcHandler.topic[cid] = 20
        end
    elseif uchihaJutsu == 2 then
        -- Já tem Sharingan, pode aprender Kirin
        if player:getLevel() < 100 then
            npcHandler:say(messages[currentLang].noLvlQuest3, cid)
        else
            npcHandler:say(messages[currentLang].quest3, cid)
            npcHandler.topic[cid] = 30
        end
    elseif uchihaJutsu == 3 then
        -- Já tem Kirin, pode aprender Amaterasu
        if player:getLevel() < 120 then
            npcHandler:say(messages[currentLang].noLvlQuest4, cid)
        else
            npcHandler:say(messages[currentLang].quest4, cid)
            npcHandler.topic[cid] = 40
        end
    else
        -- Já aprendeu tudo
        npcHandler:say("You have mastered all the techniques I can teach you. There is nothing more for me to offer.", cid)
    end
    return true
end

-- Confirmação Quest 1 (Chidori)
if npcHandler.topic[cid] == 10 and (msgcontains(msgLower, "learn Chidori")) then
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 1 then
        npcHandler:say("You have already learned Chidori from me.", cid)
        npcHandler:topic[cid] = 0
        return true
    end
    
    -- Verificar se o jogador tem GOLD COIN
    if player:getItemCount(3031) < 1 then
        npcHandler:say("I see you don't have a gold coin. Come back when you do, and I will teach you Chidori.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Remover GOLD COIN
    player:removeItem(3031, 1)

    player:learnSpell("Chidori")
    player:setStorageValue(UCHIHA_JUTSU_STORAGE, 1)
    player:save()
    npcHandler:say(messages[currentLang].quest1Done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end

-- Fluxo de Quest 2 (Sharingan)
if msgcontains(msgLower, "sharingan") then
    if playerVocation ~= uchihaVocationId then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 2 then
        npcHandler:say("You have already learned Sharingan from me. There's nothing more I can teach you about this technique.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    if player:getLevel() < 80 then
        npcHandler:say(messages[currentLang].noLvlQuest2, cid)
        return true
    else
        npcHandler:say(messages[currentLang].quest2, cid)
        npcHandler.topic[cid] = 20
        return true
    end
end

-- Confirmação Quest 2 (Sharingan)
if npcHandler.topic[cid] == 20 and (msgcontains(msgLower, "learn Sharingan")) then
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 2 then
        npcHandler:say("You have already learned Sharingan from me.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se o jogador tem GOLD COIN
    if player:getItemCount(3031) < 1 then
        npcHandler:say("I see you don't have a gold coin. Come back when you do, and I will teach you Sharingan.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Remover GOLD COIN
    player:removeItem(3031, 1)

    player:learnSpell("Sharingan")
    player:setStorageValue(UCHIHA_JUTSU_STORAGE, 2)
    player:save()
    npcHandler:say(messages[currentLang].quest2Done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end

-- Fluxo de Quest 3 (Kirin)
if msgcontains(msgLower, "learn Kirin") then
    if playerVocation ~= uchihaVocationId then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 3 then
        npcHandler:say("You have already learned Kirin from me. There's nothing more I can teach you about this technique.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    if player:getLevel() < 100 then
        npcHandler:say(messages[currentLang].noLvlQuest3, cid)
        return true
    else
        npcHandler:say(messages[currentLang].quest3, cid)
        npcHandler.topic[cid] = 30
        return true
    end
end

-- Confirmação Quest 3 (Kirin)
if npcHandler.topic[cid] == 30 and (msgcontains(msgLower, "learn Kirin")) then
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 3 then
        npcHandler:say("You have already learned Kirin from me.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se o jogador tem GOLD COIN
    if player:getItemCount(3031) < 1 then
        npcHandler:say("I see you don't have a gold coin. Come back when you do, and I will teach you Kirin.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Remover GOLD COIN
    player:removeItem(3031, 1)

    player:learnSpell("Kirin")
    player:setStorageValue(UCHIHA_JUTSU_STORAGE, 3)
    player:save()
    npcHandler:say(messages[currentLang].quest3Done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end

-- Fluxo de Quest 4 (Amaterasu)
if msgcontains(msgLower, "learn Amaterasu") then
    if playerVocation ~= uchihaVocationId then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 4 then
        npcHandler:say("You have already learned Amaterasu from me. There's nothing more I can teach you about this technique.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    if player:getLevel() < 120 then
        npcHandler:say(messages[currentLang].noLvlQuest4, cid)
        return true
    else
        npcHandler:say(messages[currentLang].quest4, cid)
        npcHandler.topic[cid] = 40
        return true
    end
end

-- Confirmação Quest 4 (Amaterasu)
if npcHandler.topic[cid] == 40 and (msgcontains(msgLower, "learn Amaterasu")) then
    -- Verificar se já completou esta quest
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    if uchihaJutsu >= 4 then
        npcHandler:say("You have already learned Amaterasu from me.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Verificar se o jogador tem GOLD COIN
    if player:getItemCount(3031) < 1 then
        npcHandler:say("I see you don't have a gold coin. Come back when you do, and I will teach you Amaterasu.", cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Remover GOLD COIN
    player:removeItem(3031, 1)

    player:learnSpell("Amaterasu")
    player:setStorageValue(UCHIHA_JUTSU_STORAGE, 4)
    player:save()
    npcHandler:say(messages[currentLang].quest4Done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
