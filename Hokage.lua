local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Unique storage to track Uchiha clan progress
local UCHIHA_JUTSU_STORAGE = 70002

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        greet = "Welcome to my office. Please, have a seat. What brings you here?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        noQuest = "I don't have any missions for you at this time. Continue your training and return when you're stronger.",
        hasQuest = "Ah, |PLAYERNAME|. Fugaku mentioned you might come. I have a {sensitive matter} that requires your attention.",
        matter = "It's about the Uchiha massacre. For years, we've been told it was the work of a single rogue ninja. But I've uncovered evidence that suggests otherwise. The {truth} is far more complex.",
        truth = "I need someone I can trust to investigate this. Someone from the Uchiha clan who deserves to know what really happened. Are you willing to {uncover the truth}?",
        accept = "Good. I'll need you to infiltrate an old ANBU archive. It's heavily guarded, but I'll give you clearance. Inside, you'll find classified documents about the night of the massacre. Retrieve them and bring them back to me. Tell me when you're {ready for the mission}.",
        mission = "The archive is hidden beneath the village. Here are your clearance codes. Be careful — not everyone in ANBU knows about this investigation. If you're caught, I can't protect you. Now go.",
        incomplete = "You haven't retrieved the documents yet. Return to the ANBU archive and complete your mission.",
        retrievedDocs = "You've returned. Do you have the {documents}?",
        documents = "Let me see them... Yes, these are the ones. *reads carefully* Just as I suspected. The massacre wasn't a crime of passion. It was... an order. A village-sanctioned execution.",
        reveal = "The Uchiha clan was planning a coup d'état. The village elders ordered the massacre to prevent civil war. And the one who carried it out... was ordered by the village itself. But there's more... There was a {witness}.",
        witness = "Your own clansman. Someone who survived that night and chose to protect the village's secret. Someone who carries the burden of that choice even now. I cannot tell you who without their permission, but... you deserve to know this much.",
        emotional = "*watches as the weight of the revelation sinks in* I know this is difficult, |PLAYERNAME|. The truth often is. But you needed to know. Your clan wasn't destroyed out of madness — it was destroyed to save the village from itself.",
        awakening = "This knowledge you now carry will shape your future. Whether your eyes awaken further is your journey to take. Use what you've learned wisely.",
        complete = "Return to Fugaku. Tell him everything you've learned here. He may recognize if your eyes have evolved further. And |PLAYERNAME|... I'm sorry. For what happened to your clan. For what the village did.",
        alreadyCompleted = "You've already learned the truth about the Uchiha massacre. There's nothing more I can tell you about this matter. Focus on your future now.",
    },
    
    ["pt"] = {
        greet = "Bem-vindo ao meu escritório. Por favor, sente-se. O que te traz aqui?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        noQuest = "Não tenho missões para você no momento. Continue seu treinamento e retorne quando estiver mais forte.",
        hasQuest = "Ah, |PLAYERNAME|. Fugaku mencionou que você poderia vir. Tenho um {assunto delicado} que requer sua atenção.",
        matter = "É sobre o massacre Uchiha. Por anos, nos disseram que foi obra de um único ninja renegado. Mas descobri evidências que sugerem o contrário. A {verdade} é muito mais complexa.",
        truth = "Preciso de alguém em quem possa confiar para investigar isso. Alguém do clã Uchiha que mereça saber o que realmente aconteceu. Você está disposto a {descobrir a verdade}?",
        accept = "Bom. Vou precisar que você infiltre um antigo arquivo ANBU. É fortemente guardado, mas darei autorização. Lá dentro, você encontrará documentos classificados sobre a noite do massacre. Recupere-os e traga de volta. Me diga quando estiver {pronto para a missão}.",
        mission = "O arquivo está escondido embaixo da vila. Aqui estão seus códigos de acesso. Cuidado — nem todos na ANBU sabem desta investigação. Se for pego, não posso te proteger. Agora vá.",
        incomplete = "Você ainda não recuperou os documentos. Retorne ao arquivo ANBU e complete sua missão.",
        retrievedDocs = "Você voltou. Tem os {documentos}?",
        documents = "Deixe-me ver... Sim, são estes. *lê cuidadosamente* Como eu suspeitava. O massacre não foi um crime passional. Foi... uma ordem. Uma execução sancionada pela vila.",
        reveal = "O clã Uchiha estava planejando um golpe de estado. Os anciãos da vila ordenaram o massacre para prevenir uma guerra civil. E quem executou... foi ordenado pela própria vila. Mas há mais... Havia uma {testemunha}.",
        witness = "Seu próprio membro do clã. Alguém que sobreviveu àquela noite e escolheu proteger o segredo da vila. Alguém que carrega o fardo dessa escolha até hoje. Não posso te dizer quem sem a permissão dele, mas... você merece saber ao menos isso.",
        emotional = "*observa enquanto o peso da revelação afunda* Sei que isso é difícil, |PLAYERNAME|. A verdade frequentemente é. Mas você precisava saber. Seu clã não foi destruído por loucura — foi destruído para salvar a vila de si mesma.",
        awakening = "O conhecimento que você carrega agora moldará seu futuro. Se seus olhos despertarem para formas superiores é sua jornada a seguir. Use o que aprendeu sabiamente.",
        complete = "Retorne ao Fugaku. Conte-lhe tudo que aprendeu aqui. Ele pode reconhecer se seus olhos evoluíram para formas superiores. E |PLAYERNAME|... Me desculpe. Pelo que aconteceu com seu clã. Pelo que a vila fez.",
        alreadyCompleted = "Você já aprendeu a verdade sobre o massacre Uchiha. Não há mais nada que eu possa te contar sobre este assunto. Foque em seu futuro agora.",
        
    }
}

