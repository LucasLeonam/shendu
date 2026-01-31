local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Nenhum jutsu
-- Storage >= 1: Aprendeu Ninpou Souzou Saisei
-- Storage >= 2: Aprendeu Shousen Jutsu
-- Storage >= 3: Aprendeu Sakuraichi
-- Storage >= 4: Aprendeu Okasho
local HARUNO_JUTSU_STORAGE = 70003

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Sakura Haruno, and I assist ninjas of the {Haruno} clan. Do you need anything from me?",
        noLvl = "Sorry, but I think you need to get a bit stronger to join us. Talk to me again when you get level 5!",
        askHaruno = "Oh! You want to {become} a member of Haruno clan? Our clan focus in healing and helping others. This is the path you want to follow?",
        confirm = "So you really like helping other then? Okay! I will ask one more time for good measure. You really want to {join} Haruno clan?",
        done = "Great! Now you are, too, a member of our clan! Continue your training and remember to always help those in need. I will also teach you a jutsu named {Shannaro}, because you need to hit your foes too, right? Protect yourself to protect others!",
        isHaruno = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "Hey |PLAYERNAME|! I don't know how to say this, but I kinda can't teach you right now. Return to me when you are at least level 50 and I can teach you something nice!",
        quest1 = "Oh! You've got stronger, I can see it. Now I can finally teach you {Ninpou Souzou Saisei}, a jutsu that constantly recover you while you're fighting. Are you ready to {learn Ninpou Souzou Saisei}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Ninpou Souzou Saisei.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Ninpou Souzou Saisei.",
        quest1Done = "Great! With that jutsu, you can continue helping others in the battlefield without worrying too much about yourself. Go and never let a fellow companion of our village dies before your eyes!",

        noLvlQuest2 = "Hello |PLAYERNAME|! I know the right jutsu to teach you, but it looks like you're not ready yet. The chakra control to use this is more than you have right now. Please get level 80 and talk to me again.",
        quest2 = "Aha! Now I feel that you chakra control is on point to learn {Shousen Jutsu}. This jutsu creates an area with healing properties that will constantly heal anyone in it. Are you ready to make your chakra control work in a constant way outside your body? Are you ready to {learn Shousen Jutsu}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Shousen Jutsu.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Shousen Jutsu.",
        quest2Done = "Yes! I'm so proud of you being a part of the Haruno Clan. Now everyone is safer when you're around. But don't worry, I have more techniques to teach you. Let's talk again sometime.",

        noLvlQuest3 = "I know I've told you that I would teach you some new techniques later, but don't you think it's too soon? Those new techniques are meant to be taught to {graduated ninjas} around level 100. Let's talk again when you get there, okay? I believe in you!",
        quest3 = "Yees! You've became a powerful ninja! A lot of people are talking about you and all the help you've been doing in the battlefield. I think it's time to teach you a technique called {Sakuraichi}. It's a jutsu that uses cherry blossoms to damage anything in front of you. If you can defeat the enemy before it hurt your teammates, everyone wins, right?",
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Sakuraichi.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Sakuraichi.",
        quest3Done = "Fantastic! More and more you proven yourself to me and all the Haruno clan. I don't think there's anyone that can defeat you or your teammates in battle. Now there's a little that I can teach you, but I really hope you continue growing stronger for the sake of our village.",

        noLvlQuest4 = "Hey |PLAYERNAME|! I see that you eager to learn from me again, but I don't think you're ready yet. This technique requires more power than you have right now. If you try this now, your arms might break, so... Yeah! Try getting level 120. I think that would be sufficient!",
        quest4 = "Look at those muscles! Now it's time to teach you {Okasho}. Again, a jutsu that uses Cherry Blossoms, but this time, you'll use pure strength too. Are you ready to initiate my training?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Okasho.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Okasho.",
        quest4Done = "Yeees! That was awesome! With this technique, no one will ever get near you or your teammates! Of course, you'll need to be at the center of the battle to use it well, but I know that will be no problem for you!",
        
        alreadyLearnedNinpou = "You have already learned Ninpou Souzou Saisei from me.",
        alreadyLearnedShousen = "You have already learned Shousen Jutsu from me.",
        alreadyLearnedSakuraichi = "You have already learned Sakuraichi from me.",
        alreadyLearnedOkasho = "You have already learned Okasho from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Meu nome é Sakura Haruno, e eu auxilio ninjas do clã {Haruno}. Você precisa de algo de mim?",
        noLvl = "Desculpe, mas acho que você precisa ficar um pouco mais forte para se juntar a nós. Fale comigo novamente quando atingir o nível 5!",
        askHaruno = "Oh! Você quer se {tornar} um membro do clã Haruno? Nosso clã foca em curar e ajudar os outros. Este é o caminho que você quer seguir?",
        confirm = "Então você realmente gosta de ajudar os outros? Ok! Vou perguntar mais uma vez para ter certeza. Você realmente quer {fazer parte} do clã Haruno?",
        done = "Ótimo! Agora você também é um membro do nosso clã! Continue seu treinamento e lembre-se de sempre ajudar aqueles que precisam. Também vou te ensinar um jutsu chamado {Shannaro}, porque você precisa bater nos seus inimigos também, certo? Proteja-se para proteger os outros!",
        isHaruno = "Olá |PLAYERNAME|, o que {traz} você aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te ajudar.",

        noLvlQuest1 = "Hey |PLAYERNAME|! Não sei como dizer isso, mas meio que não posso te ensinar agora. Volte para mim quando estiver pelo menos no nível 50 e eu poderei te ensinar algo legal!",
        quest1 = "Oh! Você ficou mais forte, eu posso ver isso. Agora finalmente posso te ensinar {Ninpou Souzou Saisei}, um jutsu que te recupera constantemente enquanto você está lutando. Você está pronto para {aprender Ninpou Souzou Saisei}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Ninpou Souzou Saisei.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Ninpou Souzou Saisei.",
        quest1Done = "Ótimo! Com esse jutsu, você pode continuar ajudando os outros no campo de batalha sem se preocupar muito consigo mesmo. Vá e nunca deixe um companheiro da nossa vila morrer diante dos seus olhos!",

        noLvlQuest2 = "Olá |PLAYERNAME|! Eu sei o jutsu certo para te ensinar, mas parece que você ainda não está pronto. O controle de chakra para usar isso é mais do que você tem agora. Por favor, alcance o nível 80 e fale comigo novamente.",
        quest2 = "Aha! Agora sinto que seu controle de chakra está no ponto para aprender {Shousen Jutsu}. Este jutsu cria uma área com propriedades curativas que curará constantemente qualquer pessoa dentro dela. Você está pronto para fazer seu controle de chakra funcionar de maneira constante fora do seu corpo? Você está pronto para {aprender Shousen Jutsu}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Shousen Jutsu.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Shousen Jutsu.",
        quest2Done = "Isso! Estou tão orgulhosa de você por fazer parte do Clã Haruno. Agora todos estão mais seguros quando você está por perto. Mas não se preocupe, tenho mais técnicas para te ensinar. Vamos conversar novamente outra hora.",

        noLvlQuest3 = "Eu sei que te disse que te ensinaria algumas novas técnicas mais tarde, mas você não acha que é cedo demais? Essas novas técnicas são destinadas a serem ensinadas a {ninjas formados} por volta do nível 100. Vamos conversar novamente quando você chegar lá, ok? Eu acredito em você!",
        quest3 = "Issooo! Você se tornou um ninja poderoso! Muitas pessoas estão falando sobre você e toda a ajuda que você tem dado no campo de batalha. Acho que é hora de te ensinar uma técnica chamada {Sakuraichi}. É um jutsu que usa flores de cerejeira para infligir dano a qualquer um na sua frente. Se você puder derrotar o inimigo antes que ele machuque seus companheiros, todos ganham, certo?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Sakuraichi.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Sakuraichi.",
        quest3Done = "Fantástico! Mais e mais você se provou para mim e para todo o clã Haruno. Não acho que haja alguém que possa derrotar você ou seus companheiros em batalha. Agora há pouco que posso te ensinar, mas espero realmente que você continue crescendo mais forte pelo bem da nossa vila.",

        noLvlQuest4 = "Hey |PLAYERNAME|! Vejo que você está ansioso para aprender comigo novamente, mas não acho que você esteja pronto ainda. Esta técnica requer mais poder do que você tem agora. Se você tentar isso agora, seus braços podem quebrar, então... Sim! Tente chegar ao nível 120. Acho que isso seria suficiente!",
        quest4 = "Olha só esses músculos! Agora é hora de te ensinar {Okasho}. Novamente, um jutsu que usa flores de cerejeira, mas desta vez, você também usará força pura. Você está pronto para iniciar meu treinamento?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Okasho.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Okasho.",
        quest4Done = "Siiim! Isso foi incrível! Com essa técnica, ninguém chegará perto de você ou de seus companheiros! Claro, você precisará estar no centro da batalha para usá-la bem, mas eu sei que isso não será um problema para você!",

        alreadyLearnedNinpou = "Você já aprendeu Ninpou Souzou Saisei de mim.",
        alreadyLearnedShousen = "Você já aprendeu Shousen Jutsu de mim.",
        alreadyLearnedSakuraichi = "Você já aprendeu Sakuraichi de mim.",
        alreadyLearnedOkasho = "Você já aprendeu Okasho de mim.",
        allTechniques = "Você já dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "haruno", "tornar", "fazer parte", "traz", "aprender ninpou souzou saisei", "aprender shousen jutsu", "aprender sakuraichi", "aprender okasho"},
    ["en"] = {"help", "haruno", "become", "join", "brings", "learn ninpou souzou saisei", "learn shousen jutsu", "learn sakuraichi", "learn okasho"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local harunoVocationId = 11
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

    -- Fluxo Haruno
    if msgcontains(msgLower, "haruno") then
        if playerVocation ~= 0 and playerVocation ~= harunoVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == harunoVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isHaruno, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askHaruno, cid)
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
        player:setVocation(Vocation(harunoVocationId))
        player:save()
        player:setOutfit({lookType = 400})
        player:addOutfit(400)
        player:learnSpell("Shannaro")
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Verifica qual jutsu o jogador pode aprender
    if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
        if playerVocation ~= harunoVocationId then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end
        
        -- Determinar qual é o próximo jutsu baseado no storage
        if harunoJutsu == 0 then
            if player:getLevel() < 50 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif harunoJutsu == 1 then
            if player:getLevel() < 80 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif harunoJutsu == 2 then
            if player:getLevel() < 100 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif harunoJutsu == 3 then
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

    -- Learn Ninpou Souzou Saisei
    if msgcontains(msgLower, "learn ninpou") or msgcontains(msgLower, "aprender ninpou") then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
        end
        
        if harunoJutsu >= 1 then
            npcHandler:say(messages[currentLang].alreadyLearnedNinpou, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Ninpou Souzou Saisei")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HARUNO_JUTSU_STORAGE, 1)
        player:save()
        npcHandler:say(messages[currentLang].quest1Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Shousen Jutsu
    if msgcontains(msgLower, "learn shousen") or msgcontains(msgLower, "aprender shousen") then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if harunoJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearnedShousen, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Shousen Jutsu")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HARUNO_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Sakuraichi
    if msgcontains(msgLower, "learn sakuraichi") or msgcontains(msgLower, "aprender sakuraichi") then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if harunoJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedSakuraichi, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Sakuraichi")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HARUNO_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Okasho
    if msgcontains(msgLower, "learn okasho") or msgcontains(msgLower, "aprender okasho") then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if harunoJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearnedOkasho, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Okasho")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(HARUNO_JUTSU_STORAGE, 4)
        player:save()
        npcHandler:say(messages[currentLang].quest4Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
