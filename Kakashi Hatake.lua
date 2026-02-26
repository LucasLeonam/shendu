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
        greet = "Hello there. What a perfect day to read a book, don't you think?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        noQuest = "I'm busy right now reading Jiraya's latest novel now, sorry kiddo.",
        help = "I {train} ninjas who show potential. If Fugaku sent you, it means you're ready to learn about lightning control.",
        chidori1 = "So let's start your training. Raiton is a raw power, but without discipline, it will consume you from within. First, try to hit the {training targets} I've set up. Use your {Raiton Release} skill, but focus on accuracy, not power. When you're finished with this task, let's do a staged battle.",
        chidori1Incomplete = "You haven't completed the target practice yet. Focus. Speed without control is useless.",
        chidori1Completed = "Not bad. Your aim improved. I think you too had some visions of what uncontrolled Raiton can do, right? That was the effect of my genjutsu.",
        chidori2 =  "Now let's finish your training with a 1v1 fight... With me. Use your {Raiton Release} strategically to defeat me. If you can't control yourself, I might have to knock you out, so be careful. When you're {ready to fight}, just tell me.",
            combatRetry = "Glad to see being wiped out by me didn't let you lose faith. I had to knock you out cause you was losing control of the Raiton element, and it could cause your death. So, after experiencing the lost of control, do you want to {try again}? Maybe this time, you learn to control yourself in a battle.",
        chidori2Incomplete = "So you came back to continue your training, |PLAYERNAME|. Are you {ready to fight} yet?",
        chidori2Completed = "Impressive. You've learned control under pressure. That's the foundation of Chidori. Now return to Fugaku. I've already sent a word to him.",
        alreadyCompleted = "You've already completed my training. Have you already reported to Fugaku?.",

        -- help = "I {train} ninjas who show potential. If Fugaku sent you, it means you're ready to learn about lightning control.",
        -- startTraining = "Good. Raiton is raw power, but without discipline, it will consume you from within. Your body can't handle uncontrolled lightning. I will teach you {control}. Are you prepared?",
        -- acceptTraining = "Then let's begin. First, you need to understand speed and precision. Hit the {training targets} I've set up. Use your {Raiton Release} skill, but focus on accuracy, not power.",
        -- targetsIncomplete = "You haven't completed the target practice yet. Focus. Speed without control is useless.",
        -- targetsCompleted = "Not bad. Your aim improved. I think you too had some visions of what uncontrolled Raiton can do, right? That was the effect of my genjutsu. Now let's finish your training with a 1v1 fight... With me. Use your {Raiton Release} strategically to defeat me. If you can't control yourself, I might have to knock you out, so be careful. When you're {ready to fight}, just tell me.",
        -- combatRetry = "Glad to see being wiped out by me didn't let you lose faith. I had to knock you out cause you was losing control of the Raiton element, and it could cause your death. So, after experiencing the lost of control, do you want to {try again}? Maybe this time, you learn to control yourself in a battle.",
        -- trialSuccess = "Impressive. You've learned control under pressure. That's the foundation of Chidori. Now return to Fugaku. I've already sent a word to him.",
        -- alreadyCompleted = "You've already completed my training. Have you already reported to Fugaku?.",
    },
    
    ["pt"] = {
        greet = "Olá. Que dia perfeito para ler um livro, não acha?",
        
        -- ============================================
        -- UCHIHA CLAN MESSAGES
        -- ============================================
        help = "Eu {treino} ninjas que demonstram potencial. Se Fugaku te enviou, significa que você está pronto para aprender sobre {controle}.",
        noQuest = "Não tenho nada para te ensinar agora. Fale com Fugaku primeiro se busca treinamento.",
        hasQuest = "Ah, Fugaku te enviou. Ele mencionou que você tem potencial com Raiton, mas falta controle. Isso te torna perigoso — para si mesmo e para os outros. Está pronto para começar o {treinamento}?",
        startTraining = "Bom. Raiton é poder bruto, mas sem disciplina, ele te consumirá por dentro. Seu corpo não aguenta raios descontrolados. Vou te ensinar {controle}. Está preparado?",
        acceptTraining = "Então vamos começar. Primeiro, você precisa entender velocidade e precisão. Acerte os {alvos de treinamento} que preparei. Use sua habilidade de Raiton, mas foque em precisão, não em poder.",
        targetsPractice = "Os alvos vão se mover rápido. Não busque poder — busque precisão. Quando estiver pronto, me diga que {completou os alvos}.",
        targetsIncomplete = "Você ainda não completou a prática de alvos. Foco. Velocidade sem controle é inútil.",
        targetsCompleted = "Nada mal. Sua mira melhorou. Acho que você também teve algumas visões do que o Raiton descontrolado pode fazer, certo? Esse foi o efeito do meu genjutsu. Agora vamos finalizar seu treinamento com uma luta 1v1... Comigo. Use seu {Raiton Release} estrategicamente para me derrotar. Se não conseguir se controlar, posso ter que te nocautear, então tenha cuidado. Quando estiver {pronto para lutar}, apenas me diga.",
        combatRetry = "De volta já? Faltou controle da última vez. Seu Raiton estava selvagem, sem foco. Por isso você caiu. Está pronto para {tentar novamente} com melhor disciplina?",
        trialSuccess = "Impressionante. Você aprendeu controle sob pressão. Essa é a fundação do Chidori. Retorne ao Fugaku. Já enviei palavra a ele.",
        alreadyCompleted = "Você já completou meu treinamento. Fugaku vai te dar Chidori. Não há mais nada que eu possa te ensinar sobre esta técnica.",
    }
}