local validWords = {
    ["pt"] = {"assunto delicado", "verdade", "descobrir a verdade", "sim", "pronto para a missão", "documentos", "testemunha", "mangekyou sharingan"},
    ["en"] = {"sensitive matter", "truth", "uncover the truth", "yes", "ready for the mission", "documents", "witness", "mangekyou sharingan"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local currentLang = npcHandler.languages[cid] or "pt"
    
    npcHandler:addFocus(cid)
    
    if msgcontains(msgLower, "oi") or msgcontains(msgLower, "olá") or msgcontains(msgLower, "hi") or msgcontains(msgLower, "hello") then
        npcHandler:say(messages[currentLang].greet, cid)
        return true
    end
    
    -- Block messages outside the defined language
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
    
    local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
    if uchihaJutsu == -1 then
        uchihaJutsu = 0
    end
    
    -- Check if is Uchiha to follow the quest flow
    if player:getVocation():getId() ~= 9 then
        npcHandler:say(messages[currentLang].greet, cid)
        npcHandler:releaseFocus(cid)
        return true
    end
    
    -- Check if has the quest
    if uchihaJutsu < 10 then
        npcHandler:say(messages[currentLang].noQuest, cid)
        npcHandler:releaseFocus(cid)
        return true
    end
    
    if uchihaJutsu >= 11 then
        npcHandler:say(messages[currentLang].alreadyCompleted, cid)
        npcHandler:releaseFocus(cid)
        return true
    end
    
    -- Quest flow (Storage 10)
    if msgcontains(msgLower, "assunto delicado") or msgcontains(msgLower, "sensitive matter") then
        npcHandler:say(messages[currentLang].matter, cid)
        npcHandler.topic[cid] = 1
        return true
    end
    
    if (msgcontains(msgLower, "verdade") or msgcontains(msgLower, "truth")) and npcHandler.topic[cid] == 1 then
        npcHandler:say(messages[currentLang].truth, cid)
        npcHandler.topic[cid] = 2
        return true
    end
    
    if (msgcontains(msgLower, "descobrir a verdade") or msgcontains(msgLower, "uncover the truth") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 2 then
        npcHandler:say(messages[currentLang].accept, cid)
        npcHandler.topic[cid] = 3
        return true
    end
    
    if (msgcontains(msgLower, "pronto para a missão") or msgcontains(msgLower, "ready for the mission") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 3 then
        npcHandler:say(messages[currentLang].mission, cid)
        -- Here you would implement the teleport to the ANBU archive or give a quest item
        npcHandler:releaseFocus(cid)
        return true
    end
    
    -- When returns with the documents (you would need to check if has a specific item)
    if msgcontains(msgLower, "documentos") or msgcontains(msgLower, "documents") then
        -- Here you would check if the player has the documents item
        -- For now, let's simulate that they have it
        npcHandler:say(messages[currentLang].documents, cid)
        npcHandler.topic[cid] = 4
        
        addEvent(function()
            if Player(cid) then
                npcHandler:say(messages[currentLang].reveal, cid)
                npcHandler.topic[cid] = 5
            end
        end, 4000)
        return true
    end
    
    if (msgcontains(msgLower, "testemunha") or msgcontains(msgLower, "witness")) and npcHandler.topic[cid] == 5 then
        npcHandler:say(string.gsub(messages[currentLang].emotional, "|PLAYERNAME|", player:getName()), cid)
        npcHandler.topic[cid] = 6
        
        addEvent(function()
            if Player(cid) then
                npcHandler:say(messages[currentLang].awakening, cid)
                player:getPosition():sendMagicEffect(CONST_ME_FIREATTACK) -- Visual effect of awakening
                npcHandler.topic[cid] = 7
            end
        end, 4000)
        return true
    end
    
    if (msgcontains(msgLower, "mangekyou sharingan") or msgcontains(msgLower, "mangekyou sharingan")) and npcHandler.topic[cid] == 7 then
        -- Check if has the ryo (ID: 10549) for testing
        if player:getItemCount(10549) < 1 then
            npcHandler:say("You need to bring me a ryo to prove you retrieved the documents. (Testing purposes)", cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        -- Remove the ryo and complete the mission
        player:removeItem(10549, 1)
        npcHandler:say(string.gsub(messages[currentLang].complete, "|PLAYERNAME|", player:getName()), cid)
        player:setStorageValue(UCHIHA_JUTSU_STORAGE, 11) -- Completed Kage mission
        player:save()
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    return true
    -- ============================================
    -- END UCHIHA CLAN QUEST FLOW
    -- ============================================

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
