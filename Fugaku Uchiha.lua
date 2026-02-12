local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Unique storage to track learned jutsus
-- Storage = 0: Learned Katon Goukakyuu (upon becoming Uchiha)
-- Storage = 1: Received quest to learn Chidori (lvl 40)
-- Storage = 2: Completed Kakashi's quest
-- Storage = 3: Learned Sharingan (lvl 80)
-- Storage = 4: Received quest to learn Kirin (lvl 120 + graduated)
-- Storage = 5: Completed Orochimaru's quest
-- Storage = 6: Learned Kirin (lvl 120 + graduated)
-- Storage = 7: Received quest to learn Amaterasu (lvl 150)
-- Storage = 8: Completed Kage's quest
-- Storage = 9: Learned Amaterasu (lvl 150 + Mangekyou)

-- Rank ranges: E=0-49, D=50-99, C=100-249, B=250-499, A=500-699, S=700+
-- Graduation values: Academy Student=0, Gennin=1, Chunnin=2, Jounnin=3 (NOT YET IMPLEMENTED)

local UCHIHA_JUTSU_STORAGE = 70002
local RANK_STORAGE = 5153
local GRADUATION_STORAGE = 5400

-- Function to get rank level from rank points
local function getRankLevel(rankPoints)
    if rankPoints >= 700 then return 5 end  -- Rank S
    if rankPoints >= 500 then return 4 end  -- Rank A
    if rankPoints >= 250 then return 3 end  -- Rank B
    if rankPoints >= 100 then return 2 end  -- Rank C
    if rankPoints >= 50 then return 1 end   -- Rank D
    return 0  -- Rank E
end