local validWords = {
    ["en"] = {"help", "yes", "mission", "train", "control", "training targets", "ready to fight", "try again"},
    ["pt"] = {"ajudar", "treino", "controle", "alvos de treinamento", "pronto para lutar", "tentar novamente"}
}

local function sendDelayedMessage(cid, message, delay)
    addEvent(function()
        local creature = Creature(cid)
        if creature then
            npcHandler:say(message, cid)
        end
    end, delay)
end

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local currentLang = npcHandler.languages[cid] or "pt"
    
    npcHandler:addFocus(cid)
    if msgcontains(msgLower, "hi") or msgcontains(msgLower, "oi") then
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
    
    -- ============================================
    -- UCHIHA CLAN QUEST FLOW
    -- ============================================
    if player:getVocation():getId() == 9 then
        local uchihaJutsu = player:getStorageValue(UCHIHA_JUTSU_STORAGE)
        if uchihaJutsu == -1 then
            uchihaJutsu = 0
        end
        
        -- Already completed training (storage >= 4)
        if uchihaJutsu >= 4 then
            if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") then
                npcHandler:say(messages[currentLang].alreadyCompleted, cid)
            end
            return true
        end
        
        -- No quest yet (storage < 2)
        if uchihaJutsu < 2 then
            if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "mission") or msgcontains(msgLower, "missao") then
                npcHandler:say(messages[currentLang].noQuest, cid)
            end
            return true
        end
        
        -- Active quest (storage == 2 or 3)
        if uchihaJutsu == 2 or uchihaJutsu == 3 then
            -- Help/Train - Initial conversation
            if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") or msgcontains(msgLower, "mission") or msgcontains(msgLower, "missao") then
                npcHandler:say(messages[currentLang].help, cid)
                npcHandler.topic[cid] = 1
                return true
            end
            
            if (msgcontains(msgLower, "train") or msgcontains(msgLower, "treino")) and npcHandler.topic[cid] == 1 then
                npcHandler:say(messages[currentLang].chidori1, cid)
                player:getPosition():sendMagicEffect(461) -- QuestLog Update Effect
                player:setStorageValue(UCHIHA_JUTSU_STORAGE, 3) -- Training in progress
                npcHandler.topic[cid] = 2
                return true
            end
            
            if npcHandler.topic[cid] == 2 then
                if player:getItemCount(10549) < 1 then
                    npcHandler:say("You need to bring me a ryo to complete this trial. (Testing purposes)", cid)
                    return true
                else
                    player:removeItem(10549, 1)
                    npcHandler:say(messages[currentLang].chidori1Completed, cid)
                    sendDelayedMessage(cid, messages[currentLang].chidori2, 1500)
                    npcHandler.topic[cid] = 3
                    return true
                end
            end

            if npcHandler.topic[cid] == 3 then


            -- Training targets - Complete target practice
            if msgcontains(msgLower, "alvos de treinamento") or msgcontains(msgLower, "training targets") then
                if npcHandler.topic[cid] >= 2 then
                    -- Target practice completed
                    npcHandler:say(messages[currentLang].chidori1Completed, cid)
                    -- Send chidori2 message with 1.5 second delay
                    sendDelayedMessage(cid, messages[currentLang].chidori2, 1500)
                    npcHandler.topic[cid] = 3
                    return true
                else
                    npcHandler:say(messages[currentLang].chidori1Incomplete, cid)
                    return true
                end
            end
            
            -- Ready to fight / Try again - Combat phase
            if msgcontains(msgLower, "pronto para lutar") or msgcontains(msgLower, "ready to fight") or 
               msgcontains(msgLower, "tentar novamente") or msgcontains(msgLower, "try again") then
                
                if npcHandler.topic[cid] >= 3 then
                    -- Check if has ryo (ID: 10549) to simulate fight
                    if player:getItemCount(10549) < 1 then
                        npcHandler:say("You need to bring me a ryo to complete this trial. (Testing purposes)", cid)
                        return true
                    end
                    
                    -- Complete training
                    player:removeItem(10549, 1)
                    npcHandler:say(messages[currentLang].chidori2Completed, cid)
                    player:setStorageValue(UCHIHA_JUTSU_STORAGE, 4) -- Completed training
                    player:getPosition():sendMagicEffect(461) -- QuestLog Update Effect
                    player:save()
                    npcHandler:releaseFocus(cid)
                    npcHandler.topic[cid] = 0
                    return true
                else
                    npcHandler:say(messages[currentLang].chidori2Incomplete, cid)
                    return true
                end
            end
        end
        
        return true
    end
    -- ============================================
    -- END UCHIHA CLAN QUEST FLOW
    -- ============================================

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
