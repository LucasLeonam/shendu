local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Aprendeu Hakkeshou Kaiten (Ao se tornar Hyuuga)
-- Storage >= 1: Aprendeu Byakugan (lvl 40)
-- Storage >= 2: Aprendeu 8 Tigrams Palm (lvl 80)
-- Storage >= 3: Aprendeu TBD (lvl 120 + graduated)
-- Storage >= 4: Aprendeu 64 Tigrams Palm (lvl 150 + graduated)
local HYUUGA_JUTSU_STORAGE = 70005

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Hizashi Hyuuga, and I assist ninjas of the branch family of the {Hyuuga} clan. Do you need anything from me?",
        noLvl = "Sorry, but you're not strong enough to join us. Talk to me again when you're at least {level 5}.",
        askHyuuga = "So you're here to {become} part of the branch family. Strange choice, but I won't go against it.",
        confirm = "All right. I sense a strong sense of duty in you. Know that we only exist to protect the main family and, being a member of the branch family, you'll receive a curse. Knowing that, are you really sure you want to {join} us?",
        done = "It is done. Now you are, too, a part of the strongest clan. Work hard and do whatever it takes to protect your brothers and sisters from the main family. I will also teach you {Hakkeshou Kaiten}, a strong technique that protects you while doing damage to everything around you. Now go, train, and get stronger.",
        isHyuuga = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "I admire your determination, but you are not ready yet to learn from me. Try to get to at least {level 40} to start learning from me.",
        quest1 = "Great. I see your power has grown since the last time we spoke. I think now it's a great time to teach you Byakugan, a powerful ocular technique that allows you to see everything in a near 360-degree radius, x-ray vision, chakra pathways, and tenketsus. Are you ready to {learn Byakugan}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Byakugan.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Byakugan.",
        quest1Done = "Your eyes reflect your determination. Now nothing can catch you by surprise. Continue training and protecting the main family.",

        noLvlQuest2 = "I see. You want to learn from me again. But it is not possible right now. You need more power and control to use the jutsu I want to teach you. Return to me when you're at least {level 80}.",
        quest2 = "It looks like you now have the right amount of control of your chakra, so I can teach you how to expel chakra from your own tenketsus. This next jutsu uses this exact logic to disable 8 of your opponent's tenketsus. Are you ready to {learn 8 Tigrams Palm}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 8 Tigrams Palm.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 8 Tigrams Palm.",
        quest2Done = "I see you achieved total control of your tenketsus. Remember that when you hit your opponent's tenketsu, the chakra can't flow through them. Use it to your advantage.",

        noLvlQuest3 = "You are eager to learn, is it not? I have heard of your achievements, and the main family is very happy about your contributions, but it's not time to teach you yet. {Level 120} would be fine for now. Return to me when you are ready.",
        quest3 = "Hello, protector. I have received permission to teach you a technique named TBD. This technique TBD. Are you ready to {learn TBD}?",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you TBD.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you TBD.",
        quest3Done = "TBD.",

        noLvlQuest4 = "Hello, |PLAYERNAME|. The main family informed me that you are one of our strongest members now and have given me authority to teach you a jutsu that only the main family and some elite members can use. However, I do not think you are strong enough. That said, when you get at least {level 150}, I can teach you something new.",
        quest4 = "I almost didn't see you getting near me. This only shows that your control over chakra is impressive. There's a technique I'm eager to teach you. This technique allows you to use your Byakugan to hit everyone around you using Tigrams Palm. In this way, you hit 64 tenketsus of your opponents. You can, of course, share these 64 among your enemies. That said, are you ready to {learn 64 Tigrams Palm}?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you 64 Tigrams Palm.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you 64 Tigrams Palm.",
        quest4Done = "Well, that was unexpected, but I'm not surprised. You mastered the head of the main family's jutsu like it was nothing. The strongest clan shows promising members once again. Continue protecting the main family, and never forget your place.",
        
        alreadyLearnedByakugan = "You have already learned Byakugan from me.",
        alreadyLearned8TigramsPalm = "You have already learned 8 Tigrams Palm from me.",
        alreadyLearnedTBD = "You have already learned TBD from me.",
        alreadyLearned64TigramsPalm = "You have already learned 64 Tigrams Palm from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Meu nome é Hizashi Hyuuga e eu auxilio os ninjas da família secundária do clã {Hyuuga}. Você precisa de algo de mim?",
        noLvl = "Desculpe, mas você não é forte o bastante para se juntar a nós. Fale comigo novamente quando tiver pelo menos {level 5}.",
        askHyuuga = "Então você veio para se {tornar} parte da família secundária. Escolha estranha, mas não vou impedir.",
        confirm = "Tudo bem. Sinto um forte senso de dever em você. Saiba que existimos apenas para proteger a família principal e, sendo um membro da família secundária, você receberá uma maldição. Sabendo disso, você realmente quer {fazer parte} do nosso clã?",
        done = "Feito. Agora você também faz parte do clã mais forte. Trabalhe duro e faça o que for preciso para proteger seus irmãos e irmãs da família principal. Também vou te ensinar {Hakkeshou Kaiten}, uma técnica forte que te protege enquanto causa dano a tudo ao redor. Agora vá, treine e fique mais forte.",
        isHyuuga = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te auxiliar.",

        noLvlQuest1 = "Admiro sua determinação, mas você ainda não está pronto para aprender comigo. Tente chegar pelo menos ao {level 40} para que eu lhe ensine algo.",
        quest1 = "Ótimo. Vejo que seu poder cresceu desde a última vez que conversamos. Acho que agora é um ótimo momento para te ensinar o Byakugan, uma técnica ocular poderosa que permite ver tudo em um raio de quase 360 graus, visão de raio-x, caminhos de chakra e tenketsus. Você está pronto para {aprender Byakugan}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Byakugan.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Byakugan.",
        quest1Done = "Seus olhos refletem sua determinação. Agora nada vai te pegar de surpresa. Continue treinando e protegendo a família principal.",

        noLvlQuest2 = "Entendo. Você quer aprender comigo de novo. Mas isso não é possível agora. Você precisa de mais poder e controle para usar o jutsu que quero te ensinar. Volte quando tiver pelo menos {level 80}.",
        quest2 = "Parece que agora você tem o controle certo do seu chakra, então posso te ensinar a expelir chakra pelos próprios tenketsus. Este próximo jutsu usa exatamente essa lógica para desativar 8 tenketsus do seu oponente. Você está pronto para {aprender 8 Tigrams Palm}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 8 Tigrams Palm.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 8 Tigrams Palm.",
        quest2Done = "Vejo que você alcançou controle total dos seus tenketsus. Lembre-se de que, quando você atinge o tenketsu do oponente, ele não pode mais usar chakra. Use isso a seu favor.",

        noLvlQuest3 = "Você está ansioso para aprender, não é? Ouvi sobre suas conquistas e a família principal está muito satisfeita com suas contribuições, mas ainda não é hora de te ensinar. {Level 120} seria suficiente por enquanto. Volte quando estiver pronto.",
        quest3 = "Olá, protetor. Recebi permissão para te ensinar uma técnica chamada TBD. Esta técnica TBD. Você está pronto para {aprender TBD}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei TBD.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei TBD.",
        quest3Done = "TBD.",

        noLvlQuest4 = "Olá, |PLAYERNAME|. A família principal me informou que você é um dos nossos membros mais fortes agora e me deu autorização para te ensinar um jutsu que apenas a família principal e alguns membros de elite podem usar. No entanto, não acho que você seja forte o bastante. Dito isso, quando você tiver pelo menos {level 150}, poderei te ensinar algo novo.",
        quest4 = "Eu quase não vi você se aproximando de mim. Isso só mostra que seu controle sobre o chakra é impressionante. Há uma técnica que estou ansioso para te ensinar. Essa técnica permite usar seu Byakugan para atingir todos ao seu redor usando Tigrams Palm. Assim, você atinge 64 tenketsus dos seus oponentes. Você pode, claro, dividir esses 64 entre seus inimigos. Dito isso, você está pronto para {aprender 64 Tigrams Palm}?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei 64 Tigrams Palm.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei 64 Tigrams Palm.",
        quest4Done = "Bem, isso foi inesperado, mas não estou surpreso. Você dominou o jutsu do líder da família principal como se não fosse nada. O clã mais forte mostra novamente membros promissores. Continue protegendo a família principal e nunca se esqueça do seu lugar.",
        
        alreadyLearnedByakugan = "Você já aprendeu Byakugan de mim.",
        alreadyLearned8TigramsPalm = "Você já aprendeu 8 Tigrams Palm de mim.",
        alreadyLearnedTBD = "Você já aprendeu TBD de mim.",
        alreadyLearned64TigramsPalm = "Você já aprendeu 64 Tigrams Palm de mim.",
        allTechniques = "Você dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "hyuuga", "tornar", "fazer parte", "traz", "aprender byakugan", "aprender 8 tigrams palm", "aprender 64 tigrams palm", "aprender TBD"},
    ["en"] = {"help", "hyuuga", "become", "join", "brings", "learn byakugan", "learn 8 tigrams palm", "learn 64 tigrams palm", "learn TBD"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local hyuugaVocationId = 12
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
        player:setOutfit({lookType = 410})
        player:addOutfit(410)
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

    -- Learn 8 Tigrams Palm
    if msgcontains(msgLower, "learn 8 tigrams palm") or msgcontains(msgLower, "aprender 8 tigrams palm") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if hyuugaJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearned8TigramsPalm, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("8 Tigrams Palm")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn TBD (lvl 100)
    if msgcontains(msgLower, "learn TBD") or msgcontains(msgLower, "aprender TBD") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if hyuugaJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedTBD, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("TBD")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HYUUGA_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn 64 Tigrams Palm
    if msgcontains(msgLower, "learn 64 tigrams palm") or msgcontains(msgLower, "aprender 64 tigrams palm") then
        local hyuugaJutsu = player:getStorageValue(HYUUGA_JUTSU_STORAGE)
        if hyuugaJutsu == -1 then
            hyuugaJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if hyuugaJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearned64TigramsPalm, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("64 Tigrams Palm")
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