function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello, |PLAYERNAME|. I am Fugaku Uchiha. I guide those of the {Uchiha} clan. Speak. What do you seek?",
        noLvl = "You're too weak to join the Uchiha clan. Talk to me again when you're at least {level 5}.",
        askUchiha = "So you wish to {become} an Uchiha. This name carries weight. Do you understand what that means?",
        confirm = "Once you join, there will be no turning back. No excuses. Are you certain you wish to {join} the Uchiha clan?",
        done = "Very well. From this moment on, you carry the Uchiha name. Do not dishonor it. I will grant you the fire technique {Katon Goukakyuu}. Master it. You will need it.",
        isUchiha = "You return, |PLAYERNAME|. What brings you here?",
        hasOtherClan = "You already belong to another clan. I will not interfere with divided loyalty.",

        noLvlQuest1 = "You lack the necessary experience. Reach at least {level 40}, master the {Raiton} element, and achieve {Rank C} before seeking further training.",
        quest1 = "You have grown stronger. It is time you learned a technique worthy of the Uchiha. Chidori. A lightning blade formed through raiton chakra. Are you prepared to {learn Chidori}?",
        quest1Requirements = "I will not be the one to teach it. The technique belongs to the one known as the {Copy Ninja} — Hatake Kakashi. Seek him. Learn from him. Return only after you succeed. A true shinobi earns his power.",
        quest1Incomplete = "You have not yet mastered Chidori. I expect results, not attempts. Go talk to Kakashi and complete your task.",
        quest1Done = "So, you learned Chidori. Kakashi sealed it for your safety — a cautious decision. I will remove the seal. There. The technique is now fully yours. Use it with discipline.",

        noLvlQuest2 = "Do not rush your growth. Reach at least {level 80}, achieve the rank of {Chunnin}, and attain {Rank B} before undertaking what comes next.",
        quest2 = "|PLAYERNAME|, I have a task for you. Return to the ruins of the Uchiha clan. Search for what remains of our past. There are truths buried there. Perhaps, under the right circumstances, you may even {awaken your Sharingan}.",
        quest2Requirements = "The ruins are sealed to outsiders. I have granted you chakra access. Do not waste this opportunity. Observe carefully. What you discover may change you.",
        quest2Incomplete = "Hmm. Care to tell me why you haven't finished the task I directly asked you to do? I will tell you again... Here in the Uchiha clan, we don't accept failures. Stop wasting time and go to the ruins at once.",
        quest2Done = "You survived the echoes of the ruins... and awakened your Sharingan in the process. Good. But understand this — awakening it is only the first step. Mastery requires far more than emotion.",

        noLvlQuest3 = "|PLAYERNAME|, I have a task to assign you, but this mission demands more than ambition. Reach {level 120}, achieve {Jounnin} status, and attain {Rank A}. Return to me when you achieve this.",
        quest3 = "The Kage has issued a direct order. Orochimaru — one of the Legendary Sannin — must be captured alive. He possesses knowledge we require. Do you believe you can {capture Orochimaru}?",
        quest3Requirements = "He is dangerous and deceptive. Do not underestimate him. Our intel suggests he hides between our village and the Sound Village. Locate him. Capture him. Deliver him to prison. Failure is not acceptable.",
        quest3Incomplete = "The task remains unfinished, it seems. Prepare yourself properly, but do not delay unnecessarily. Orochimaru will not remain in one place forever.",
        quest3Done = "You failed to capture him… and allowed yourself to be manipulated. You have brought disgrace upon the Uchiha name. Learn from this. I will not tolerate such weakness again.",

        noLvlQuest4 = "|PLAYERNAME|, after your last failure, I expected more. Reach {level 150}, maintain {Jounnin} status and achieve {Rank S}. Then return to me.",
        quest4 = "The Kage believes the truth behind our clan's massacre is not as simple as we were told. He has requested your presence. Go to his office and hear the {Kage's request}.",
        quest4Requirements = "Assist him fully. Earn his confidence. When you have uncovered what he seeks, return to me with every detail.",
        quest4Incomplete = "I grow tired of repetition. Complete the Kage's request and report back immediately.",
        quest4Done = "You uncovered the truth… and awakened the full potential of your eyes. Few endure such trials, but it seems you chakra is all messy because of it. Let me correct a few things in your circulation... Done. Now you are able to use Amaterasu freely. Just remember this well: excessive use of the Mangekyou Sharingan leads to blindness. Power without restraint destroys its wielder.",
        
        alreadyLearnedChidori = "You have already learned Chidori from me.",
        alreadyLearnedSharingan = "You have already learned Sharingan from me.",
        alreadyLearnedKirin = "You have already learned Kirin from me.",
        alreadyLearnedAmaterasu = "You have already learned Amaterasu from me.",
        allTechniques = "At the moment, I don't have any new requests for you. I'll let you know if something comes up.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Eu sou Fugaku Uchiha e auxilio os ninjas do clã {Uchiha}. Você precisa de algo comigo?",
        noLvl = "Desculpe, mas você é muito fraco para entrar no clã Uchiha. Fale comigo novamente quando tiver pelo menos {level 5}.",
        askUchiha = "Ah, então você quer se {tornar} um Uchiha, é? Você realmente acha que tem o que é preciso?",
        confirm = "Vejo que você está determinado a isso. Não haverá segunda chance. Você realmente quer {fazer parte} do poderoso clã Uchiha?",
        done = "Assim seja! Você agora é um Uchiha! Treine duro e venha falar comigo novamente. Quando chegar a hora, contarei mais detalhes. Também vou te ensinar um poderoso jutsu de fogo chamado {Katon Goukakyuu}. Tente usar quando tiver a chance.",        
        isUchiha = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Você precisa ser pelo menos {level 40}, dominar o elemento {Raiton} e obter a classificação {Rank C} para começar comigo.",
        quest1 = "Vejo que você ficou mais forte. É hora de te ensinar uma habilidade poderosa chamada Chidori. Esta habilidade usa o elemento raiton para criar um poderoso raio em sua mão. Você está pronto para {aprender Chidori}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Chidori.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Chidori.",
        quest1Done = "Eu nunca duvidei que você conseguiria. Use seu novo jutsu com sabedoria e mostre ao mundo o poder do clã Uchiha.",

        noLvlQuest2 = "Eu sei que você está animado, mas precisa ter pelo menos {level 80}, alcançar o rank de {Chunnin} e atingir {Rank B} para sobreviver ao treinamento. Volte quando ficar mais forte.",
        quest2 = "Você se provou digno. Posso sentir o poder em você. Acho que é hora de eu te ensinar uma poderosa habilidade ocular chamada Sharingan. Você está pronto para dar o próximo passo e {aprender Sharingan}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Sharingan.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Sharingan.",
        quest2Done = "Então você sobreviveu ao meu treinamento e aprendeu a usar o Sharingan. Impressionante, de fato. Agora treine seus olhos e talvez um dia você desperte todo o seu potencial.",

        noLvlQuest3 = "Então, você veio novamente. Mas você precisa ter pelo menos {level 120}, alcançar o status de {Jounnin} e atingir {Rank A}. Se eu tentar te ensinar agora, você morrerá. Volte quando ficar verdadeiramente forte.",
        quest3 = "Você fez bem em chegar até aqui. Não consigo lembrar da última vez que vi um Uchiha com tanto talento. Então, vamos te ensinar o jutsu do elemento raiton chamado Kirin. Você está pronto para controlar o próprio raio? Você está pronto para {aprender Kirin}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kirin.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kirin.",
        quest3Done = "Novamente você se provou em meu treinamento, e agora o trovão se curva à sua vontade. Use o Kirin com sabedoria, pois é um jutsu poderoso que pode mudar o rumo de qualquer batalha.",

        noLvlQuest4 = "Você chegou longe, |PLAYERNAME|. Mas para aprender o poder supremo, precisa ter {level 150}, manter o status de {Jounnin}, atingir {Rank S} e despertar seu {Mangekyou Sharingan}. Apenas então retorne.",
        quest4 = "Então, você conseguiu... Você despertou seu Mangekyou Sharingan. Impressionante. Muito bem, vou te ensinar o jutsu supremo Uchiha chamado Amaterasu. Você está pronto para controlar as chamas negras que queimam qualquer coisa em seu caminho? Você está pronto para {aprender Amaterasu}?",
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
    ["pt"] = {"ajudar", "uchiha", "tornar", "fazer parte", "sim", "traz", "aprender chidori", "despertar sharingan", "capturar orochimaru", "ajudar o kage"},
    ["en"] = {"help", "uchiha", "become", "join", "yes", "brings", "learn chidori", "awaken sharingan", "capture orochimaru", "kage's request"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local uchihaVocationId = 9
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

    -- Confirmation flow
    if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) then
        if player:getLevel() < 5 then
            npcHandler:say(messages[currentLang].noLvl, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler:say(messages[currentLang].confirm, cid)
        npcHandler.topic[cid] = 2
        return true
    elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) then
        player:setVocation(Vocation(uchihaVocationId))
        player:save()
        player:setOutfit({lookType = 390})
        player:addOutfit(390)
        player:learnSpell("Katon Goukakyuu")
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 0) -- Aprendeu Katon Goukakyuu
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Check which jutsu the player can learn
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
        
        -- Determine which is the next jutsu based on storage
        -- Quest 1: Chidori (lvl 40 + Raiton + Rank C)
        if uchihaJutsu == 0 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end
            
            if player:getLevel() < 40 or getRankLevel(playerRank) < 2 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                -- TODO: Add Raiton element verification when element storage is implemented
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif uchihaJutsu == 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
        elseif uchihaJutsu == 2 then
            -- Player completed mission with Kakashi, now Fugaku delivers Chidori
            npcHandler:say(messages[currentLang].quest1Done, cid)
            player:learnSpell("Chidori")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 3) -- Learned Chidori
            player:save()
            npcHandler:releaseFocus(cid)
            
        -- Quest 2: Sharingan (lvl 80 + Chunnin + Rank B)
        elseif uchihaJutsu == 3 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 80 or playerGraduation < 2 or getRankLevel(playerRank) < 3 then
            if player:getLevel() < 80 or getRankLevel(playerRank) < 3 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif uchihaJutsu == 4 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
        elseif uchihaJutsu == 5 then
            -- Player completed mission in the ruins, now Fugaku delivers Sharingan
            npcHandler:say(messages[currentLang].quest2Done, cid)
            player:learnSpell("Sharingan")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 6) -- Learned Sharingan
            player:save()
            npcHandler:releaseFocus(cid)
            
        -- Quest 3: Kirin (lvl 120 + Jounnin + Rank A)
        elseif uchihaJutsu == 6 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 120 or playerGraduation < 3 or getRankLevel(playerRank) < 4 then
            if player:getLevel() < 120 or getRankLevel(playerRank) < 4 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif uchihaJutsu == 7 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
        elseif uchihaJutsu == 8 then
            -- Player completed mission with Orochimaru, now Fugaku delivers Kirin
            npcHandler:say(messages[currentLang].quest3Done, cid)
            player:learnSpell("Kirin")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 9) -- Learned Kirin
            player:save()
            npcHandler:releaseFocus(cid)
            
        -- Quest 4: Amaterasu (lvl 150 + Jounnin + Rank S + Mangekyou)
        elseif uchihaJutsu == 9 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 150 or playerGraduation < 3 or getRankLevel(playerRank) < 5 then
            if player:getLevel() < 150 or getRankLevel(playerRank) < 5 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
            else
                -- TODO: Add Mangekyou Sharingan verification when Mangekyou storage is implemented
                npcHandler:say(messages[currentLang].quest4, cid)
                npcHandler.topic[cid] = 40
            end
        elseif uchihaJutsu == 10 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
        elseif uchihaJutsu == 11 then
            -- Player completed mission with the Kage, now Fugaku delivers Amaterasu
            npcHandler:say(messages[currentLang].quest4Done, cid)
            player:learnSpell("Amaterasu")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 12) -- Learned Amaterasu
            player:save()
            npcHandler:releaseFocus(cid)
        else
            npcHandler:say(messages[currentLang].allTechniques, cid)
        end
        return true
    end

    -- Learn Chidori
    if msgcontains(msgLower, "learn chidori") or msgcontains(msgLower, "aprender chidori") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 10) then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Already learned Chidori
        if uchihaJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedChidori, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Must be in the correct storage (0) and correct topic (10)
        if npcHandler.topic[cid] == 10 and uchihaJutsu == 0 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end
            
            -- Validate prerequisites
            if player:getLevel() < 40 or getRankLevel(playerRank) < 2 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
                npcHandler.topic[cid] = 0
                return true
            end
            
            -- Accept the quest and send to Kakashi
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 1) -- Took the mission
            player:save()
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        npcHandler.topic[cid] = 0
        return true
    end

    -- Awaken Sharingan
    if msgcontains(msgLower, "awaken your sharingan") or msgcontains(msgLower, "despertar sharingan") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 20) then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Already learned Sharingan
        if uchihaJutsu >= 6 then
            npcHandler:say(messages[currentLang].alreadyLearnedSharingan, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Must be in the correct storage (3) and correct topic (20)
        if npcHandler.topic[cid] == 20 and uchihaJutsu == 3 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- Validate prerequisites
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 80 or playerGraduation < 2 or getRankLevel(playerRank) < 3 then
            if player:getLevel() < 80 or getRankLevel(playerRank) < 3 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
                npcHandler.topic[cid] = 0
                return true
            end
            
            -- Accept the quest and send to the ruins
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 4) -- Took the ruins mission
            player:save()
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        npcHandler.topic[cid] = 0
        return true
    end

    -- Capture Orochimaru
    if msgcontains(msgLower, "capture orochimaru") or msgcontains(msgLower, "capturar orochimaru") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 30) then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Already learned Kirin
        if uchihaJutsu >= 9 then
            npcHandler:say(messages[currentLang].alreadyLearnedKirin, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Must be in the correct storage (6) and correct topic (30)
        if npcHandler.topic[cid] == 30 and uchihaJutsu == 6 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- Validate prerequisites
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 120 or playerGraduation < 3 or getRankLevel(playerRank) < 4 then
            if player:getLevel() < 120 or getRankLevel(playerRank) < 4 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
                npcHandler.topic[cid] = 0
                return true
            end
            
            -- Accept the quest and send to capture Orochimaru
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 7) -- Took the mission to capture Orochimaru
            player:save()
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        npcHandler.topic[cid] = 0
        return true
    end

    -- Kage's Request
    if msgcontains(msgLower, "kage's request") or msgcontains(msgLower, "ajudar o kage") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 40) then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Already learned Amaterasu
        if uchihaJutsu >= 12 then
            npcHandler:say(messages[currentLang].alreadyLearnedAmaterasu, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Must be in the correct storage (9) and correct topic (40)
        if npcHandler.topic[cid] == 40 and uchihaJutsu == 9 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end
            
            -- Validate prerequisites
            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is implemented
            -- if player:getLevel() < 150 or playerGraduation < 3 or getRankLevel(playerRank) < 5 then
            if player:getLevel() < 150 or getRankLevel(playerRank) < 5 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
                npcHandler.topic[cid] = 0
                return true
            end
            
            -- Accept the quest and send to the Kage
            player:setStorageValue(UCHIHA_JUTSU_STORAGE, 10) -- Took the Kage mission
            player:save()
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
