local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Aprendeu Katon Goukakyuu (ao se tornar Uchiha)
-- Storage >= 1: Aprendeu Chidori (lvl 50)
-- Storage >= 2: Aprendeu Sharingan (lvl 80)
-- Storage >= 3: Aprendeu Kirin (lvl 100 + graduated)
-- Storage >= 4: Aprendeu Amaterasu (lvl 120 + Mangekyou)
local UCHIHA_JUTSU_STORAGE = 70002

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Fugaku Uchiha, and I assist ninjas of the {Uchiha} clan. Do you need anything from me?",
        noLvl = "Sorry, but you're too weak to join Uchiha clan. Talk to me again when you're at least {level 5}.",
        askUchiha = "Ah, so you want to {become} a Uchiha, hm? Do you really think you got what it takes?",
        confirm = "I see you are very determined about this. There will be no second chances. You really want to {join} the powerful Uchiha clan?",
        done = "So be it! You are now an Uchiha! Train hard and come speak to me again. When the time comes, I will tell you more details. I will also teach you a powerful fire spell named {Katon Goukakyuu}. Try using it when you have the chance.",
        isUchiha = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "You need to be at least {level 50} to start learning from me.",
        quest1 = "I see that you have grown stronger. It's time to teach you a powerful skill named {Chidori}. This skill uses the raiton element to create a strong lightning in your hand. Are you ready to {learn Chidori}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Chidori.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Chidori.",
        quest1Done = "I never had a doubt that you would succeed. Use your new jutsu wisely, and show the world the power of the Uchiha clan.",

        noLvlQuest2 = "I know you are excited to learn new jutsus, but you need to be at least {level 80} to survive my training. Come back when you are stronger.",
        quest2 = "You have proven yourself worthy. I can feel the power in you. I think it's time for me to teach you a powerful ocular skill named {Sharingan}. Are you ready to take the next step and {learn Sharingan}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Sharingan.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Sharingan.",
        quest2Done = "So you survived my training and learned how to use the Sharingan. Impressive indeed. Now train your eyes and some day you might even awaken its full potential.",

        noLvlQuest3 = "So, you came to me again to learn the secrets of the Uchiha clan. However, you need to be at least {level 100} and be {graduated}. If I try to teach this skill to you now, you will surely die, and we both don't want that. Come back when you are stronger.",
        quest3 = "You have done well to reach this point. I can't remember the last time I saw an Uchiha with so much talent. So, let's teach you the raiton element jutsu named {Kirin}. Are you ready to control the lightning itself? Are you ready to {learn Kirin}?",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kirin.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kirin.",
        quest3Done = "Again you have proven yourself in my training, and now thunder bows to your will. Use Kirin wisely, for it is a powerful jutsu that can turn the tide of any battle. I feel that your power will be recognized far and wide.",

        noLvlQuest4 = "You have come far, |PLAYERNAME|. But to learn the ultimate power of the Uchiha clan, you need to be at least {level 120} and have {awakened your Sharingan to its Mangekyou form}. Hah... I think your best friend will not like what will happen next.",
        quest4 = "So, you have done it... You have awakened your Mangekyou Sharingan. Impressive. Very well, I will teach you the ultimate Uchiha jutsu named {Amaterasu}. Are you ready to control the black flames that burn anything in their path? Are you ready to {learn Amaterasu}?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Amaterasu.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Amaterasu.",
        quest4Done = "You've done it. I didn't think you had it in you, but you actually did it. I will teach you Amaterasu now, but remember that such power can be a double-edged sword. Maybe one day you will understand its true meaning. Now go forth and show the world the might of the Uchiha clan!",
        
        alreadyLearnedChidori = "You have already learned Chidori from me.",
        alreadyLearnedSharingan = "You have already learned Sharingan from me.",
        alreadyLearnedKirin = "You have already learned Kirin from me.",
        alreadyLearnedAmaterasu = "You have already learned Amaterasu from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Eu sou Fugaku Uchiha e auxilio os ninjas do clã {Uchiha}. Você precisa de algo comigo?",
        noLvl = "Desculpe, mas você é muito fraco para entrar no clã Uchiha. Fale comigo novamente quando tiver pelo menos {level 5}.",
        askUchiha = "Ah, então você quer se {tornar} um Uchiha, é? Você realmente acha que tem o que é preciso?",
        confirm = "Vejo que você está determinado a isso. Não haverá segunda chance. Você realmente quer {fazer parte} do poderoso clã Uchiha?",
        done = "Assim seja! Você agora é um Uchiha! Treine duro e venha falar comigo novamente. Quando chegar a hora, contarei mais detalhes. Também vou te ensinar um poderoso jutsu de fogo chamado {Katon Goukakyuu}. Tente usar quando tiver a chance.",        
        isUchiha = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Você precisa ser pelo menos {level 50} para começar a aprender comigo.",
        quest1 = "Vejo que você ficou mais forte. É hora de te ensinar uma habilidade poderosa chamada {Chidori}. Esta habilidade usa o elemento raiton para criar um poderoso raio em sua mão. Você está pronto para {aprender Chidori}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Chidori.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Chidori.",
        quest1Done = "Eu nunca duvidei que você conseguiria. Use seu novo jutsu com sabedoria e mostre ao mundo o poder do clã Uchiha.",

        noLvlQuest2 = "Eu sei que você está animado para aprender novos jutsus, mas você precisa ter pelo menos {level 80} para sobreviver ao meu treinamento. Volte quando ficar mais forte.",
        quest2 = "Você se provou digno. Posso sentir o poder em você. Acho que é hora de eu te ensinar uma poderosa habilidade ocular chamada {Sharingan}. Você está pronto para dar o próximo passo e {aprender Sharingan}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Sharingan.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Sharingan.",
        quest2Done = "Então você sobreviveu ao meu treinamento e aprendeu a usar o Sharingan. Impressionante, de fato. Agora treine seus olhos e talvez um dia você desperte todo o seu potencial.",

        noLvlQuest3 = "Então, você veio a mim novamente para aprender os segredos do clã Uchiha. Entretanto, você precisa ter pelo menos {level 100} e se {graduar}. Se eu tentar te ensinar esta habilidade agora, você com certeza morrerá, e nenhum de nós dois gostaria disso. Volte quando ficar mais forte.",
        quest3 = "Você fez bem em chegar até aqui. Não consigo lembrar da última vez que vi um Uchiha com tanto talento. Então, vamos te ensinar o jutsu do elemento raiton chamado {Kirin}. Você está pronto para controlar o próprio raio? Você está pronto para {aprender Kirin}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kirin.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kirin.",
        quest3Done = "Novamente você se provou em meu treinamento, e agora o trovão se curva à sua vontade. Use o Kirin com sabedoria, pois é um jutsu poderoso que pode mudar o rumo de qualquer batalha.",

        noLvlQuest4 = "Você chegou longe, |PLAYERNAME|. Mas para aprender o poder supremo do clã Uchiha, você precisa ter pelo menos {level 120} e ter {despertado seu Sharingan em sua forma Mangekyou}. Hah... Acho que seu melhor amigo não vai gostar do que irá acontecer.",
        quest4 = "Então, você conseguiu... Você despertou seu Mangekyou Sharingan. Impressionante. Muito bem, vou te ensinar o jutsu supremo Uchiha chamado {Amaterasu}. Você está pronto para controlar as chamas negras que queimam qualquer coisa em seu caminho? Você está pronto para {aprender Amaterasu}?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Amaterasu.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Amaterasu.",
        quest4Done = "Você conseguiu. Eu não achei que você faria isso, mas você realmente fez. Vou te ensinar Amaterasu agora, mas lembre-se que tal poder pode ser fatal para si também. Talvez um dia você entenda o significado disso. Agora vá e mostre ao mundo o poder do clã Uchiha!",
        
        alreadyLearnedChidori = "Você já aprendeu Chidori de mim.",
        alreadyLearnedSharingan = "Você já aprendeu Sharingan de mim.",
        alreadyLearnedKirin = "Você já aprendeu Kirin de mim.",
        alreadyLearnedAmaterasu = "Você já aprendeu Amaterasu de mim.",
        allTechniques = "Você dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "uchiha", "tornar", "fazer parte", "traz", "aprender chidori", "aprender sharingan", "aprender kirin", "aprender amaterasu"},
    ["en"] = {"help", "uchiha", "become", "join", "brings", "learn chidori", "learn sharingan", "learn kirin", "learn amaterasu"}
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
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Verifica qual jutsu o jogador pode aprender
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
            if player:getLevel() < 50 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif uchihaJutsu == 1 then
            if player:getLevel() < 80 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif uchihaJutsu == 2 then
            if player:getLevel() < 100 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif uchihaJutsu == 3 then
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

    -- Learn Chidori
    if msgcontains(msgLower, "learn chidori") or msgcontains(msgLower, "aprender chidori") then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
        end
        
        if uchihaJutsu >= 1 then
            npcHandler:say(messages[currentLang].alreadyLearnedChidori, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Chidori")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 1)
        player:save()
        npcHandler:say(messages[currentLang].quest1Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Sharingan
    if msgcontains(msgLower, "learn sharingan") or msgcontains(msgLower, "aprender sharingan") then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if uchihaJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearnedSharingan, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Sharingan")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Kirin
    if msgcontains(msgLower, "learn kirin") or msgcontains(msgLower, "aprender kirin") then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if uchihaJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedKirin, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kirin")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Amaterasu
    if msgcontains(msgLower, "learn amaterasu") or msgcontains(msgLower, "aprender amaterasu") then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if uchihaJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearnedAmaterasu, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Amaterasu")
        player:getPosition():sendMagicEffect(478)
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
